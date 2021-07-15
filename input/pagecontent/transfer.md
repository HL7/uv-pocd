Most FHIR implementations follow the [RESTful]({{site.data.fhir.path}}http.html) approach for transferring resources between client and server. The FHIR server provides the RESTful API for managing resources. A medical device or gateway acts as FHIR client, which reports device data using create and update interactions. Other clients (e.g., clinical applications) use read or search interactions to access stored data. There is also a subscription mechanism to get notifications when data becomes available.

Requirements for a FHIR server supporting this implementation guide are listed in the (*to be completed*) CapabilityStatement.

This section explains the transfer of device-sourced resources as listed on the [Profiles](profiles.html) page to a FHIR server using transaction bundles.

### Bundles
A point-of-care medical device model consists of multiple resource instances, which have to be reported at least once during initialization. Even during runtime, a device may report multiple observations together. While it is possible using individual create and update interactions for each resource, this implementation guide recommends [Bundle]({{site.data.fhir.path}}bundle.html) resources for transferring a set of resources in a single transaction. For example, an entire device containment tree or subtree is packed into a bundle of Device and DeviceMetric resources. Another bundle contains all Observation resources for an update cycle.

### Transactions
A client submits a [transaction]({{site.data.fhir.path}}http.html#transaction) bundle containing multiple request entries to create, update, or delete resources. The content is treated as single entity, which is either accepted or rejected.

Each entry has a `Bundle.entry.request` element with HTTP method (e.g., POST or PUT) and relative URL, and a `Bundle.entry.resource` element for the resource content to be created or updated. When a resource is initially transferred, the client does not know the [logical id]({{site.data.fhir.path}}resource.html#id) that will be assigned by the server. To allow references between resources in the bundle, the client may assign a [temporary identifier]({{site.data.fhir.path}}bundle.html#bundle-unique) in the `Bundle.entry.fullUrl` element.

*Example: Transaction bundle creating Device and DeviceMetric resources, where DeviceMetric refers to Device*

```
{
  "resourceType": "Bundle",
  "type": "transaction",
  "entry": [ {
    "fullUrl": "urn:uuid:2fa92047-0cfa-47e5-b9f9-b3d93dd02366",
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
      },
      // ...
    },
    "request": {
      "method": "POST",
      "url": "Device"
    }
  },
  // ...
  {
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
        "reference": "urn:uuid:2fa92047-0cfa-47e5-b9f9-b3d93dd02366"
      },
      // ...
    },
    "request": {
      "method": "POST",
      "url": "DeviceMetric"
    }
  } ]
}
```

If successful, the server returns a transaction-response bundle, which reports the result of each request. The bundle response entry returns also the server-assigned logical id and version for each resource. For subsequent transactions, the client can use [literal references]({{site.data.fhir.path}}references.html#literal) instead of temporary identifiers.

*Example: Transaction response bundle returning logical identifiers*

```
{
  "resourceType": "Bundle",
  "type": "transaction-response",
  // ...
  "entry": [ {
    "response": {
      "status": "201 Created",
      "location": "Device/1234/_history/1",
      // ...
    }
  },
  // ...
  {
    "response": {
      "status": "201 Created",
      "location": "DeviceMetric/2345/_history/1",
      // ...
    }
  } ]
}
```

### Create
All Device and DeviceMetric resources that make the device model must exist on the server. When communication starts, the client may not know what's already on the server. To avoid duplicates, it can search for existing resources and create missing ones or start with conditional updates (see [below](#conditional-update)).

For reporting a new measurement or changed setting, an Observation resource is created where at least the effective time (time stamp or period) differs from previously reported observations.

**Create** is an individual HTTP POST request or a transaction bundle entry as shown in the example.

*Example: Create an Observation resource*

```
{
  // ...
  "entry": [ {
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
        "reference": "Patient/0123"
      },
      "effectiveDateTime": "2020-03-04T15:16:17+00:00",
      "valueQuantity": {
        "value": 5.5,
        "unit": "mmHg",
        "system": "http://unitsofmeasure.org",
        "code": "mm[Hg]"
      },
      "device": {
        "reference": "DeviceMetric/2345/_history/1"
      }
    },
    "request": {
      "method": "POST",
      "url": "Observation"
    }
  },
  // ...
  ]
}
```

### Conditional Create
Resources generated by a medical device need references to resources that are most likely already present on the server, such as Patient or Location. The device or gateway may have only limited knowledge about it. Conditional create adds unique information as search criteria to the request. If a resource is found it remains unchanged, otherwise a new instance is created.

Note that this approach will fail if there are multiple resource instances that fulfil the search criteria.

**Conditional Create** is an HTTP POST request with If-None-Exist extension header.

*Example: Create Location resource only if location with given name does not exist*

```
{
  // ...
  "entry": [ {
    "fullUrl": "urn:uuid:0c52bec2-49bb-46ce-a2f7-a3cc16fc17a4",
    "resource": {
      "resourceType": "Location",
      "name": "Bed 42",
      "mode": "instance"
    },
    "request": {
      "method": "POST",
      "url": "Location",
      "ifNoneExist": "name:exact=Bed%2042"
    }
  },
  // ...
  ]
}
```

### Update
The client needs to update a resource on the server when content changes, but the object that the resource represents is still the same. For example, the operational status of a Device or calibration data of a DeviceMetric may change over time. An update adds a new version of the resource instance. Resource references can point to a specific version if needed.

In some cases an Observation resource may be updated too. Examples:
* `Observation.status` changes from 'preliminary' to 'final' after manual validation
* `Observation.effectivePeriod` has been created with start time only, and end time gets known

**Update** is an HTTP PUT request. URL includes the logical id.

*Example: Update DeviceMetric resource when calibration is completed*

```
{
  // ...
  "entry": [ {
    "fullUrl": "http://example.org/fhir/DeviceMetric/2345",
    "resource": {
      "resourceType": "DeviceMetric",
      "id": "2345",
      "type": {
        "coding": [ {
          "system": "urn:iso:std:iso:11073:10101",
          "code": "150084",
          "display": "MDC_PRESS_BLD_VEN_CENT"
        } ],
        "text": "CVP"
      },
      "source": {
        "reference": "Device/1234"
      },
      // ...
      "calibration": [ {
        "type": "offset",
        "state": "calibrated",
        "time": "2020-03-04T16:17:18+00:00"
      } ]
    },
    "request": {
      "method": "PUT",
      "url": "DeviceMetric/2345"
    }
  },
  // ...
  ]
}
```

### Conditional Update
When submitting a Device or DeviceMetric resource for the first time, the client may not know if it is already available on the server or needs an update. Conditional update adds unique information as search criteria to the request URL. If a resource is found and its content differs, it's updated. If no resource is found a new instance is created.

Note that this approach will fail if there are multiple resource instances that fulfil the search criteria.

**Conditional Update** is an HTTP PUT request with search criteria instead of the logical id.

*Example: Update Device resource with given EUI-64 identifier, or create it if it doesn't exist*

```
{
  // ...
  "entry": [ {
    "fullUrl": "urn:uuid:915a7b26-f8df-4ec5-8fa9-4e623b1a12cc",
    "resource": {
      "resourceType": "Device",
      "identifier": [ {
        "system": "urn:oid:1.2.840.10004.1.1.1.0.0.1.0.0.1.2680",
        "value": "01-23-45-67-89-AB-CD-EF"
      } ],
      "status": "inactive",
      "statusReason": [ {
        "coding": [ {
          "system": "http://terminology.hl7.org/CodeSystem/device-status-reason",
          "code": "standby",
          "display": "Standby"
        } ]
      } ],
      "type": {
        "coding": [ {
          "system": "urn:iso:std:iso:11073:10101",
          "code": "69965",
          "display": "MDC_DEV_MON_PHYSIO_MULTI_PARAM_MDS"
        } ],
        "text": "Patient Monitor"
      },
      // ...
    },
    "request": {
      "method": "PUT",
      "url": "Device?identifier=urn:oid:1.2.840.10004.1.1.1.0.0.1.0.0.1.2680|01-23-45-67-89-AB-CD-EF"
    }
  },
  // ...
  ]
}
```

### Delete
A resource should only be deleted if the object that it represents does no longer exist. In most cases, changing the operational status (`Device.status` or `DeviceMetric.operationalStatus`) is more appropriate.
