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

### Must Support

For the profiles listed below, `mustSupport` set to true on data elements (flagged with a <span style="padding-left: 3px; padding-right: 3px; color: white; background-color: red" title="This element must be supported">S</span> in table view) shall be interpreted as follows:

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
| [Numeric DeviceMetric profile](StructureDefinition-NumericDeviceMetric.html) | StructureDefinition for DeviceMetric resources that represent numerical measurements, calculations, or settings characteristics and capabilities. |
| [Enumeration DeviceMetric profile](StructureDefinition-EnumerationDeviceMetric.html) | StructureDefinition for DeviceMetric resources that represent coded or text status, annotations, or settings characteristics and capabilities. |
| [Sample Array DeviceMetric profile](StructureDefinition-SampleArrayDeviceMetric.html) | StructureDefinition for DeviceMetric resources that represent real-time waveforms or wave snippets characteristics and capabilities. |
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


