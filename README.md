# Point-of-Care Device (PoCD) Implementation Guide Repository

This implementation guide focuses on the application of FHIR to the general category of Point-of-Care Devices (PoCD), such as those typically found in a hospital care setting (e.g., physiological monitors, infusion pumps, ventilators, pulse-oximeters, etc.).

### Canonical URL
The canonical URL of this implementation guide is http://hl7.org/fhir/uv/pocd

### Continuous Integration Build
The rendered implementation guide is available at https://build.fhir.org/ig/HL7/uv-pocd

For the build log, see https://build.fhir.org/ig/HL7/uv-pocd/build.log  
For validation output, see https://build.fhir.org/ig/HL7/uv-pocd/qa.html

### Local Build
Install the FHIR IG Publisher and Jekyll as described in the [IG Publisher Documentation](http://wiki.hl7.org/index.php?title=IG_Publisher_Documentation#Installing).

Clone the Git repository to your local file system: `git clone https://github.com/HL7/uv-pocd.git`  
In the `uv-pocd` directory, run the publisher with control file as argument: `java -jar org.hl7.fhir.igpublisher.jar -ig ig.ini`  
`_updatePublisher.bat` and `_genonce.bat` updates the build tooling and performs a local build in a Windows environment,
`./_updatePublisher.sh` and `./_genonce.sh` updates the build tooling and performs a local build in a Linux environment.
When completed, point your browser to `index.html` in the `uv-pocd/output` directory.
