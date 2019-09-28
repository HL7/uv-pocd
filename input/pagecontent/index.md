### Purpose
This Implementation Guide defines the use of FHIR resources to convey measurements and supporting data from acute care point-of-care medical devices (PoCD) to receiving systems for electronic medical records, clinical decision support, and medical data archiving for aggregate quality measurement and research purposes. It could be considered "deep metadata for device observations". Key goals include supplementing the measurement values with full provenance for traceability, and with further details of device architecture and dynamically changing attributes such as calibration history and battery state than is provided for in a FHIR Observation resource. 

Other related implementation guides focus on home-based personal health devices, and physiological and technical alerts from medical devices.

### Audience
This Implementation Guide is intended for device system developers, system integrators, FHIR architects, and clinical users of point-of-care device information.

### Scope and Boundaries
**Editor**:  Include scope to PoCD and general.  

**_Question_**:  Include reference to what of the 11073-10201 model is out-of-bounds for this IG?

### Relationship to Other Projects & Guides
This Implementation Guide covers material related to work in other projects and guides including the Personal Health Device Implementation Guide, and IHE Patient Care Device (PCD) profiles.

#### Personal Health Device IG
The [Personal Health Device Implementation guide](http://hl7.org/fhir/uv/phd/) treats wellness and chronic disease management devices used mainly by nonprofessionals in home and exercise settings. This Guide is focused on acute-care devices for professional use mainly in healthcare delivery facilities. The Personal Health Device and Point-of-Care Device guides both use information models and nomenclature from the IEEE 11073 Medical Device Communications series of standards and the guides for these two kinds of devices are being developed cooperatively in the Devices On FHIR project with a goal of consistency and ease of use by use by receiving systems.

#### Unique Device Identifier (UDI) IG(s)
**Editor**:  UDI Pattern IG and any other IGs.

#### IHE Patient Care Device (PCD) Profiles
The IHE PCD domain has developed profiles for conveying acute care device data with context using HL7 V2. The base information system and nomenclature are based on the IEEE 11073 Medical Device Communications standards, also used in this FHIR Implementation Guide. 

These profiles cover Device Enterprise Communications (DEC), reporting device observations to enterprise systems including near-real-time charting to electronic medical records, clinical decision support systems and patient data archive systems. That is similar to the scope of this FHIR Implementation Guide.

A planned future FHIR use case for the Devices on FHIR group is the near-real-time communication of physiological and technical alerts to clinicians, and internal device status and state transition information for systems designed to process such information. This is similar to IHE PCD Alert Communication Management and Infusion Pump Event Communication profiles.

Other PCD profiles include Implantable Device Cardiac Observations, Point-of-Care Infusion Verification.

#### Vital Signs Profile
The Observation resource is used to record data that is retrieved from a device (see {{pagelink:ObservationProfiles}}).  Some values that are formalized in this resource are required to conform to the [Vital Signs Profile](http://hl7.org/fhir/observation-vitalsigns.html).  For example, heart rate or respiratory rate, many of which are often provided by a PoCD patient-connected device.  

This requirement is a challenge, though, for devices that only communicate ISO/IEEE 11073 terminology (the Vital Signs Profile) requires LOINC and UCUM).  As a result, provisions must be made to correctly make the mapping for these terms from 11073 to LOINC and to ensure that they are done at the earliest possible point.

This is an area of coordination between this IG and the Vital Signs Profile.

### Structure of this Guide
**Editor**:  Provide short synopsis of the IG.

### Abbreviations & Conventions
**Editor:**  Add the top abbreviations or definitions here w/ links to more information (internal to the IG or external)

Add ...
* "MDC"
* "PoCD"
* "PHD"
* "X73"
* "11073" 
* "healthcare devices vs. medical devices"

### Future Guide Revisions
Future capabilities are planned for this General PoCD IG including:
1. Waveform Support
2. Device Events & Alerts including:
  * Basic PCD ACM / 60601-1-8 reporting
  * Status notifications back to the source Device
3. Query for "fresh" data:
  * Indirect via a FHIR gateway where a request is made to the device using Protocol (X)
  * Direct to the device where it has a minimized "server" capability
         
