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
| ClinicalInfo | [Observation]({{site.data.fhir.path}}observation.html) (according to the [Observation profile](StructureDefinition-Observation.html)) |
| TimeSampleArray <br/> RealTimeSampleArray<br/> DistributionSampleArray | [DeviceMetric]({{site.data.fhir.path}}devicemetric.html) (according to the [Sample Array DeviceMetric profile](StructureDefinition-SampleArrayDeviceMetric.html)) and <br/>[Observation]({{site.data.fhir.path}}observation.html) (according to the [Sample Array Observation profile](StructureDefinition-SampleArrayObservation.html)) |
| Alert <br/> AlertStatus <br/> AlertMonitor | *to be completed* |
| PatientDemographics | [Patient]({{site.data.fhir.path}}patient.html) (according to the [Patient profile](StructureDefinition-Patient.html)) |
| OperatorDemographics | [Practitioner]({{site.data.fhir.path}}practitioner.html) (according to the [Practitioner profile](StructureDefinition-Practitioner.html)) |
{: .grid}

### SDC Object Attributes
Please refer to the Mappings tab of each profile page for mapping ISO/IEEE 11073 SDC object attributes to FHIR resource elements.

### Mapping Details

#### Patient
For each of the measurements Height and Weight is an Observation Resource required with mandatory requirements. Observation.subject shall be present and refer to a Patient resource or MDS Device resource.

Summary of the mandatory requirements for the Height:
- One code in Observation.code which must have
    - a fixed Observation.code.coding.system='http://loinc.org' 
    - a fixed Observation.code.coding.code= '8302-2'
    - 8306-3 -Body height - lying (i.e., body length - typically used for infants) MAY be included as an additional observation code - Other additional Codings are allowed in Observation.code- e.g. more specific LOINC Codes, SNOMED CT concepts, system specific codes. All codes SHALL have an system value
- Either one Observation.valueQuantity or, if there is no value, one code in Observation.DataAbsentReason
    - Each Observation.valueQuantity must have:
        - One numeric value in Observation.valueQuantity.value
        - a fixed Observation.valueQuantity.system="http://unitsofmeasure.org"
        - a UCUM unit code in Observation.valueQuantity.code = 'cm', or '[in_i]'

Summary of the mandatory requirements for the Weight:
- One code in Observation.code which must have
    - a fixed Observation.code.coding.system='http://loinc.org'
    - a fixed Observation.code.coding.code= '29463-7'
    - Other additional Codings are allowed in Observation.code- e.g. more specific LOINC Codes, SNOMED CT concepts, system specific codes. All codes SHALL have an system value
- Either one Observation.valueQuantity or, if there is no value, one code in Observation.DataAbsentReason
    - Each Observation.valueQuantity must have:
        - One numeric value in Observation.valueQuantity.value
        - a fixed Observation.valueQuantity.system="http://unitsofmeasure.org"
        - a UCUM unit code in Observation.valueQuantity.code = 'kg', 'g', or '[lb_av]'

#### Neonatal Patient
Information about the mother should be included in the FHIR Resource RelatedPerson. RelatedPerson.patient should be used for the reference of the patient this RelatedPerson is related to. The relationship can be modeled by using RelatedPerson.relationship with the terminology binding MTH, to express that the RelatedPerson is the mother.

For each of the measurements GestationalAge, BirthLength, BirthWeight and HeadCircumference is an Observation Resource requiered with mandatory requirements. Observation.subject shall be present and refer to a Patient resource or MDS Device resource.

Summary of the mandatory requirements for the HeadCircumference:
- One code in Observation.code which must have
    - a fixed Observation.code.coding.system='http ://loinc.org'
    - a fixed Observation.code.coding.code= '9843-4'
    - Other additional Codings are allowed in Observation.code- e.g. more specific LOINC Codes, SNOMED CT concepts, system specific codes. All codes SHALL have an system value
- Either one Observation.valueQuantity or, if there is no value, one code in Observation.DataAbsentReason
    - Each Observation.valueQuantity must have:
        - One numeric value in Observation.valueQuantity.value
        - a fixed Observation.valueQuantity.system="http://unitsofmeasure.org"
        - a UCUM unit code in Observation.valueQuantity.code = 'cm', or '[in_i]'


Summary of the mandatory requirements for the BirthWeight:
- One code in Observation.code which must have
    - a fixed Observation.code.coding.system='http ://loinc.org'
    - a fixed Observation.code.coding.code= '29463-7'
	- an additional Observation.code.coding.code= '8339-4' shall be provided, to indicate that the value applies to an infant
    - Other additional Codings are allowed in Observation.code- e.g. more specific LOINC Codes, SNOMED CT concepts, system specific codes. All codes SHALL have an system value
- Either one Observation.valueQuantity or, if there is no value, one code in Observation.DataAbsentReason
    - Each Observation.valueQuantity must have:
        - One numeric value in Observation.valueQuantity.value
        - a fixed Observation.valueQuantity.system="http://unitsofmeasure.org"
        - a UCUM unit code in Observation.valueQuantity.code = 'kg', 'g', or '[lb_av]'

Summary of the mandatory requirements for the BirthLength:
- One code in Observation.code which must have
    - a fixed Observation.code.coding.system='http ://loinc.org'
    - a fixed Observation.code.coding.code= '8302-2'
	- an additional Observation.code.coding.code= '89269-5' shall be provided, to indicate that the value applies to an infant
    - Other additional Codings are allowed in Observation.code- e.g. more specific LOINC Codes, SNOMED CT concepts, system specific codes. All codes SHALL have an system value
- Either one Observation.valueQuantity or, if there is no value, one code in Observation.DataAbsentReason
    - Each Observation.valueQuantity must have:
        - One numeric value in Observation.valueQuantity.value
        - a fixed Observation.valueQuantity.system="http://unitsofmeasure.org"
        - a UCUM unit code in Observation.valueQuantity.code = 'cm', or '[in_i]'


Summary of the mandatory requirements for the GestationalAge:
- One code in Observation.code which must have
    - a fixed Observation.code.coding.system='http ://loinc.org'
    - a fixed Observation.code.coding.code= '72147-2'
    - Other additional Codings are allowed in Observation.code- e.g. more specific LOINC Codes, SNOMED CT concepts, system specific codes. All codes SHALL have an system value
- Either one Observation.valueQuantity or, if there is no value, one code in Observation.DataAbsentReason
    - Each Observation.valueQuantity must have:
        - One numeric value in Observation.valueQuantity.value
        - a fixed Observation.valueQuantity.system="http://unitsofmeasure.org"
        - a UCUM unit code in Observation.valueQuantity.code = 'd'

#### Location
For every physicalType of a Location an additional Location Resource needs to be created. If this Location is physically a part of another Location they can only be connected via a Location.partOf Reference to the other Location. It is working in the same way with the managing Organization. Both need to reference the the lowest Location or Organization in the hierarchy because the references point upwards.

| IEEE 11073 SDC | HL7 FHIR Resources | Comment |
| ---
| LocationContextState/Identification/Root | Location.identifier.system ||
| LocationContextState/Identification/Extension | Location.identifier.value ||
| LocationContextState/LocationDetail/Bed | Location.physicalType | An additional Location Resource with the physicalType bd and references (Location.partOf and/or Location.managingOrganization) to another Location/Organization if the Bed is physically a part of a Location/Organization |
| LocationContextState/LocationDetail/Room | Location.physicalType | An additional Location Resource with the physicalType ro and references (Location.partOf and/or Location.managingOrganization) to another Location/Organization if the Room is physically a part of a Location/Organization |
| LocationContextState/LocationDetail/PoC | Organization.type | An additional Organization Resource with the Organization type dept and a reference (Organization.partOf) to another Organization if the PoC is part of an Organization |
| LocationContextState/LocationDetail/Floor | Location.physicalType | An additional Location Resource with the physicalType lvl and references (Location.partOf and/or Location.managingOrganization) to another Location/Organization if the Floor is physically a part of a Location/Organization |
| LocationContextState/LocationDetail/Building | Location.physicalType | An additional Location Resource with the physicalType bu and references (Location.partOf and/or Location.managingOrganization) to another Location/Organization if the Building is physically a part of a Location/Organization |
| LocationContextState/LocationDetail/Facility | Organization.type | An Organization Resource with the Organization type prov and a reference (Organization.partOf) to another Organization if the Facility is part of an Organization |
{: .grid}

#### ImagingStudy
The WorkflowContextState should only be used if the ContextAssociation is Assoc (=Associated).
The ImagingProcedure/RequestedProcedureId can be mapped to the id of the basedOn reference, which exists when the ImagingProcedure is based on a ServiceRequest. 

| IEEE 11073 SDC | HL7 FHIR Resources |
| ---
| WorkflowContextState/WorkflowDetail/RequestedOrderDetail/ImagingProcedure/AccessionIdentifier/Root WorkflowContextState/WorkflowDetail/RequestedOrderDetail/ImagingProcedure/StudyInstanceUid/Root | ImagingStudy.identifier.system ||
| WorkflowContextState/WorkflowDetail/RequestedOrderDetail/ImagingProcedure/AccessionIdentifier/Extension WorkflowContextState/WorkflowDetail/RequestedOrderDetail/ImagingProcedure/StudyInstanceUid/Extension | ImagingStudy.identifier.value |
| WorkflowContextState/WorkflowDetail/RequestedOrderDetail/ImagingProcedure/Modality/Code | ImagingStudy.modality.code |
| WorkflowContextState/WorkflowDetail/RequestedOrderDetail/ImagingProcedure/Modality/CodingSystem | ImagingStudy.modality.system |
| WorkflowContextState/WorkflowDetail/RequestedOrderDetail/ImagingProcedure/Modality/CodingSystemVersion | ImagingStudy.modality.version |
| WorkflowContextState/WorkflowDetail/RequestedOrderDetail/ImagingProcedure/ProtocolCode/Code | ImagingStudy.procedureCode.coding.code |
| WorkflowContextState/WorkflowDetail/RequestedOrderDetail/ImagingProcedure/ProtocolCode/CodingSystem | ImagingStudy.procedureCode.coding.system |
| WorkflowContextState/WorkflowDetail/RequestedOrderDetail/ImagingProcedure/ProtocolCode/CodingSystemVersion | ImagingStudy.procedureCode.coding.version |
{: .grid}

#### ServiceRequest
The WorklflowConextState should only be used if the ContextAssociation is Assoc (=Associated).
The resource ServiceRequest may be used to share relevant information required to support a referral or a transfer of care request from one practitioner or organization to another. 
	
| IEEE 11073 SDC Status | HL7 FHIR | Comment |
| ---
| WorkflowContextState/WorkflowDetail/AssignedLocation | ServiceRequest.locationReference ||
| WorkflowContextState/WorkflowDetail/RelevantClinicalInfo | ServiceRequest.supportingInfo ||
| WorkflowContextState/WorkflowDetail/RequestedOrderDetail/Performer | ServiceRequest.performer ||
| WorkflowContextState/WorkflowDetail/RequestedOrderDetail/ReferringPhysician WorkflowContextState/WorkflowDetail/RequestedOrderDetail/RequestingPhysician | ServiceRequest.requester | The resource ServiceRequest may be used to share relevant information required to support a referral or a transfer of care request from one practitioner or organization to another. Therefore, both the RequestingPhysician and the ReferringPhysician are mapped to the ServiceRequest.requester. If both are existing, there should be a reference (ServiceRequest.basedOn) from the RequestingPhysician to the ReferringPhysician. |
| WorkflowContextState/WorkflowDetail/PerformedOrderDetail/ResultingClinicalInfo | DiagnosticReport.result ||
{: .grid}

#### Valuesets

##### Valuesets for AbstractDeviceComponentState/ActivationState:

| IEEE 11073 SDC Status | HL7 FHIR Device.statusReason | Comment |
| ---
| On | online ||
| NotRdy | not-ready ||
| StndBy | standby ||
| Off | off ||
| Shtdn | not-ready ||
| Fail | not-ready ||
{: .grid}

##### Valuesets for AbstractMetricState/ActivationState:

| IEEE 11073 SDC Status | HL7 FHIR DeviceMetric.operationalStatus | Comment |
| ---
| On | on ||
| NotRdy | off ||
| StndBy | standby ||
| Off | off ||
| Shtdn | off ||
| Fail | off ||
{: .grid}

##### Valuesets for MetricCategory:

| IEEE 11073 SDC MetricCategory | HL7 FHIR DeviceMetric.category | Comment |
| ---
| Unspec | unspecified ||
| Mrsmt | measurement ||
| Clc | calculation ||
| Set | setting ||
| Preset | unspecified ||
| Rcmm | unspecified ||
{: .grid}

##### Valuesets for calibration state:

| IEEE 11073 SDC ComponentCalibrationState | HL7 FHIR DeviceMetric.calibration.state | Comment |
| --- 
| No | not-calibrated ||
| Req | calibration-required ||
| Run | not-calibrated ||
| Cal | calibrated ||
| Oth | unspecified ||
{: .grid}

##### Valuesets for calibration type:

| IEEE 11073 SDC ComponentCalibrationType | HL7 FHIR DeviceMetric.calibration.type | Comment |
| ---
| Offset | offset ||
| Gain | gain ||
| TP | two-point ||
| Unspec | unspecified ||
{: .grid}

##### Measurement Validity
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