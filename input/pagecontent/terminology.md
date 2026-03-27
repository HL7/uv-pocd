
The ISO/IEEE 11073-10101 Nomenclature standard (MDC) provides a comprehensive terminology for device models according to the ISO/IEEE 11073-10201 Domain information model (DIM). It's the preferred code system for profiles in this implementation guide. Reference identifiers, terminology codes, and descriptions are available at the [Rosetta Terminology Mapping Management System](https://rtmms.nist.gov/rtmms/index.htm) (RTMMS).

### Terminology Usage Rules

The PoCD profiles define rules for terminology usage:

- `Device.type` shall have a coding from the MDC Device nomenclature if there is an appropriate code available. This ensures consistent coding using the ISO/IEEE 11073-10101 Nomenclature standard, which provides MDS, VMD, and Channel codes for device models according to the DIM. If there is no code available, proposed or private MDC codes or coding from an alternative code system may be used. As this element is of type CodeableConcept there can be additional coding from other code systems.
- Same for the `DeviceMetric.type`, which shall have a coding from the MDC Metric nomenclature if there is an appropriate code available.
- `DeviceMetric.unit` is an optional element of type CodeableConcept. If present, it shall have a coding from the MDC Units of measurement if there is an appropriate code available. Additional other coding is allowed as well. This element is the place for the MDC unit code, because the Observation resource has other constraints - see below.
- The PoCD Observation profiles require an MDC coding in `Observation.code` and, for compound metrics, in `Observation.component.code`. 
- The Quantity data type in `Observation.value[x]` and `Observation.component.value[x]` contains the units of measure. There is only a single coding that needs to be [UCUM](https://hl7.org/fhir/ucum.html). Therefore the PoCD profiles require the use of UCUM coding for all numerics (when available).

The [Vital Signs Profile](https://hl7.org/fhir/observation-vitalsigns.html), which is part of the FHIR core specification, applies for some commonly used measurement observations (e.g., heart rate, blood pressure, respiratory rate, oxygen saturation, body temperature):

- Depending on the type of measurement, the Vital Signs profile may require [LOINC](https://hl7.org/fhir/loinc.html) codes as additional coding. Note that the MDC code can be more specific than the Vital Signs LOINC code.
- The Quantity data type in `Observation.value[x]` and `Observation.component.value[x]` contains the units of measure. There is only a single coding that needs to be [UCUM](https://hl7.org/fhir/ucum.html) for all vital signs.

Regenstrief, developers of LOINC, and IEEE, developers of the 11073 standards, are working together to support interoperable communications of medical and personal health devices. There is a [LOINC/IEEE Medical Device Code Mapping Table](https://loinc.org/download/loincieee-medical-device-code-mapping-table/) available as a product of this collaboration.

### Code Systems

| Code System | Description |
|-------------|-------------|
| [Operating mode code system](CodeSystem-operating-mode.html) | Operating mode definitions from the ISO/IEEE 11073-10207. |
| [Safety classification code system](CodeSystem-safety.html) | Safety classification definitions from the ISO/IEEE 11073-10207. |
| [Kind of relation code system](CodeSystem-kind-of-relation.html) | Relation definitions from the ISO/IEEE 11073-10207. |
| [Metric availability code system](CodeSystem-metric-availability.html) | Metric availability definitions from the ISO/IEEE 11073-10207. |
| [Measurement status codes](CodeSystem-measurement-status.html) | Measurement status definitions from the ISO/IEEE 11073-10201 DIM. |

### Value Sets

| Value Set | Description |
|-----------|-------------|
| [MDC Object infrastructure and Device nomenclature](ValueSet-11073MDC-object.html) | ValueSet for the ISO/IEEE 11073-10101 Nomenclature filtered by Object partition. |
| [MDC Metric nomenclature](ValueSet-11073MDC-metric.html) | ValueSet for the ISO/IEEE 11073-10101 Nomenclature filtered by Metric (SCADA or Settings) partition. |
| [MDC Unit of Measurement](ValueSet-11073MDC-dimension.html) | ValueSet for the ISO/IEEE 11073-10101 Nomenclature filtered by Dimension partition. |
| [Operating mode value set](ValueSet-operating-mode.html) | ValueSet for IEEE 11073-10207 MdsState/OperatingMode. |
| [Safety classification value set](ValueSet-safety-classification.html) | ValueSet for IEEE 11073-10207 SafetyClassification. |
| [Kind of relation value set](ValueSet-kind-of-relation.html) | ValueSet for IEEE 11073-10207 Relation/Kind. |
| [Metric availability value set](ValueSet-metric-availability.html) | ValueSet for IEEE 11073-10207 MetricAvailability. |
| [Observation interpretation codes](ValueSet-observation-interpretation.html) | Observation interpretation codes including measurement status. |

### Downloading Codes from RTMMS

The [Rosetta Terminology Mapping Management System](https://rtmms.nist.gov/rtmms/index.htm) (RTMMS) provides a comprehensive database of codes and descriptions for the ISO/IEEE 11073-10101 Nomenclature standard (MDC). You can use it to find codes and descriptions for specific elements. The full set of codes is also available for download (as Excel file or FHIR CodeSystem).

### Expansion of MDC-based Value Sets in this guide

The MDC-based value sets in this guide are available in an expanded form - limited by the IG Publisher to the first 1000 codes. The full sets of codes in the underlying codesystem can be retrieved by following the link to the codesystem used for the expansion in the page for the valueset.