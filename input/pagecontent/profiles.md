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

This Implementation Guide specifies profiles on the FHIR [Device]({{site.data.fhir.path}}device.html), [DeviceMetric]({{site.data.fhir.path}}devicemetric.html), and [Observation]({{site.data.fhir.path}}observation.html) resources. Each profile defines constraints, extensions, and terminology requirements for an implementation that claims conformance to this guide.

A point-of-care device model is made of multiple resource instances and the relationships between them. The following diagram shows the FHIR resource profiles (blue) and references to other profiles or FHIR core resources (white).

<figure>
<img src="PoCD_Profiles.png" alt="PoCD Profiles" style="width:90%" class="center">
<figcaption><i>PoCD Profiles diagram showing FHIR resource profiles and references</i></figcaption>
</figure>

### Observation Subject Guidance

The Observation profiles in this Implementation Guide require the `subject` element to be present and shall reference a Patient resource or MDS Device resource.

**Patient References**: A Patient resource is referenced when the observation is about a patient, such as a physiological measurement or vital sign. This is the typical use case for clinical observations.

**Device References**: An MDS Device resource is referenced when the observation is about the device itself, such as a device setting or a technical device measurement (e.g., ventilator air pressure or infusion rate). For therapeutic devices, device settings are often patient-related but are documented as observations about the device resource. When an observation's subject points to a Device resource, the associated patient can be found using the Device.patient reference.

**Version-Specific References for Device Observations**: When an observation's subject points to a Device resource with dynamic content that is relevant to the observation (such as configuration parameters or settings that changed over time), a version-specific reference should be used. This ensures that for retrospective analysis, the exact state of the device's patient reference at the time the observation was made is available, rather than potentially resolving to a different patient reference at a later time.

**Mandatory Subject and Handling Unknown Patient Demographics**: The `subject` element is mandatory in all Observation profiles in this Implementation Guide to ensure compatibility with the FHIR Vital Signs Profile. In situations where patient demographics are unknown to the device—such as due to privacy concerns or because measurements are taken before the patient is admitted—implementers may create a temporary Patient resource that contains only a unique identifier. This temporary resource can be referenced by observations and can be updated, linked to, or merged with the final Patient resource when complete demographic information becomes available. This approach maintains data integrity and allows observations to be properly contextualized while accommodating real-world device deployment scenarios.

### Patient and Location Resource Handling

Point-of-care devices generate observations that reference Patient and Location resources, but the device or gateway typically is not the authoritative source for these resources. This section provides guidance on how to handle Patient and Location references in different deployment scenarios.

#### Reference Patterns

There are three patterns for including Patient and Location references in device data, and the choice depends on the deployment context:

1. **Reference existing resources**: When the destination FHIR server is the system of record for Patient and Location resources (the most common scenario in enterprise deployments), the device or gateway resolves references by searching with known identifiers before submitting observations. This requires the device or gateway to have access to patient and location identifiers, typically received through an ADT feed or device association workflow.

2. **Conditional create in the bundle**: When the device or gateway has sufficient identity information but does not know whether the resource already exists on the server, it can include a Patient or Location resource in the transaction bundle with a conditional create request (`ifNoneExist`). The server will use the existing resource if found, or create a new one. This approach requires strong identifiers (such as MRN for Patient or a unique name for Location) to avoid creating duplicates. See the [RESTful Transfer](transfer.html#conditional-create) page for examples.

3. **Include in the bundle**: When the device is the source of truth for the resource (rare for Patient, but possible for Location in mobile or temporary setups), the resource is included directly in the transaction bundle. This pattern should be used with caution, as it may conflict with resources managed by other systems.

#### Minimum Identity Requirements

For **Patient** references, the device or gateway should supply at least a medical record number (MRN) or other facility-specific identifier received from an ADT system or device association workflow. When patient demographics are unknown, see the guidance under [Observation Subject Guidance](#observation-subject-guidance) above for handling temporary Patient resources.

For **Location** references, the device or gateway should supply at least a bed label or location identifier that can be matched against existing Location resources on the server. The MDS Device profile supports a `Device.location` reference for establishing the device's physical location.

#### Conformance to Destination Profiles

This Implementation Guide does not profile the Patient or Location resources for clinical use (Patient and Practitioner profiles exist for mapping purposes only). Implementers should conform to Patient and Location profiles required by their deployment context, such as [US Core](http://hl7.org/fhir/us/core/) or [International Patient Access (IPA)](http://hl7.org/fhir/uv/ipa/). When the device or gateway creates Patient or Location resources via conditional create, it should populate elements required by the destination server's profiles to the extent possible.

#### Future Work

Deployment archetypes and workflow integration patterns — including the relationship between device observations and clinical orders — are expected to be addressed in future versions of this guide as implementation experience accumulates.

### DeviceMetric Source and Observation Device Attributes

To support traceability and contextualization of observations within the device hierarchy, the PoCD profiles use two key reference elements:

**DeviceMetric.source**: The `source` element in a DeviceMetric profile shall reference the MDS (Medical Device System) Device resource. This establishes the connection from the metric (the lowest level of the hierarchy) back to the root device system, enabling complete traceability of the measurement to its source device. This is essential for identifying which physical device produced the measurement, particularly in environments with multiple connected devices.

**Observation.device**: The `device` element in an Observation profile shall reference the DeviceMetric resource that provided the measurement. This direct connection allows consumers of observation data to access the full device context and hierarchy by following the reference chain: Observation → DeviceMetric → MDS Device (and from there to VMDs and Channels as needed). This approach supports the IEEE 11073 hierarchical model and ensures observations can be properly contextualized with all relevant device metadata.

These references together ensure that clinical systems and archives can reconstruct the complete device configuration and hierarchy for any observation, supporting safe clinical use and comprehensive retrospective analysis.

### Must Support

For the profiles listed below, when `mustSupport` is set to true on data elements (flagged with a <span style="padding-left: 3px; padding-right: 3px; color: white; background-color: red" title="This element must be supported">S</span> in table view) this shall be interpreted as follows:

- Data sources shall be capable of populating the element in a resource instance if the data is available and permissions allow.
- Data consumers shall be capable of consuming the element from the resource instance if the data is relevant to their business case.

### Device Profiles and Extensions

| Profile/Extension | Description |
|---|---|
| [MDS Device profile](StructureDefinition-MdsDevice.html) | StructureDefinition for Device resources that represent a Medical Device System (MDS). This is the top-level resource in the hierarchical model of a Point-of-Care device. |
| [VMD Device profile](StructureDefinition-VmdDevice.html) | StructureDefinition for Device resources that represent Virtual Medical Devices (VMD). These are medical-related subsystems in the hierarchical model of a Point-of-Care device. |
| [Channel Device profile](StructureDefinition-ChannelDevice.html) | StructureDefinition for Device resources that represent Channels, which are used for grouping metrics together. |
| [Device Instance extension](StructureDefinition-device-instance.html) | StructureDefinition that adds an instance number or label to Device or DeviceMetric. |
| [Approved Jurisdictions extension](StructureDefinition-approved-jurisdictions.html) | StructureDefinition that adds approved jurisdictions to a Device. |
| [Operator extension](StructureDefinition-operator.html) | StructureDefinition that adds an operator to a Device. |
| [Operating hours extension](StructureDefinition-operating-hours.html) | StructureDefinition that adds operating hours to a Device. |
| [Operating cycles extension](StructureDefinition-operating-cycles.html) | StructureDefinition that adds operating cycles to a Device. |
| [Operating mode extension](StructureDefinition-operating-mode.html) | StructureDefinition that adds an operating mode to a Device. |

### DeviceMetric Profiles and Extensions

| Profile/Extension | Description |
|---|---|
| [Numeric DeviceMetric profile](StructureDefinition-NumericDeviceMetric.html) | StructureDefinition for DeviceMetric resources that represent numerical measurements, calculations, or settings. |
| [Enumeration DeviceMetric profile](StructureDefinition-EnumerationDeviceMetric.html) | StructureDefinition for DeviceMetric resources that represent coded or text status, annotations, or settings. |
| [Sample Array DeviceMetric profile](StructureDefinition-SampleArrayDeviceMetric.html) | StructureDefinition for DeviceMetric resources that represent real-time waveforms or wave snippets. |
| [Device Instance extension](StructureDefinition-device-instance.html) | StructureDefinition that adds an instance number or label to Device or DeviceMetric. |
| [Relation extension](StructureDefinition-relation.html) | StructureDefinition that adds relations to a DeviceMetric. |
| [Metric availability extension](StructureDefinition-metric-availability.html) | StructureDefinition that adds metric availability to a DeviceMetric. |
| [Technical range extension](StructureDefinition-technical-range.html) | StructureDefinition that adds technical range and accuracy to a DeviceMetric. |
| [Resolution extension](StructureDefinition-resolution.html) | StructureDefinition that adds resolution to a DeviceMetric. |
| [Sweep Speed extension](StructureDefinition-sweep-speed.html) | StructureDefinition that adds default sweep speed to a DeviceMetric. |
| [Visual Grid extension](StructureDefinition-visual-grid.html) | StructureDefinition that adds grid line definitions to a DeviceMetric. |

### Observation Profiles and Extensions

| Profile/Extension | Description |
|---|---|
| [Numeric Observation profile](StructureDefinition-NumericObservation.html) | StructureDefinition for Observation resources that represent numerical measurements, calculations, or settings. |
| [Compound Numeric Observation profile](StructureDefinition-CompoundNumericObservation.html) | StructureDefinition for Observation resources that represent numerical measurements, calculations, or settings with multiple components. |
| [Enumeration Observation profile](StructureDefinition-EnumerationObservation.html) | StructureDefinition for Observation resources that represent coded or text status, annotations, or settings. |
| [Sample Array Observation profile](StructureDefinition-SampleArrayObservation.html) | StructureDefinition for Observation resources that represent real-time waveforms or wave snippets. |

### Profiles only used for mappings
The profiles listed here are not intended to be used in actual implementations, but are used for mapping purposes for ISO/IEEE 11073-10207 (i.e. IEEE SDC) in this implementation guide.


| Profile | Description |
|---|---|
| [Observation profile](StructureDefinition-Observation.html) | StructureDefinition for measurements and simple assertions made about a patient, device or other subject. |
| [Patient profile](StructureDefinition-Patient.html) | StructureDefinition for Patient resources that represent demographics and other administrative information. |
| [Practitioner profile](StructureDefinition-Practitioner.html) | StructureDefinition for Practitioner resources that represent demographics and other administrative information. |


