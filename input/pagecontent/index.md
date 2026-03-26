### Purpose
This Implementation Guide defines the use of FHIR resources to convey measurements and supporting data 
from acute care point-of-care medical devices (PoCD) intended for use by qualified professional in receiving systems for electronic medical records, clinical decision support, and medical data archiving for aggregate quality measurement and research purposes. 
It adds "deep metadata for device observations".  
Key goals include supplementing the measurement values in an Observation resource with full provenance for traceability, and with 
more details of device architecture and dynamically changing attributes such as 
calibration history and battery state than is provided for in a FHIR Observation resource. This guide is intended to supplement — not replace — existing approaches such as HL7v2/IHE PCD-01 for communicating device data to device observation consumers.

The next release of this Guide intends to cover physiological and technical alerts from medical devices.
Another related implementation guide focuses on home-based personal health devices. 

### Scope and Boundaries
The scope of this Implementation Guide is a FHIR-based treatment of
quantitative and qualitative observations communicated from point-of-care medical devices. Devices without communications capabilities are out of scope. Imaging devices are also out of scope.
Personal devices intended for home health and fitness 
purposes to be used by non-professional users are excluded because they are covered by a
related Implementation Guide. 

This guide builds on the IEEE 11073-10201 Domain Information Model (DIM) and the ISO/IEEE 11073-10101 Nomenclature standard (MDC) for device data modeling and terminology. It focuses on the representation of device data in FHIR resources, rather than on connectivity, transport, or control aspects of device communication. The guide is intended to support the exchange of device data for clinical use, research, and quality measurement purposes, rather than real-time monitoring or device management. The table below summarizes the scope of this guide in relation to the IEEE 11073-10201 DIM:

<style>
table, th, td {
  border: 1px solid black;
  border-collapse: collapse;
  padding: 6px;
}
table tbody tr:nth-child(odd) {
  background-color: #f9f9f9;
}
table tbody tr:nth-child(even) {
  background-color: #ffffff;
}
</style>

| IEEE 11073‑10201 area         | PoCD IG scope   |
|-------------------------------|-----------------|
| DIM classes & attributes      | ✅ In scope     |
| Metric semantics              | ✅ In scope     |
| Alert meaning                 | ✅ In scope     |
| Service model (GET/SET/EVENT) | ❌ Out of scope |
| Scanners                      | ❌ Out of scope |
| Communication / FSM           | ❌ Out of scope |
| Remote control                | ❌ Out of scope |
| Transport timing guarantees   | ❌ Out of scope |

The “mental model” that usually clicks:

- IEEE 11073‑10201 answers: “What is the device, what does this metric mean, and how is it structured?”
- FHIR PoCD answers: “How do I represent that meaning as interoperable clinical data?”


### Intended Readers
This Implementation Guide is intended for 
- clinical users of point-of-care device data, 
- implementers of other health information systems wishing to use this extended data,
- device and device gateway system developers. 

All implementers are encouraged to review the [FHIR Implementer's Safety Check List](http://hl7.org/fhir/safety.html).

### Structure of this Guide

This guide is organized into four main areas: introductory and conceptual material for all readers, technical implementation guidance for system builders, formal conformance definitions (profiles and terminology), and supporting reference material.

#### Getting Started

**[Overview](overview.html)**
Introduces the IEEE 11073-10201 hierarchical device model (MDS → VMD → Channel → Metric), explains how it maps onto FHIR resources, and describes the value of the MDC nomenclature. Also covers common use cases — clinical flowsheet charting, archiving, clinical decision support, analytics, and research data feeds — and provides orientation for both data-consumer and data-provider implementers.

**[Abbreviations and Definitions](definitions.html)**
Reference glossary of terms, acronyms, and standard identifiers used throughout the guide.

Technical Implementation Guidance is given on following sub-pages:

- **[HL7 V2 Mapping](mappingv2.html)** — Maps the IHE PCD-01 / DEV-01 HL7 V2 message structure to equivalent FHIR resources, supporting migration from HL7 V2-based deployments.
- **[Mapping from IEEE 11073-10201 DIM to FHIR](mappingdim.html)** — Tables and narrative mapping each DIM object class (MDS, VMD, Channel, Metric types) to the corresponding FHIR profile.
- **[Mapping from IEEE 11073-10207 SDC to FHIR](mappingsdc.html)** — Equivalent mapping for the service-oriented SDC variant of the IEEE 11073 model.
- **[RESTful Transfer](transfer.html)** — Describes the FHIR RESTful API patterns for reporting and retrieving device data, including the server CapabilityStatement.
- **[FHIR Messaging](messaging.html)** — Describes the message-bundle alternative to RESTful transfer for event-driven or message-oriented architectures.

**[Profiles](profiles.html)**
Defines the FHIR profiles and extensions specified by this guide, organized by resource type: Device (MDS, VMD, Channel), DeviceMetric (Numeric, Enumeration, Sample Array), and Observation (Numeric, Compound Numeric, Enumeration, Sample Array). Includes guidance on subject attribution and Must Support semantics.

**[Terminology](terminology.html)**
Covers the ISO/IEEE 11073-10101 MDC nomenclature as the preferred code system, the locally defined code systems and value sets, rules for terminology usage, and instructions for downloading codes from the RTMMS.

**[Artifact List](artifacts.html)** — Full listing of all conformance resources (profiles, extensions, code systems, value sets, examples) defined in this guide.

**[Downloads](downloads.html)** — Package downloads for offline use.

**[Change Log](changes.html)** — History of significant changes between published versions.


### Relationship to Other Projects & Guides
This Implementation Guide covers material related to work in other projects and guides including the Personal Health Device Implementation Guide, and IHE profiles.

#### Personal Health Device IG
The [Personal Health Device Implementation guide](http://hl7.org/fhir/uv/phd/) focuses on wellness and chronic disease management devices used mainly by nonprofessionals in home and exercise settings. 

This Point-of-Care Device Implementation Guide is focused on acute-care devices for professional use mainly in healthcare delivery facilities. 

The Personal Health Device and Point-of-Care Device guides both use information models and nomenclature from the IEEE 11073 Medical Device Communications series of standards and the guides for these two kinds of devices are being developed cooperatively in the Devices On FHIR project with a goal of consistency and ease of use by receiving systems.

#### IHE Devices (DEV) / Patient Care Device (PCD) Domain
The [IHE Devices domain](https://www.ihe.net/ihe_domains/devices/) domain has developed profiles for conveying acute care device data with context using HL7 V2. The IHE Devices (DEV) domain is the successor to the IHE Patient Care Devices (PCD) domain.
The base information system and nomenclature are based on the IEEE 11073 Medical Device Communications standards, also used in this FHIR Implementation Guide. 

These profiles cover Device Enterprise Communications (DEC), reporting device observations to enterprise systems including near-real-time charting to electronic medical records, clinical decision support systems, and patient data archive systems. That is similar to the scope of this FHIR Implementation Guide.

A planned future FHIR use case for the Devices on FHIR group is the near-real-time communication of physiological and technical alerts to clinicians, and internal device status and state transition information for systems designed to process such information. This is similar to IHE DEV Alert Communication Management (ACM) and Infusion Pump Event Communication (IPEC) profiles.

Other DEV profiles include Implantable Device Cardiac Observations (IDCO), Point-of-Care Infusion Verification (PIV), and Point-of-Care Identity Management (PCIM). Future versions of this Implementation Guide will extend scope to cover related functionality based on FHIR rather than HL7 V2.

#### HL7 FHIR Profiles

##### Vital Signs Profile
The Observation resource is used to record data that is retrieved from a device. Some values that are 
formalized in this resource are required to conform to the 
[Vital Signs Profile](http://hl7.org/fhir/observation-vitalsigns.html),
for example, heart rate or respiratory rate. Many of these are often provided by a PoCD patient-connected device.  
It is possible that in rare cases using this Implementation Guide that a device or device gateway using only ISO/IEEE 11073 terminology codes may not have sufficient information to recognize a particular measurement as within the Vital Signs set and determine an equivalent LOINC code and UCUM unit code for the result.  Therefore, provisions must be made to correctly map these terms from 11073 to LOINC and UCUM, and to ensure that this is done at the earliest possible point.

This is an area of necessary coordination between this IG and the Vital Signs Profile.


### Connectivity and Throughput Considerations

This Implementation Guide addresses device data modeling and representation in FHIR resources, but implementers must also consider the connectivity behavior and network characteristics required for safe and effective PoCD deployments. The following considerations are important for understanding how to deploy and operate PoCD systems in practice.

#### Data Throughput Profiling

Point-of-care devices can generate data at widely varying rates. Some devices produce observations at discrete intervals (e.g., every few seconds or minutes), while others may produce continuous waveform data or high-frequency measurements requiring substantial bandwidth. Implementation planning must account for:
- Expected observation frequency and data volume from each device type
- Peak vs. average throughput requirements
- Storage and performance implications for receiving systems handling multiple devices simultaneously
- Network capacity planning for clinical settings with many connected devices

#### Connection Persistence and Reliability Models

Different clinical use cases require different connectivity patterns:
- **Persistent connections**: Continuous real-time streaming is appropriate for critical monitoring in ICU settings where immediate visibility of patient data is essential and network infrastructure is reliable
- **Episodic connections**: Scheduled or event-triggered data transmission may be suitable for periodic monitoring or in settings with less stable network connectivity
- **Hybrid models**: Some implementations may combine persistent connections for critical data with periodic synchronization for less time-sensitive observations

The choice of connectivity model should be guided by clinical requirements, network reliability, and system architecture.

#### Clinical Setting Differences

The requirements for PoCD connectivity vary significantly by clinical context:

- **Intensive Care Unit (ICU) and Operating Room (OR)**: These settings typically demand real-time or near-real-time visibility of device data with high reliability. Network infrastructure is usually robust, and clinical staff are trained to interpret continuous device streams. Systems in these settings should support persistent connections and handle high-frequency data transmission.

- **General Hospital Wards and Acute Care Settings**: Clinical needs for data vary by department and patient acuity. Some observations benefit from continuous monitoring while others can be recorded at intervals. System design should accommodate mixed connectivity models.

- **Home and Ambulatory Settings**: These settings often have less reliable network connectivity and different clinical workflows. Data may be collected and stored locally on the device or gateway, then transmitted when connectivity is available.

Understanding these differences is essential for designing systems that safely and effectively integrate PoCD data into diverse clinical environments.

#### Real-Time Monitoring vs. Data Persistence

Clinical decision-making depends on understanding both the immediate values of device measurements and their historical context. Implementation selection must consider:
- What data needs immediate visibility to clinicians (real-time requirements)
- What data should be persisted for longitudinal analysis, quality measurement, and research
- How to balance immediate transmission with network efficiency
- Clinical workflows and how they use device data at different time scales

#### Evolution of Implementation Experience

This Implementation Guide focuses on the data models and FHIR representation necessary for exchanging PoCD observations. As experience accumulates from prototype implementations and real-world deployments, further guidance on optimal connectivity patterns, throughput profiling, and operational practices for different clinical settings will be developed. The interaction between multiple implementations, including considerations of performance under different network conditions and clinical workflow integration, will inform future versions of this guide.

### Future Guide Revisions
Future capabilities are planned for this General PoCD IG including:
1. Waveform Support optimized for high data volumes
2. Device Events & Alerts including:
  * Basic IHE DEV ACM / IEC 60601-1-8 reporting
  * Status notifications back to the source Device

### References and External Resources

This Implementation Guide builds upon and references the following standards, guides, and external sources:

#### FHIR Implementation Guides

- [Personal Health Device (PHD) Implementation Guide](http://hl7.org/fhir/uv/phd/) - Focuses on wellness and chronic disease management devices used by nonprofessionals in home and exercise settings

#### IEEE 11073 Medical Device Communications Standards

- IEEE 11073-10101: Medical Device Communication - Nomenclature - Defines the standard nomenclature and information codification for medical device communications
- IEEE 11073-10201: Domain Information Model (DIM) - Defines the conceptual model for medical device data and nomenclature used across the IEEE 11073 suite
- IEEE 11073-10207: Service-Oriented Device Exchange Protocol (SDC) - Defines service-oriented architecture for medical device communication

These standards are available from the [IEEE Standards Association](https://standards.ieee.org/access-standards/).

#### IHE Devices (DEV) / Patient Care Device (PCD) Profiles
IHE still uses the named transactions (PCD-01, PCD-02, etc.) for profiles within the Devices domain, although the domain itself was renamed from Patient Care Devices (PCD) to Devices (DEV) around 2019–2020.

- IHE PCD-01 / DEV-01: Device Enterprise Communications (DEC) - Profile for reporting device observations to enterprise systems
- IHE PCD-03 / DEV-03: Alert Communication Management (ACM) - Profile for communicating physiological and technical alerts
- IHE PCD-04 / DEV-04: Infusion Pump Event Communication (IPEC) - Profile for infusion pump-related communications
- IHE PCD-05 / DEV-05: Implantable Device Cardiac Observations (IDCO) - Profile for implantable cardiac device observations
- IHE PCD-06 / DEV-06: Point-of-Care Infusion Verification (PIV) - Profile for infusion verification
- IHE PCD-07 / DEV-07: Point-of-Care Identity Management (PCIM) - Profile for device and patient identity management

These profiles are publicly available on the [IHE website](https://www.ihe.net/).

#### FHIR Safety

- [FHIR Implementer's Safety Check List](http://hl7.org/fhir/safety.html) - Important safety considerations that all FHIR implementers should review and address in their implementations

#### Other HL7 Standards
- [HL7 V2.x](https://www.hl7.org/implement/standards/product_brief.cfm?product_id=185) - Messaging standard for healthcare information exchange, referenced for compatibility and migration considerations

#### Other Nomenclature Standards
- [LOINC](https://loinc.org/) - Logical Observation Identifiers Names and Codes, used for terminology mapping of observations
- [SNOMED CT](https://www.snomed.org/) - Systematized Nomenclature of Medicine Clinical Terms, used for clinical terminology




