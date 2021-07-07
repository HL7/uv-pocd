### Overview of the Point-of-Care Device General Implementation Guide in relation to IEEE 11073 Domain Information Model
This implementation Guide provides point-of-care device data organized according to the IEEE 11073-10201 Domain Information Model (DIM), to provide a framework for enriching the numeric and waveform observations with context not provided by the FHIR Observation Resource and the Device Resource by themselves. The context is to allow a receiving system to determine attributes of the device system and its subsystems that bear on the interpretation of the observations.

The profile uses the Device and DeviceMetric FHIR resources to convey these attributes. The Device resource is used to map both the Medical Device System and Virtual Medical Device, which have a container object - contained object relationship in the DIM. So the Device resource corresponding to the Virtual Medical Device has a parent link to the containing Medical Device System.

The most fundamental elements of this standards suite are a Domain Information Model, and a nomenclature. These define data objects which support the reporting of 
* periodic measurements like pulse rate or oxygen saturation 
* episodic measurement like noninvasive blood pressure 
* waveform observations like ECG or respiration waves

#### Benefits of the IEEE 11073 Domain Information Model in Some FHIR Use Cases
For some device data use cases, it may be enough (or seem enough) to know just the measured values in the Observation resource. But supporting information like the details of the provenance of the data, the state attributes and calibration characteristics of the device or the subsystem of the device responsible for the observations enables a wide range of other use cases. A suite of international standards, the ISO/IEEE 11073 Medical Device Communications, defines an object-oriented information model for organizing and communicating all of this structure.

#### Traceability and Provenance
Using the DIM allows tracking down an observation to the precise instrument, module, and channel that originated it. This tracking is vital to be able to do in the case of an adverse event, and in research uses.

#### Device, Subsystem, and Measurement attributes
The DIM standard provides a well-established standardized framework for providing key instrumental attributes associated with the capabilities and current state of the components of the device object hierarchy (the "containment model"). Some of these values are included directly in the Device and DeviceMetric FHIR resources, and less-frequently used ones may be attached as FHIR extensions.