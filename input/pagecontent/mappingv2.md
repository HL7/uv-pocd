The following mapping information is based on the commonly-used PCD-01 transaction 
defined by the Integrating the Healthcare Enterprise Patient Care Device program
for reporting device data. 

It is not feasible to include all relevant details in this brief account.  
Refer to the detailed information in:

- the [HL7 Version 2.7 specification](http://www.hl7.eu/HL7v2x/v27/std27/hl7.html) for 
general details including descriptions
especially [Chapter 2.A](http://www.hl7.eu/HL7v2x/v27/std27/ch02a.html) for data types, 
which have some differences from FHIR data types

- The [IHE Patient Care Devices Technical Framework](https://www.ihe.net/resources/technical_frameworks/#dev), 
Volume 2, Transactions ([download PDF](https://www.ihe.net/uploadedFiles/Documents/PCD/IHE_PCD_TF_Vol2.pdf`), 
Section 3.x, for specifics on which
HL7 V2 segments and fields are used in the profile, their data types, and usage notes.
This document is the source of the information in the tables of this Guide.

The common use case for device data reporting is for a device or a device gateway to be responsible mainly for
the observations and ancillary data on the configuration and functioning of the devices themselves.
Primary responsibility for patient identity and location information is with other hospital information
systems. In many cases such data is available only by linking to resources provided by these other systems.
Some device systems and gateways will have limited information about patient identity and location.

The implementer of a system creating and organizing links among the FHIR resources
must use their understanding of the capabilities of the devices being interfaced,
the context or contexts for their implementation,
including the sources for authorative patient identity, location, and reliable information 
on the associations between particular patients and particular device instances
to making an adequate, patient-safe, set of FHIR resources within that context.

**Explanations of columns in the summary tables**

| Column | Content |
| --- | --- |
| DT | Data Type. See [HL7 2.7 Specification Chapter 2A](http://www.hl7.eu/HL7v2x/v27/std27/ch02a.html#Heading2) |
| TBL# | HL7 V 2.7 Code Tables, corresponding roughly to FHIR ValueSets. See [HL7 2.7 Specification Chapter 2C](http://www.hl7.eu/HL7v2x/v27/std27/ch02c.html#Heading2)
{: .grid}

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
{: .grid}

### Detail notes for OBX segment mappings 

#### OBX-3 Observation Identifier. PCD-01 uses the IEEE 11073-10101 Nomenclature Standard. In FHIR, for observations 
in the Vital Signs category, the corresponding LOINC code must also be given. 
Equivalent codes in other code systems such as SNOMED may also be given.

#### OBX-4 Observation Sub-ID
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

#### OBX-5 Observation Value 
Kind of FHIR value mapped to depends on HL7 V2 Value Type. 
Ex. For NM Numeric Value Type, will map to valueQuantity. 
Other common mappings NA Numeric Array -> SampledData, ST String Data -> ValueString.
See HL7 V2.7 Specification and FHIR Specification for other cases.

#### OBX-7 Reference Range. 
In IHE PCD-01, Reference Range gives the alarm range set by the user on the device, 
if available in the output of the device. 
Ex. 40-120 set for a patient for heart rate means that values outside of that range will result in an alarm condition signaled by the device.

#### OBX-8 Abnormal Flags

This field provides for adding information about a particular abnormal result. This is a repeatable field,
so that multiple flags from the following tables may be included, separated by the HL7 repeat separator,
which is normally the character '~'.

##### OBX-8 Abnormality types

|Abnormality Type|Abbreviation|
| --- | --- |
|Normal, not abnormal|N|
|Below low normal|L|
|Below lower panic limits|LL|
|Above high normal|H|
|Above higher panic limits|HH|
|Abnormal (for non-numeric results)|A|
{: .grid}

##### OBX-8 Measurement status

|MeasurementStatus ::= BITS-16 { ... }|OBX-8  |OBX-11|Column1|
| --- | --- | --- | --- |
|No bits set ? raw device measurement; measurement okay, has not been reviewed nor validated||R|
|invalid(0),|INV|X|
|questionable(1),|QUES|R|
|not-available(2),|NAV|X|
|calibration-ongoing(3),|CAL|R|
|test-data(4),|TEST|R|
|demo-data(5),|DEMO|R|
|validated-data(8),|#NAME?||F|
|early-indication(9), -- early estimate of value|EARLY|R|
|msmt-ongoing(10), -- indicates that a new measurement is just being taken -- (episodic)|BUSY|X|
|msmt-state-in-alarm(14), -- indicates that the metric has an active alarm condition|ALACT|R|
|msmt-state-al-inhibited(15) -- metric supports alarming and alarms are turned off -- (optional)|ALINH|R|
{: .grid}

##### OBX-8 Missing or invalid data flags

|Value|ExtendedValue?|Description|Comment|
| --- | --- | --- | --- |
|NI|Yes|No information. There is no information which can be inferred from this exceptional value.|No value is provided in OBX-5.|
|NAV|Yes|Temporarily not available. Information is not available at this time but it is expected that it will be available later.|No value is provided in OBX-5.|
|OFF|Yes|Numeric measurement function is available but has been deactivated by user.|No value is provided in OBX-5.|
|>|N|Above absolute high-off instrument scale.|Provide the high-off instrument scale number in OBX-5 if available.|
|<|N|Below absolute low-off instrument scale.|Provide the low-off instrument scale number in OBX-5 if available.|
{: .grid}

#### OBX-18 Equipment Instance Identifier 

In IHE PCD-01, the purpose of this field is to uniquely identify the source of the observation based on the EUI-64 of the Virtual Medical Device (VMD) if that has a unique identifier, or if not, the EUI-64 of the Medical Device System.

#### OBX-20 Observation site
This often does not need to be given, since in many cases the OBX-3 Observation Identifier clearly indicates the body site. Otherwise, in IHE PCD-01, body site values from MDC nomenclature may be used. Equivalent codes from other systems, e.g. SNOMED, should also be given in the CodeableConcept for user convenience.

### OBR Observation Request Segment

The OBR segment in a device data segment contains information mostly about the order associated with 
the data in the set of OBX segments that follows the OBR segment.
For monitoring or other device data, there is often not a specific order for such data. The responsible
clinician for the patient will decide dynamically what monitoring is required depending on the changing
state of the patient. For device data, the main interest in the OBR segment is that the timestamp
is implicitly the timestamp for all the OBX segments in the set following the OBR, so that 
a receiving system needs to persist the OBX timestamp so that it may be copied into the Observation
resources generated from those OBX segments.


|FIELD|DT|OPT|RP/#|ELEMENT NAME|FHIR_MAPPING|NOTES|
| --- | --- | --- | --- | --- | --- | --- |
|OBR-2|EI|O||Placer Order Number|
|OBR-3|EI|R||Filler Order Number|
|OBR-4|CWE|R||Universal Service Identifier|
|OBR-7|DTM|RE||Observation Date/Time|
|OBR-16|XCN|O|Y|Ordering Provider|
{: .grid}


### MSH Message Header Segment

This segment largely contains HL7 Version 2-specific information.
Only a small proportion of it is pertinent to implementers of this Guide
except possibly as context information.

|SEQ|LEN|DT|Usage|Card.|TBL#|Element name|FHIR Mapping|Comments|
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
|MSH-3|227|HD|R|[1..1]|361|Sending Application|
|MSH-4|227|HD|RE|[0..1]|362|Sending Facility|
|MSH-5|227|HD|RE|[0..1]|361|Receiving Application|
|MSH-6|227|HD|RE|[0..1]|362|Receiving Facility|
|MSH-7|24|DTM|R|[1..1]||Date/Time of Message|
|MSH-8|40|ST|X|[0..0]||Security|
|MSH-9|15|MSG|R|[1..1]||Message Type|
|MSH-10|199|ST|R|[1..1]||Message Control Id|
|MSH-11|3|PT|R|[1..1]||Processing Id|
|MSH-12|60|VID|R|[1..1]||Version ID|
|MSH-22|567|XON|X|[0..0]||Sending Responsible Organization|
|MSH-23|567|XON|X|[0..0]||Receiving Responsible Organization|
|MSH-24|227|HD|X|[0..0]||Sending Network Address|
|MSH-25|227|HD|X|[0..0]||Receiving Network Address|
{: .grid}

### PID Patient Identification Setment

As has been stated, other hospital systems mainly manage patient identity data and device systems or gateways 
play little role. The few data fields that are sometimes pertinent to devices 
or gateway implementation, mainly as searh keys for linking to other information, are included in this table.

|SEQ|LEN|DT|OPT|RP/#|TBL#|ELEMENT NAME|
| --- | --- | --- | --- | --- | --- | --- |
|3|250|CX|O|Y||Patient Identifier List|
|5|250|XPN|O|Y||Patient name|
|7|26|TSO|O|||Date/Time of Birth|
|8|1|IS|O|||Administrative Sex|
{: .grid}

### PID Patient Visit Segment

Assigned patient location could be needed to link to other data.



|SEQ|LEN|DT|OPT|RP/#|TBL#|ELEMENT NAME|FHIR MAPPING|COMMENTS|
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
|3|80|PL|O|||Assigned Patient Location|
{: .grid}


