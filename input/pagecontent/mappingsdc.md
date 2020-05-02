Within the context of the ISO/IEEE 11073 Point-of-care medical device communication standards, the ISO/IEEE 11073-10207 Domain Information and Service Model defines the network representation of generic medical devices and consists of the device description and dynamic information about the current device state. 

### DIM Object Classes
Most object classes in ISO/IEEE 11073 SDC can be mapped to FHIR resources as outlined in the following table.

| DIM Object Class | FHIR Resource |
| ---
| MDS | [Device]({{site.data.fhir.path}}device.html) (according to the [MDS Device profile](StructureDefinition-MdsDevice.html)) and <br/>[Location]({{site.data.fhir.path}}location.html) or [Organization]({{site.data.fhir.path}}organization.html) (if needed) |
| VMD | [Device]({{site.data.fhir.path}}device.html) (according to the [VMD Device profile](StructureDefinition-VmdDevice.html)) |
| Channel | [Device]({{site.data.fhir.path}}device.html) (according to the [Channel Device profile](StructureDefinition-ChannelDevice.html)) |
| Numeric | [DeviceMetric]({{site.data.fhir.path}}devicemetric.html) (according to the [Numeric DeviceMetric profile](StructureDefinition-NumericDeviceMetric.html)) and <br/>[Observation]({{site.data.fhir.path}}observation.html) (according to the [Numeric Observation profile](StructureDefinition-NumericObservation.html) or [Compound Numeric Observation profile](StructureDefinition-CompoundNumericObservation.html)) |
| Enumeration | [DeviceMetric]({{site.data.fhir.path}}devicemetric.html) (according to the [Enumeration DeviceMetric profile](StructureDefinition-EnumerationDeviceMetric.html)) and <br/>[Observation]({{site.data.fhir.path}}observation.html) (according to the [Enumeration Observation profile](StructureDefinition-EnumerationObservation.html)) |
| TimeSampleArray <br/> RealTimeSampleArray<br/> DistributionSampleArray | *to be completed* |
| Alert <br/> AlertStatus <br/> AlertMonitor | *to be completed* |
| PatientDemographics | [Patient]({{site.data.fhir.path}}patient.html) |
{: .grid}

### SDC Object Attributes
Please refer to the Mappings tab of each profile page for mapping ISO/IEEE 11073 SDC object attributes to FHIR resource elements.

### Mapping Details
#### Measurement Validity
Observed values in ISO/IEEE 11073 SDC include a field that indicates measurement validity. FHIR Observations do not have a single element for this purpose. Instead there is security metadata, dataAbsentReason for missing values, and interpretation to report significance of a result.  
Measurement validity information is mapped to `Resource.meta.security`, `Observation.dataAbsentReason` or `Observation.component.dataAbsentReason`, and `Observation.interpretation` or `Observation.component.interpretation` elements. The interpretation value set binding is extended to add relevant codes from the [Measurement status codes](CodeSystem-measurement-status.html) defined in this implementation guide.

| MeasurementValidity | meta.security | dataAbsentReason | interpretation |
| ---
| Vld | REALIABLE |||
| Vldated  | HRELIABLE | | validated-data |
| Ong | | temp-unknown|msmt-ongoing|
| Qst | UNCERTREL | | questionable|
| Calib | UNCERTREL | | calibration-ongoing|
| Inv  | UNRELIABLE | error | |
| Oflw | | | > |
| Uflw | | | < |
| NA | | not-performed | |
{: .grid}

Note that dataAbsentReason and interpretation are mutually exclusive: dataAbsentReason shall only be present if there is no observation value, whereas interpretation adds relevant information about an existing observation value.