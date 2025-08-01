### Purpose
This Implementation Guide defines the use of FHIR resources to convey measurements and supporting data 
from acute care point-of-care medical devices (PoCD) intended for use by qualified professional to receiving systems for electronic medical records, 
clinical decision support, and medical data archiving for aggregate quality measurement and research purposes. 
It adds "deep metadata for device observations".  
Key goals include supplementing the measurement values in an Observation resource with full provenance for traceability, and with 
fuller details of device architecture and dynamically changing attributes such as 
calibration history and battery state than is provided for in a FHIR Observation resource. This guide is intended to supplement — not replace — existing approaches such as HL7v2/IHE PCD-01 for communicating device data to device observation consumers.

The next release of this Guide intends to cover physiological and technical alerts from medical devices.
Another related implementation guide focuses on home-based personal health devices. 

### Scope and Boundaries
The scope of this Implementation Guide is a FHIR-based treatment of
quantitative and qualitative observations communicated from point-of-care medical devices. Devices without communications capabilities are out of scope. Imaging devices are also out of scope.
Personal devices intented for home health and fitness 
purposes to be used by non-professional users are excluded because they are covered by a
related Implementation Guide. See below.

### Intended Readers
This Implementation Guide is intended for 
- clinical users of point-of-care device data, 
- implementers of other health information systems wishing to use this extended data,
- device and device gateway system developers. 

### Structure of this Guide
The "Getting Started" pages, which include a reference page on Abbreviations and Definitions, give a general introduction to the concepts and approach used in this Implementation Guide, relevant to all potential users of this Guide including end users of the data. There are also pages devoted to each of the two main categories of implementers needing developer-level information:

- information relevant to implementers of systems consuming data that has 
and "Profile" section details

- More detailed information for implementers of device and gateway systems who are setting 
up device models in such a way as to  accomodate the needs of data consumer applications.


### Relationship to Other Projects & Guides
This Implementation Guide covers material related to work in other projects and guides including the Personal Health Device Implementation Guide, and IHE Patient Care Device (PCD) profiles.

#### Personal Health Device IG
The [Personal Health Device Implementation guide](http://hl7.org/fhir/uv/phd/) focuses on wellness and chronic disease management devices used mainly by nonprofessionals in home and exercise settings. 

This Point-of-Care Device Implementation Guide is focused on acute-care devices for professional use mainly in healthcare delivery facilities. 

The Personal Health Device and Point-of-Care Device guides both use information models and nomenclature from the IEEE 11073 Medical Device Communications series of standards and the guides for these two kinds of devices are being developed cooperatively in the Devices On FHIR project with a goal of consistency and ease of use by receiving systems.

#### IHE Patient Care Device (PCD) Profiles
The IHE PCD domain has developed profiles for conveying acute care device data with context using HL7 V2. The base information system and nomenclature are based on the IEEE 11073 Medical Device Communications standards, also used in this FHIR Implementation Guide. 

These profiles cover Device Enterprise Communications (DEC), 
reporting device observations to enterprise systems including near-real-time 
charting to electronic medical records, clinical decision support systems and patient data archive systems. 
That is similar to the scope of this FHIR Implementation Guide.

A planned future FHIR use case for the Devices on FHIR group is the near-real-time communication of physiological and technical alerts to clinicians, and internal device status and state transition information for systems designed to process such information. This is similar to IHE PCD Alert Communication Management (ACM) and Infusion Pump Event Communication (IPEC) profiles.

Other PCD profiles include Implantable Device Cardiac Observations (IDCO), Point-of-Care Infusion Verification (PIV) and Point-of-Care Identity Management (PCIM). Future versions of this Implementation Guide will extend scope to cover related functionality based on FHIR rather than HL7 V2.

#### HL7 FHIR Profiles

##### Vital Signs Profile
The Observation resource is used to record data that is retrieved from a device. Some values that are 
formalized in this resource are required to conform to the 
[Vital Signs Profile](http://hl7.org/fhir/observation-vitalsigns.html),
for example, heart rate or respiratory rate. Many of these are often provided by a PoCD patient-connected device.  
It is possible that in rare cases using this Implementation Guide that a device or device gateway using only ISO/IEEE 11073 terminology codes may not have sufficient information to recognize a particular meaurement as within the the Vital Signs set and determine an equivalent LOINC code and UCUM unit code for the result.  Therefor, provisions must be made to correctly make the mapping for these terms from 11073 to LOINC UCUM, and to ensure that this is done at the earliest possible point.

This is an area of necessary coordination between this IG and the Vital Signs Profile.


### Abbreviations & Definitions

See under "Getting Started" -> "Abbreviations and Definitions"

### Future Guide Revisions
Future capabilities are planned for this General PoCD IG including:
1. Waveform Support optimized for high data volumes
2. Device Events & Alerts including:
  * Basic PCD ACM / IEC 60601-1-8 reporting
  * Status notifications back to the source Device
  
  
  

