Within the context of the ISO/IEEE 11073 Point-of-care medical device communication standards, ISO/IEEE 11073-10201 provides an abstract, object-oriented domain information model (DIM) that defines a hierarchical model for structuring medical device data as well as events and services.

### DIM Object Classes
Most object classes in ISO/IEEE 11073 DIM can be mapped to FHIR resources as outlined in the following table.

| DIM Object Class | FHIR Resource |
| ---
| SimpleMDS <br/>HydraMDS <br/>CompositeSingleBedMDS <br/>CompositeMultipleBedMDS | [Device]({{site.data.fhir.path}}device.html) (according to the [MDS Device profile](StructureDefinition-MdsDevice.html)) and <br/>[Location]({{site.data.fhir.path}}location.html) (if needed) |
| VMD | [Device]({{site.data.fhir.path}}device.html) (according to the [VMD Device profile](StructureDefinition-VmdDevice.html)) |
| Channel | [Device]({{site.data.fhir.path}}device.html) (according to the [Channel Device profile](StructureDefinition-ChannelDevice.html)) |
| Numeric | [DeviceMetric]({{site.data.fhir.path}}devicemetric.html) (according to the [Numeric DeviceMetric profile](StructureDefinition-NumericDeviceMetric.html)) and <br/>[Observation]({{site.data.fhir.path}}observation.html) (according to the [Numeric Observation profile](StructureDefinition-NumericObservation.html) or [Compound Numeric Observation profile](StructureDefinition-CompoundNumericObservation.html)) |
| Enumeration | [DeviceMetric]({{site.data.fhir.path}}devicemetric.html) (according to the [Enumeration DeviceMetric profile](StructureDefinition-EnumerationDeviceMetric.html)) and <br/>[Observation]({{site.data.fhir.path}}observation.html) (according to the [Enumeration Observation profile](StructureDefinition-EnumerationObservation.html)) |
| TimeSampleArray <br/> RealTimeSampleArray<br/> DistributionSampleArray | *to be completed* |
| Alert <br/> AlertStatus <br/> AlertMonitor | *to be completed* |
| PatientDemographics | [Patient]({{site.data.fhir.path}}patient.html) |
{: .grid}

### DIM Object Attributes
Please refer to the Mappings tab of each profile page for mapping ISO/IEEE 11073 DIM object attributes to FHIR resource elements.

### Measurement Status
Observed values in ISO/IEEE 11073 DIM include a bit field that indicates measurement status. FHIR Observations do not have a single element for this purpose. Instead there is security metadata, dataAbsentReason for missing values, and interpretation to report significance of a result.  
Measurement status information is mapped to `Resource.meta.security`, `Observation.dataAbsentReason` or `Observation.component.dataAbsentReason`, and `Observation.interpretation` or `Observation.component.interpretation` elements. The interpretation value set binding is extended to add relevant codes from the [Measurement status codes](CodeSystem-measurement-status.html) defined in this implementation guide.

| MeasurementStatus Bit | meta.security | dataAbsentReason | interpretation |
| ---
| invalid (0) | | error | |
| questionable (1) | | | questionable |
| not-available (2) | | not-performed | |
| calibration-ongoing (3) | | | calibration-ongoing |
| test-data (4) | HTEST | | |
| demo-data (5) | HTEST | | |
| validated-data (8) | | | validated-data |
| early-indication (9) | | | early-indication |
| msmt-ongoing (10) | | | msmt-ongoing |
| msmt-state-in-alarm (14) | | | in-alarm |
| msmt-state-al-inhibited (15) | | | alarm-inhibited |
{: .grid}
