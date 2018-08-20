# Point-of-Care Device (PoCD) Implementation Guide Repository

This implementation guide focuses on the application of FHIR to the general category of Point-of-Care Devices (PoCD), such as those typically found in a hospital care setting (e.g., physiological monitors, infusion pumps, ventilators, pulse-oximeters, etc.).

### Canonical URL
The canonical URL of this implementation guide is http://hl7.org/fhir/uv/pocd

### Continuous Integration Build
The rendered implementation guide is available at http://hl7.org/fhir/2018Sep/ig/devices-on-fhir/PoCD-IG

For the build log, see http://hl7.org/fhir/2018Sep/ig/devices-on-fhir/PoCD-IG/build.log  
For validation output, see http://hl7.org/fhir/2018Sep/ig/devices-on-fhir/PoCD-IG/qa.html

### Local Build
Install the FHIR IG Publisher and Jekyll as described in the [IG Publisher Documentation](http://wiki.hl7.org/index.php?title=IG_Publisher_Documentation#Installing).

Clone the Git repository to your local file system: `git clone https://github.com/devices-on-fhir/PoCD-IG.git`  
In the `PoCD-IG` directory, run the publisher with JSON control file as argument: `java -jar org.hl7.fhir.igpublisher.jar -ig ig.json`  
When completed, point your browser to `index.html` in the `PoCD-IG/output` directory.