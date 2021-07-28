The following mapping information is based on the commonly-used PCD-01 transaction 
defined by the Integrating the Healthcare Enterprise Patient Care Device program
for reporting device data. 

This is a summary. Refer to the detailed information in:

- the HL7 Version 2.7 specification for general details including descriptions
especially Chapter 2.A for data types, which have some differences from FHIR data types

- The IHE Technical Framework, Volume 2, Transactions, Section 3.x, for specifics on which
HL7 V2 segments and fields are used in the profile, data types 

Explanations of columns in the summary tables:

| Column | Content |
| --- | --- |
| DT | Data Type. See [HL7 2.7 Specification Chapter 2A](http://www.hl7.eu/HL7v2x/v27/std27/ch02a.html#Heading2) |
| TBL# | HL7 V 2.7 Code Tables, corresponding approximately to FHIR ValueSets.

|Field ID|DT|Card.|TBL#|HL7 Field Name|FHIR Mapping|NOTES|
| --- | --- | --- | --- | --- | --- | --- |
|OBX-2|ID|[0..1]|125|Value Type||Identifies the kind of data in OBX-5 Observation Value. Ex. NM Numeric, NA Numeric Array|
|OBX-3|CWE|[1..1]||Observation Identifier|Observation.code|Identifers the observation according to a coding system.|
|OBX-4|ST|[1..1]||Observation Sub-ID||See Interpretation of OBX-4 Observation Sub-ID in IHE PCD-01|
|OBX-5|Varies|[0..1]||Observation Value|Observation.value[x]|Kind of FHIR value mapped to depends on HL7 V2 Value Type. Ex. For NM Numeric Value Type, will map to valueQuantity. Other common mappings NA Numeric Array -> SampledData, ST String Data -> ValueString|
|OBX-6|CWE|[0..1]||Units||Where Units are applicable to Observation Value, it will map within the FHIR Observation.value[x]. Ex. valueQuantity.unit|
|OBX-7|ST|[0..1]||References Range|Observation.referenceRange|Range of values inside of which the measurement is considered normal for the condition of the patient.|
|OBX-8|IS|[0..1]|78|Abnormal Flags|Observation.interpretation|See note below on OBX-8 Abnormal Flags in PCD-01`|
|OBX-11|ID|[1..1]|85|Observation Result Status||See table Observation result status|
|OBX-16|XCN|[0..1]||Responsible Observer|Observation.performer|Some devices support entry of observer information. If available, this information should be provided.|
|OBX-18|EI|[0..1]||Equipment Instance Identifier||A unique identifier of the particular piece of equipment used in the observation.|
|OBX-20|CWE|[0..*]|163|Observation Site|Observation.bodySite|Site on the body where the observation was made.|

## Detail notes for OBX segment mappings 

***OBX-3 Observation Identifier***. PCD-01 uses the IEEE 11073-10101 Nomenclature Standard. In FHIR, for observations 
in the Vital Signs category, the corresponding LOINC code must also be given. 
For other observations, for user convenience, LOINC codes should be given a where 
a mapping is available (see ConceptMap resource available on [loinc.org](https://loinc.org/collaboration/ieee/). 
Equivalent codes in other code systems such as SNOMED may also be given.

***OBX-4 Observation Sub-ID***
The IHE PCD-01 sub-id field is a key identifying the place of the Metric within the containment tree of Virtual Medical Devices (medical subsystems), channels (groupings of metrics 
within a VMD), and Metrics (individual measurement objects supported by the device. In
the profile, it is a 4-tuple of nonzero positive integers separated by dots (periods), 
where the first element identifies the Medical Device System (MDS), the second identifies 
the VMD, the third identifies the channel, and the fourth identifies the Metric.
Each of these integer elements maps to a hierachical level of the containment tree.
They can be used to look up attributes in "device-related" OBX segments relating to
each logical element (MDS, VMD, Channel, Metric). The "device-related" elements have
a special form for the Sub-ID with trailing zero elements identifying the logical level
of the device element they represent: three trailing zero elements identify an MDS, two 
a VMD, two a channel, and one a metric. See the IHE PCD Technical Framework for details.

***OBX-5 Observation Value***. Kind of FHIR value mapped to depends on HL7 V2 Value Type. 
Ex. For NM Numeric Value Type, will map to valueQuantity. 
Other common mappings NA Numeric Array -> SampledData, ST String Data -> ValueString.
See HL7 V2.7 Specification and FHIR Specification for other cases.

***OBX-7 Reference Range***. 
In IHE PCD-01, Reference Range gives the alarm range set by the user on the device, 
if available in the output of the device. 
Ex. 40-120 set for a patient for heart rate means that values outside of that range will result in an alarm condition signaled by the device.

***OBX-18 Equipment Instance Identifier***
n IHE PCD-01, the purpose of this field is to device source uniquely based on the EUI-64 of the Virtual Medical Device (VMD) if that has a unique identifier, or if not, the Medical Device System.

***OBX-20 Observation site***
This often does not need to be given, since in many cases the OBX-3 Observation Identifier clearly indicates the body site. Otherwise, in IHE PCD-01, body site values from MDC nomenclature may be used. Equivalent codes from other systems, e.g. SNOMED, should also be given in the CodeableConcept for user convenience.


|Value|ExtendedValue?|Description|Comment|
| --- | --- | --- | --- |
|NI|Yes|No information. There is no information which can be inferred from this exceptional value.|No value is provided in OBX-5.|
|NAV|Yes|Temporarily not available. Information is not available at this time but it is expected that it will be available later.|No value is provided in OBX-5.|
|OFF|Yes|Numeric measurement function is available but has been deactivated by user.|No value is provided in OBX-5.|
|>|N|Above absolute high-off instrument scale.|Provide the high-off instrument scale number in OBX-5 if available.|
|<|N|Below absolute low-off instrument scale.|Provide the low-off instrument scale number in OBX-5 if available.|

|Alert Priority|Abbreviation|
| --- | --- |
|no-alarm|PN|
|low priority|PL|
|medium priority|PM|
|high priority|PH|

|FIELD|DT|OPT|RP/#|ELEMENT NAME|FHIR_MAPPING|NOTES|
| --- | --- | --- | --- | --- | --- | --- |
|OBR-2|EI|O||Placer Order Number|
|OBR-3|EI|R||Filler Order Number|
|OBR-4|CWE|R||Universal Service Identifier|
|OBR-7|DTM|RE||Observation Date/Time|
|OBR-16|XCN|O|Y|Ordering Provider|

