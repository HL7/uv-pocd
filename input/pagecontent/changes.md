### Version 1.0.0

* Add typed reference range support for DeviceMetric, including the new reference range extension and related terminology artifacts.
* Add calibration guidance for SDC use cases where calibration information is reported at MDS or VMD level, using a Device-level calibration extension.
* Expand UDI mapping guidance and element coverage across DIM, HL7 V2, and SDC mappings.
* Add and refine narrative guidance, including added use case descriptions, updates to the overview page, and revised mapping content.
* Align selected CodeSystem and ValueSet canonicals to terminology.hl7.org URLs and update guidance for terminology packaging.
* Update IG publication and structure artifacts, including template updates and additions to artifact/page definitions for STU publication readiness.

### Version 0.3.0

* Add "Getting Started" section.
* Add "Technical Implementation Guidance" section with mappings from HL7 V2 and ISO/IEEE 11073.
* Update all artifacts to FHIR Release #4 (version 4.0.1).
* Add Sample Array DeviceMetric and Observation profiles and extensions for waveforms.
* Add Device and DeviceMetric extensions and value sets for SDC mappings.
* Add mustSupport flags to profile definitions.
* Add Server CapabilityStatement.
* Update and add examples.

### Version 0.2.0

* Move content from Simplifier to GitHub for use by the IG Publisher, including restructuring and formatting changes.
* Replace PoC Device and DeviceComponent profiles with MDS, VMD, and Channel Device profiles reflecting the Device-DeviceComponent resource merge.
* Change Device.type, DeviceMetric.type, DeviceMetric.unit, Observation.code, and Observation.component.code to an extensible binding to the 11073 MDC terminology.
* Replace measurement status extension by an extended value set for Observation.interpretation and Observation.component.interpretation.
* Create ValueSets for the 11073 MDC nomenclature filtered by partition.
* Create CodeSystem and extend ValueSet for Observation interpretation codes including measurement status.
* Update examples for new profile definitions.

### Version 0.1.0

* First draft for comment.