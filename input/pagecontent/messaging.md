As an alternative to the [RESTful Transfer](transfer.html) approach, FHIR also supports a [messaging paradigm]({{site.data.fhir.path}}messaging.html) where a source application sends a message bundle to a destination application when an event occurs. This page describes how FHIR messaging can be used to communicate point-of-care device data.

### When to Use Messaging

FHIR messaging may be appropriate when:

- The infrastructure is based on message-oriented middleware (e.g., Apache Kafka, MQ Series, or MLLP-based transport)
- The deployment mirrors existing HL7 V2 messaging patterns (e.g., IHE PCD-01 DEC) and needs a FHIR-based replacement
- A fire-and-forget notification model is sufficient, and the receiver does not need to provide a RESTful API
- The receiver processes device data in batch rather than managing individual resources

For deployments where a FHIR server manages device resources and supports search and subscription, [RESTful Transfer](transfer.html) is generally preferred.

### Message Bundle Structure

A FHIR message is a [Bundle]({{site.data.fhir.path}}bundle.html) with `type` set to `message`. The first entry must be a [MessageHeader]({{site.data.fhir.path}}messageheader.html) resource. The remaining entries contain the resources referenced by the MessageHeader and any resources they in turn reference. All resources in the bundle must form a connected graph — every resource must be reachable by following references from the MessageHeader.

For point-of-care device data, the `MessageHeader.focus` element references the primary resources being communicated — typically Observation resources for measurement updates, or Device and DeviceMetric resources for device model initialization.

### Message Events

This Implementation Guide does not define formal message events using [MessageDefinition]({{site.data.fhir.path}}messagedefinition.html) resources. Implementers using messaging should define message events appropriate for their deployment.

Typical events for PoCD messaging include:

| Event | Description | Focus Resources |
|---|---|---|
| Device model initialization | Reports the device containment tree when a device connects or is configured | Device, DeviceMetric |
| Observation update | Reports new measurements from a device update cycle | Observation |
| Device status change | Reports a change in device or metric operational status | Device or DeviceMetric |

The message event is conveyed in `MessageHeader.event[x]`, which can be a Coding or a URI.

### Example: Observation Message

The following example shows a message bundle reporting a new observation from a point-of-care device. The MessageHeader references the Observation as its focus. The Observation in turn references the Patient (as subject) and DeviceMetric (as device). All referenced resources are included in the bundle.

```json
{
  "resourceType": "Bundle",
  "type": "message",
  "timestamp": "2024-03-04T15:16:17+00:00",
  "entry": [ {
    "fullUrl": "urn:uuid:a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "resource": {
      "resourceType": "MessageHeader",
      "id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
      "eventCoding": {
        "system": "http://example.org/fhir/message-events",
        "code": "observation-update"
      },
      "source": {
        "endpoint": "http://example.org/fhir/device-gateway"
      },
      "focus": [ {
        "reference": "urn:uuid:obs-1"
      } ]
    }
  },
  {
    "fullUrl": "urn:uuid:obs-1",
    "resource": {
      "resourceType": "Observation",
      "status": "final",
      "code": {
        "coding": [ {
          "system": "urn:iso:std:iso:11073:10101",
          "code": "150087",
          "display": "MDC_PRESS_BLD_VEN_CENT_MEAN"
        } ],
        "text": "CVPm"
      },
      "subject": {
        "reference": "urn:uuid:patient-1"
      },
      "effectiveDateTime": "2024-03-04T15:16:17+00:00",
      "valueQuantity": {
        "value": 5.5,
        "unit": "mmHg",
        "system": "http://unitsofmeasure.org",
        "code": "mm[Hg]"
      },
      "device": {
        "reference": "urn:uuid:metric-1"
      }
    }
  },
  {
    "fullUrl": "urn:uuid:patient-1",
    "resource": {
      "resourceType": "Patient",
      "identifier": [ {
        "system": "http://example.org/fhir/mrn",
        "value": "MRN-12345"
      } ]
    }
  },
  {
    "fullUrl": "urn:uuid:metric-1",
    "resource": {
      "resourceType": "DeviceMetric",
      "type": {
        "coding": [ {
          "system": "urn:iso:std:iso:11073:10101",
          "code": "150084",
          "display": "MDC_PRESS_BLD_VEN_CENT"
        } ],
        "text": "CVP"
      },
      "source": {
        "reference": "urn:uuid:device-1"
      }
    }
  },
  {
    "fullUrl": "urn:uuid:device-1",
    "resource": {
      "resourceType": "Device",
      "identifier": [ {
        "system": "urn:oid:1.2.840.10004.1.1.1.0.0.1.0.0.1.2680",
        "value": "01-23-45-67-89-AB-CD-EF"
      } ],
      "status": "active",
      "type": {
        "coding": [ {
          "system": "urn:iso:std:iso:11073:10101",
          "code": "69965",
          "display": "MDC_DEV_MON_PHYSIO_MULTI_PARAM_MDS"
        } ],
        "text": "Patient Monitor"
      }
    }
  } ]
}
```

### Resource References Across Messages

A key question for messaging implementations is how resources are identified and referenced across multiple messages over time. This is an area where the FHIR core specification provides limited guidance for the PoCD use case, and implementers need to make deliberate design choices.

#### The Challenge

In a RESTful approach, resources are created on a server and receive server-assigned logical IDs (e.g., `Device/1234`). Subsequent interactions reference these stable IDs. In messaging, there is no server assigning IDs — the sender constructs each message bundle independently. This raises questions:

- How does the receiver correlate a Device resource in message 2 with the same device in message 1?
- When an Observation in a new message references a DeviceMetric, how does the receiver know which DeviceMetric it is if the DeviceMetric was sent in a previous message?
- Should every message be self-contained, or can messages reference resources from earlier messages?

#### Recommended Approach: Self-Contained Messages with Business Identifiers

This Implementation Guide recommends that each message bundle be **self-contained** — that is, it includes all resources needed for the receiver to process the message without depending on state from prior messages. This means:

1. **Include referenced resources in every message.** An Observation message should include the Patient, DeviceMetric, and Device resources it references, not just the Observation. This ensures each message can be processed independently and in any order.

2. **Use business identifiers for correlation.** Resources should carry stable business identifiers (in the `identifier` element) that the receiver can use to correlate resources across messages. For example:
   - `Device.identifier` with the EUI-64 address
   - `Patient.identifier` with the MRN
   - `DeviceMetric.type` combined with `DeviceMetric.source` to identify a specific metric on a specific device

3. **Use UUIDs as fullUrl within a bundle.** The `fullUrl` values (e.g., `urn:uuid:...`) are used for intra-bundle references and have no meaning outside the message. They may change between messages.

#### Alternative: Stateful Messaging with Persistent References

In some deployments, a stateful approach may be acceptable where:

- An initial message establishes the device model (Device and DeviceMetric resources) with identifiers that both sender and receiver agree to treat as persistent
- Subsequent messages reference those identifiers without re-including the full resources
- The receiver is expected to have processed and retained the initial message

This reduces message size but introduces coupling between messages. If the receiver misses the initial message, subsequent messages cannot be fully interpreted. Implementations choosing this approach should define a mechanism for the receiver to request retransmission of the device model, and should consider including a sequence number or session identifier so the receiver can detect gaps.

#### Summary of Approaches

| Aspect | Self-Contained | Stateful |
|---|---|---|
| Each message processable independently | Yes | No — depends on prior messages |
| Message size | Larger (includes context) | Smaller (observations only) |
| Receiver complexity | Simpler — no state to maintain | More complex — must cache device model |
| Tolerance for lost messages | High | Low — gaps break context |
| Suitable for | Notification-style messaging, unreliable transport | Persistent connections, reliable transport |

### Message Category

For PoCD device data, messages are typically **notifications** — the content represents the current state or a new measurement, and reprocessing a message is generally harmless. The receiver may safely discard a message if a more recent one has already been processed.

However, if messaging is used for device configuration or commands (e.g., changing a setting), those messages should be treated as **consequence** messages where duplicate processing must be avoided.

### Processing Messages

A receiver that also operates a FHIR RESTful server may choose to decompose incoming messages and store the individual resources using RESTful create or update interactions. In this case, the same patterns described in the [RESTful Transfer](transfer.html) page apply — conditional create for Patient and Location resources, conditional update for Device and DeviceMetric resources, and create for Observation resources.

The `$process-message` operation provides a standard endpoint for receiving messages on a FHIR server. See the [FHIR specification]({{site.data.fhir.path}}messageheader-operation-process-message.html) for details.

### Relationship to HL7 V2 Messaging

Organizations migrating from HL7 V2-based device communication (e.g., IHE PCD-01 DEC using HL7 V2 ORU^R01 messages) may find FHIR messaging a natural stepping stone. The message-oriented architecture is familiar, while the content uses FHIR resources and profiles defined in this Implementation Guide. See [Mapping from HL7 V2 to FHIR](mappingv2.html) for guidance on mapping V2 device data to FHIR resources.
