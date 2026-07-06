Within the context of the ISO/IEEE 11073 Point-of-care medical device communication standards, the ISO/IEEE 11073-10207 Domain Information and Service Model defines the network representation of generic medical devices and consists of the device description and dynamic information about the current device state. 

### DIM Object Classes
Most object classes in ISO/IEEE 11073 SDC can be mapped to FHIR resources as outlined in the following table.

| DIM Object Class | FHIR Resource |
| --- | --- |
| MDS | [Device]({{site.data.fhir.path}}device.html) (according to the [MDS Device profile](StructureDefinition-MdsDevice.html)) and <br/>[Location]({{site.data.fhir.path}}location.html) or [Organization]({{site.data.fhir.path}}organization.html) (if needed) |
| VMD | [Device]({{site.data.fhir.path}}device.html) (according to the [VMD Device profile](StructureDefinition-VmdDevice.html)) |
| Channel | [Device]({{site.data.fhir.path}}device.html) (according to the [Channel Device profile](StructureDefinition-ChannelDevice.html)) |
| Numeric | [DeviceMetric]({{site.data.fhir.path}}devicemetric.html) (according to the [Numeric DeviceMetric profile](StructureDefinition-NumericDeviceMetric.html)) and <br/>[Observation]({{site.data.fhir.path}}observation.html) (according to the [Numeric Observation profile](StructureDefinition-NumericObservation.html) or [Compound Numeric Observation profile](StructureDefinition-CompoundNumericObservation.html)) |
| Enumeration | [DeviceMetric]({{site.data.fhir.path}}devicemetric.html) (according to the [Enumeration DeviceMetric profile](StructureDefinition-EnumerationDeviceMetric.html)) and <br/>[Observation]({{site.data.fhir.path}}observation.html) (according to the [Enumeration Observation profile](StructureDefinition-EnumerationObservation.html)) |
| ClinicalInfo | [Observation]({{site.data.fhir.path}}observation.html) (according to the [Observation profile](StructureDefinition-Observation.html)) |
| TimeSampleArray <br/> RealTimeSampleArray<br/> DistributionSampleArray | [DeviceMetric]({{site.data.fhir.path}}devicemetric.html) (according to the [Sample Array DeviceMetric profile](StructureDefinition-SampleArrayDeviceMetric.html)) and <br/>[Observation]({{site.data.fhir.path}}observation.html) (according to the [Sample Array Observation profile](StructureDefinition-SampleArrayObservation.html)) |
| Alert <br/> AlertStatus <br/> AlertMonitor | *to be completed* |
| PatientDemographics | [Patient]({{site.data.fhir.path}}patient.html) (according to the [Patient profile](StructureDefinition-Patient.html)) |
| OperatorDemographics | [Practitioner]({{site.data.fhir.path}}practitioner.html) (according to the [Practitioner profile](StructureDefinition-Practitioner.html)) |
{: .grid}

### SDC Object Attributes
Please refer to the Mappings tab of each profile page for mapping ISO/IEEE 11073 SDC object attributes to FHIR resource elements.

### Mapping Details

#### Device Identification and Unique Device Identification (UDI)

In ISO/IEEE 11073 SDC, the Medical Device System (MDS) provides detailed identification information through its descriptive state:
- **ProductionSpecification** containing manufacturer and model information
- **Identification** with Root (OID) and Extension providing globally unique device instance identification
- **SerialNumber** of the device
- **HardwareRevision** and **SoftwareRevision** providing version tracking

These components map to FHIR Device resource elements for Unique Device Identification (UDI):

| IEEE 11073 SDC Element | FHIR Device Mapping | Notes |
| --- | --- | --- |
| SystemContextDescriptor/ProductionSpecification/Manufacturer | `Device.manufacturer` | The device manufacturer name |
| SystemContextDescriptor/ProductionSpecification/Model | `Device.modelNumber` | The device model designation |
| Identification/Root (OID) | `Device.identifier.system` | The OID root identifies the namespace (e.g., manufacturer identifier) |
| Identification/Extension | `Device.identifier.value` | The extension uniquely identifies the specific device instance |
| SerialNumber | `Device.serialNumber` | The device's serial number, a critical component of UDI |
| HardwareRevision | `Device.version` with `type`=`hardware-version` | Hardware revision level for device tracking |
| SoftwareRevision | `Device.version` with `type`=`software-version` | Software/firmware revision level |
| UDI structured data (where available) | `Device.udiCarrier` | FHIR provides structured storage of UDI barcodes and parsed UDI data |
| UDI human-readable label | `Device.deviceName` with `type`=`udi-label-name` | The label name from the device's UDI label |
{: .grid}

**Implementation Guidance**:
- SDC devices should provide comprehensive device identification through the ProductionSpecification and Identification attributes. This information should be translated to corresponding FHIR Device elements to support UDI requirements.
- The combination of `Device.manufacturer`, `Device.modelNumber`, and `Device.serialNumber` forms the basis of device tracking and UDI compliance.
- The `Device.identifier` with OID-based `system` preserves the IEEE 11073 device identification namespace, supporting interoperability with other IEEE 11073-based systems while mapping to FHIR.
- When regulatory UDI information is available from the SDC source, it should be included in `Device.udiCarrier` for compliance tracking and supply chain management.

#### Patient
For each of the measurements Height and Weight, an Observation resource is required with mandatory data elements. `Observation.subject` shall be present and refer to a Patient resource or to an MDS Device resource.

Summary of the mandatory requirements for the Height:
- A coding in `Observation.category` for vital-signs with `system`='http://terminology.hl7.org/CodeSystem/observation-category' and `code`=`vital-signs`
- A coding in `Observation.code` for Body Height - Lying with `system`='http://loinc.org' and `code`=`8306-3`
- A coding in `Observation.code` for Body Height with `system`='http://loinc.org' and `code`=`8302-2` in compliance with the [FHIR Vital Signs Body Length profile]({{site.data.fhir.path}}observation-bodyheight.html)
- Other additional codings are allowed in `Observation.code`- e.g. more specific LOINC Codes, SNOMED CT concepts, system specific codes. All codes should have a system value.
- Either an `Observation.valueQuantity` or, if there is no value, a code in `Observation.dataAbsentReason`
    - The `Observation.valueQuantity` must have:
        - One numeric value in `Observation.valueQuantity.value`
        - a fixed `Observation.valueQuantity.system`="http://unitsofmeasure.org"
        - a UCUM unit code in `Observation.valueQuantity.code` = `cm`, or `[in_i]`

Summary of the mandatory requirements for the Weight:
- A coding in `Observation.category` for vital-signs with `system`='http://terminology.hl7.org/CodeSystem/observation-category' and `code`=`vital-signs`
- A coding in `Observation.code` for Body Weight with `system`='http://loinc.org' and `code`=`29463-7` in compliance with the [FHIR Vital Signs Body Weight profile]({{site.data.fhir.path}}observation-bodyweight.html)
- Other additional codings are allowed in `Observation.code`- e.g. more specific LOINC Codes, SNOMED CT concepts, system specific codes. All codes should have a system value.
- Either an `Observation.valueQuantity` or, if there is no value, a code in `Observation.dataAbsentReason`
    - The `Observation.valueQuantity` must have:
        - One numeric value in `Observation.valueQuantity.value`
        - a fixed `Observation.valueQuantity.system`="http://unitsofmeasure.org"
        - a UCUM unit code in `Observation.valueQuantity.code` = `kg`, `g`, or `[lb_av]`

#### Neonatal Patient
Information about the mother should be included in the FHIR resource RelatedPerson. `RelatedPerson.patient` should be used to reference the patient this RelatedPerson is related to. The relationship can be modeled by using `RelatedPerson.relationship` with the terminology binding `MTH`, to express that the RelatedPerson is the mother.

For each of the measurements GestationalAge, BirthLength, BirthWeight and HeadCircumference an Observation resource is required with mandatory requirements. `Observation.subject` shall be present and refer to a Patient resource or MDS Device resource.

Summary of the mandatory requirements for the HeadCircumference:
- A coding in `Observation.code` for Head Circumference with `system`='http://loinc.org' and `code`=`9843-4`
- Other additional codings are allowed in `Observation.code`- e.g. more specific LOINC Codes, SNOMED CT concepts, system specific codes. All codes should have a system value.
- Either an `Observation.valueQuantity` or, if there is no value, a code in `Observation.dataAbsentReason`
    - The `Observation.valueQuantity` must have:
        - One numeric value in `Observation.valueQuantity.value`
        - a fixed `Observation.valueQuantity.system`="http://unitsofmeasure.org"
        - a UCUM unit code in `Observation.valueQuantity.code` = `cm`, or `[in_i]`


Summary of the mandatory requirements for the BirthWeight:
- A coding in `Observation.category` for vital-signs with `system`='http://terminology.hl7.org/CodeSystem/observation-category' and `code`=`vital-signs`
- A coding in `Observation.code` for Body Weight with `system`='http://loinc.org' and `code`=`29463-7` in compliance with the [FHIR Vital Signs Body Weight profile]({{site.data.fhir.path}}observation-bodyweight.html)
- A coding in `Observation.code` for Birth Weight - Infant with `system`='http://loinc.org' and `code`=`8339-4` to indicate that the value applies to an infant
- Other additional codings are allowed in `Observation.code`- e.g. more specific LOINC Codes, SNOMED CT concepts, system specific codes. All codes should have a system value.
- Either an `Observation.valueQuantity` or, if there is no value, a code in `Observation.dataAbsentReason`
    - The `Observation.valueQuantity` must have:
        - One numeric value in `Observation.valueQuantity.value`
        - a fixed `Observation.valueQuantity.system`="http://unitsofmeasure.org"
        - a UCUM unit code in `Observation.valueQuantity.code` = `kg`, `g`, or `[lb_av]`

Summary of the mandatory requirements for the BirthLength:
- A coding in `Observation.category` for vital-signs with `system`='http://terminology.hl7.org/CodeSystem/observation-category' and `code`=`vital-signs`
- A coding in `Observation.code` for Body Height with `system`='http://loinc.org' and `code`=`8302-2`
- A coding in `Observation.code` for Birth Length - Infant with `system`='http://loinc.org' and `code`=`89269-5` to indicate that the value applies to an infant
- A coding in `Observation.code` for Body Height - Lying with `system`='http://loinc.org' and `code`=`8306-3` 
- Other additional codings are allowed in `Observation.code`- e.g. more specific LOINC Codes, SNOMED CT concepts, system specific codes. All codes should have a system value.
- Either an `Observation.valueQuantity` or, if there is no value, a code in `Observation.dataAbsentReason`
    - The `Observation.valueQuantity` must have:
        - One numeric value in `Observation.valueQuantity.value`
        - a fixed `Observation.valueQuantity.system`="http://unitsofmeasure.org"
        - a UCUM unit code in `Observation.valueQuantity.code` = `cm`, or `[in_i]`


Summary of the mandatory requirements for the GestationalAge:
- A coding in `Observation.code` for Gestational Age with `system`='http://loinc.org' and `code`=`72147-2`
- Other additional codings are allowed in `Observation.code`- e.g. more specific LOINC Codes, SNOMED CT concepts, system specific codes. All codes should have a system value.
- Either an `Observation.valueQuantity` or, if there is no value, a code in `Observation.dataAbsentReason`
    - The `Observation.valueQuantity` must have:
        - One numeric value in `Observation.valueQuantity.value`
        - a fixed `Observation.valueQuantity.system`="http://unitsofmeasure.org"
        - a UCUM unit code in `Observation.valueQuantity.code` = `d`

#### Location
For every physicalType of a Location an additional Location resource needs to be created. If this Location is physically a part of another Location they can only be connected via a `Location.partOf` reference to the other Location. It is working in the same way with the managing Organization. Both need to reference the lowest Location or Organization in the hierarchy because the references point upwards.

| IEEE 11073 SDC | HL7 FHIR Resources | Comment |
| --- | --- | --- |
| LocationContextState/Identification/Root | `Location.identifier.system` ||
| LocationContextState/Identification/Extension | `Location.identifier.value` ||
| LocationContextState/LocationDetail/Bed | `Location.physicalType` | An additional Location resource with the physicalType `bd` and references (`Location.partOf`  and/or `Location.managingOrganization`)  to another Location/Organization if the Bed is physically a part of a Location/Organization |
| LocationContextState/LocationDetail/Room | `Location.physicalType` | An additional Location resource with the physicalType `ro` and references (`Location.partOf`  and/or `Location.managingOrganization`)  to another Location/Organization if the Room is physically a part of a Location/Organization |
| LocationContextState/LocationDetail/PoC | `Organization.type` | An additional Organization resource with the Organization type `dept` and a reference (`Organization.partOf`)  to another Organization if the PoC is part of an Organization |
| LocationContextState/LocationDetail/Floor | `Location.physicalType` | An additional Location resource with the physicalType `lvl` and references (`Location.partOf`  and/or `Location.managingOrganization`)  to another Location/Organization if the Floor is physically a part of a Location/Organization |
| LocationContextState/LocationDetail/Building | `Location.physicalType` | An additional Location resource with the physicalType `bu` and references (`Location.partOf`  and/or `Location.managingOrganization`)  to another Location/Organization if the Building is physically a part of a Location/Organization |
| LocationContextState/LocationDetail/Facility | `Organization.type` | An Organization Resource with the Organization type `prov` and a reference (`Organization.partOf`)  to another Organization if the Facility is part of an Organization |
{: .grid}

#### ImagingStudy
The WorkflowContextState should only be used if the ContextAssociation is `Assoc` (=Associated).
The ImagingProcedure/RequestedProcedureId can be mapped to the id of the basedOn reference, which exists when the ImagingProcedure is based on a ServiceRequest. 

| IEEE 11073 SDC | HL7 FHIR resources |
| --- | --- |
| WorkflowContextState/WorkflowDetail/RequestedOrderDetail/ImagingProcedure/AccessionIdentifier/Root WorkflowContextState/WorkflowDetail/RequestedOrderDetail/ImagingProcedure/StudyInstanceUid/Root | `ImagingStudy.identifier.system` ||
| WorkflowContextState/WorkflowDetail/RequestedOrderDetail/ImagingProcedure/AccessionIdentifier/Extension WorkflowContextState/WorkflowDetail/RequestedOrderDetail/ImagingProcedure/StudyInstanceUid/Extension | `ImagingStudy.identifier.value` |
| WorkflowContextState/WorkflowDetail/RequestedOrderDetail/ImagingProcedure/Modality/Code | `ImagingStudy.modality.code` |
| WorkflowContextState/WorkflowDetail/RequestedOrderDetail/ImagingProcedure/Modality/CodingSystem | `ImagingStudy.modality.system` |
| WorkflowContextState/WorkflowDetail/RequestedOrderDetail/ImagingProcedure/Modality/CodingSystemVersion | `ImagingStudy.modality.version` |
| WorkflowContextState/WorkflowDetail/RequestedOrderDetail/ImagingProcedure/ProtocolCode/Code | `ImagingStudy.procedureCode.coding.code` |
| WorkflowContextState/WorkflowDetail/RequestedOrderDetail/ImagingProcedure/ProtocolCode/CodingSystem | `ImagingStudy.procedureCode.coding.system` |
| WorkflowContextState/WorkflowDetail/RequestedOrderDetail/ImagingProcedure/ProtocolCode/CodingSystemVersion | `ImagingStudy.procedureCode.coding.version` |
{: .grid}

#### ServiceRequest
The WorkflowContextState should only be used if the ContextAssociation is `Assoc` (=Associated).
The resource ServiceRequest may be used to share relevant information required to support a referral or a transfer of care request from one practitioner or organization to another. 
	
| IEEE 11073 SDC Status | HL7 FHIR | Comment |
| --- | --- | --- |
| WorkflowContextState/WorkflowDetail/AssignedLocation | `ServiceRequest.locationReference` ||
| WorkflowContextState/WorkflowDetail/RelevantClinicalInfo | `ServiceRequest.supportingInfo` ||
| WorkflowContextState/WorkflowDetail/RequestedOrderDetail/Performer | `ServiceRequest.performer` ||
| WorkflowContextState/WorkflowDetail/RequestedOrderDetail/ReferringPhysician WorkflowContextState/WorkflowDetail/RequestedOrderDetail/RequestingPhysician | `ServiceRequest.requester` | The resource ServiceRequest may be used to share relevant information required to support a referral or a transfer of care request from one practitioner or organization to another. Therefore, both the RequestingPhysician and the ReferringPhysician are mapped to the `ServiceRequest.requester`. If both exist, there should be a reference (`ServiceRequest.basedOn`)  from the RequestingPhysician to the ReferringPhysician. |
| WorkflowContextState/WorkflowDetail/PerformedOrderDetail/ResultingClinicalInfo | `DiagnosticReport.result` ||
{: .grid}

#### Valuesets

##### Valuesets for AbstractDeviceComponentState/ActivationState:

| IEEE 11073 SDC Status | HL7 FHIR `Device.statusReason` | Comment |
| --- | --- | --- |
| `On` | `online` ||
| `NotRdy` | `not-ready` ||
| `StndBy` | `standby` ||
| `Off` | `off` ||
| `Shtdn` | `not-ready` ||
| `Fail` | `not-ready` ||
{: .grid}

##### Valuesets for AbstractMetricState/ActivationState:

| IEEE 11073 SDC Status | HL7 FHIR `DeviceMetric.operationalStatus` | Comment |
| --- | --- | --- |
| `On` | `on` ||
| `NotRdy` | `off` ||
| `StndBy` | `standby` ||
| `Off` | `off` ||
| `Shtdn` | `off` ||
| `Fail` | `off` ||
{: .grid}

##### Valuesets for MetricCategory:

| IEEE 11073 SDC MetricCategory | HL7 FHIR `DeviceMetric.category` | Comment |
| --- | --- | --- |
| `Unspec` | `unspecified` ||
| `Msrmt` | `measurement` ||
| `Clc` | `calculation` ||
| `Set` | `setting` ||
| `Preset` | `unspecified` ||
| `Rcmm` | `unspecified` ||
{: .grid}

##### Valuesets for calibration state:

| IEEE 11073 SDC ComponentCalibrationState | HL7 FHIR `DeviceMetric.calibration.state` | Comment |
| --- | --- | --- |
| `No` | `not-calibrated` ||
| `Req` | `calibration-required` ||
| `Run` | `not-calibrated` ||
| `Cal` | `calibrated` ||
| `Oth` | `unspecified` ||
{: .grid}

##### Valuesets for calibration type:

| IEEE 11073 SDC ComponentCalibrationType | HL7 FHIR `DeviceMetric.calibration.type` | Comment |
| --- | --- | --- |
| `Offset` | `offset` ||
| `Gain` | `gain` ||
| `TP` | `two-point` ||
| `Unspec` | `unspecified` ||
{: .grid}

##### Measurement Validity
Observed values in ISO/IEEE 11073 SDC include a field that indicates measurement validity. FHIR Observations do not have a single element for this purpose. Instead there is security metadata, `dataAbsentReason` for missing values, and `interpretation` to report significance of a result.  
Measurement validity information is mapped to `Observation.meta.security`, `Observation.dataAbsentReason` or `Observation.component.dataAbsentReason`, and `Observation.interpretation` or `Observation.component.interpretation` elements. The `interpretation` value set binding is extended to add relevant codes from the [Measurement status codes](CodeSystem-measurement-status.html) defined in this implementation guide.

| MeasurementValidity | `meta.security`  | `dataAbsentReason` | `interpretation` |
| --- | --- | --- | --- |
| `Vld` | `RELIABLE` |||
| `Vldated`  | `HRELIABLE` | | `validated-data` |
| `Ong` | | `temp-unknown`|`msmt-ongoing`|
| `Qst` | `UNCERTREL` | | `questionable`|
| `Calib` | `UNCERTREL` | | `calibration-ongoing`|
| `Inv`  | `UNRELIABLE` | `error` | |
| `Oflw` | | | `>` |
| `Uflw` | | | `<` |
| `NA` | | `not-performed` | |
{: .grid}

Note that `dataAbsentReason` and `interpretation` are mutually exclusive: `dataAbsentReason` shall only be present if there is no observation value, whereas `interpretation` adds relevant information about an existing observation value.

#### CalibrationInfo at MDS and VMD Level

In ISO/IEEE 11073-10207 SDC, `CalibrationInfo` is part of `AbstractDeviceComponentState` and can therefore appear at the MDS, VMD, or Channel state level. For example, an anesthesia device may be required to perform a daily self-test, where `ComponentCalibrationState` transitions from `Req` (required) after system boot to `Cal` (calibrated) following a successful self-test. VMDs may also have specific calibration requirements.

Remark: In ISO/IEEE 11073-10201 DIM, calibration is supported at the metric level (`Metric::Metric-Calibration`) and not as a general MDS/VMD-level calibration structure.

For this implementation guide, when `CalibrationInfo` is carried at MDS or VMD level in SDC, calibration and self-test information should be represented on the corresponding `Device` resource using the calibration extension:

- Extension URL: `http://hl7.org/fhir/StructureDefinition/device-calibration`
- Remark: This extension is proposed to be part of the [FHIR Extensions Pack](https://build.fhir.org/ig/HL7/fhir-extensions/index.html).
- Extension elements:
    - `type` (same value set as `DeviceMetric.calibration.type`)
    - `state` (same value set as `DeviceMetric.calibration.state`)
    - `time` (instant)
    - `device` (0..*, `Reference(Device)`) for related devices involved in the calibration

Guidance:

- Add one `device-calibration` extension instance to the calibrated `Device` (MDS or VMD) for each reported calibration context.
- Map `ComponentCalibrationType` to `Device.extension[device-calibration].extension[type].valueCode` using the value set mapping above.
- Map `ComponentCalibrationState` to `Device.extension[device-calibration].extension[state].valueCode` using the value set mapping above.
- Map calibration timestamp information, when present, to `Device.extension[device-calibration].extension[time].valueInstant`.
- Use `Device.extension[device-calibration].extension[device].valueReference` to point to additional involved devices (for example, a calibrated VMD and its parent MDS, or an external calibrator device).
- Represent detailed calibration/self-test outcomes (for example pass/fail status, error codes, and user interaction steps) as `Observation` resources linked to the calibrated device context.

This approach supports common use cases such as anesthesia device daily self-tests while keeping calibration information on the device context where SDC reports it.

TBD: if calibration and self-test concepts have stable MDC nomenclature codes, we will add a dedicated calibration profile and an explicit end-to-end use case in this implementation guide.

Related tracking item: [FHIR-51356](https://jira.hl7.org/browse/FHIR-51356).