Extension: Calibration
Id: calibration
Title: "Calibration extension"
Description: "StructureDefinition that adds calibration information to a Device using the same elements as DeviceMetric.calibration (type, state, time), plus references to other devices involved in the calibration."
Context: Device
* . ^short = "Calibration details"
* . ^definition = "Describes the calibrations that have been performed or that are required for the Device."
* ^url = "http://hl7.org/fhir/StructureDefinition/device-calibration"
* url = "http://hl7.org/fhir/StructureDefinition/device-calibration" (exactly)
* value[x] 0..0

* extension contains
    type 0..1 and
    state 0..1 and
    time 0..1 and
    device 0..*

* extension[type] ^short = "Calibration type"
* extension[type] ^definition = "Describes the type of the calibration method."
* extension[type].value[x] 1..
* extension[type].value[x] only code
* extension[type].valueCode from http://hl7.org/fhir/ValueSet/metric-calibration-type (required)
* extension[type].valueCode ^binding.description = "MetricCalibrationType"

* extension[state] ^short = "Calibration state"
* extension[state] ^definition = "Describes the state of the calibration."
* extension[state].value[x] 1..
* extension[state].value[x] only code
* extension[state].valueCode from http://hl7.org/fhir/ValueSet/metric-calibration-state (required)
* extension[state].valueCode ^binding.description = "MetricCalibrationState"

* extension[time] ^short = "Calibration time"
* extension[time] ^definition = "Describes the time last calibration has been performed."
* extension[time].value[x] 1..
* extension[time].value[x] only instant

* extension[device] ^short = "Device involved in calibration"
* extension[device] ^definition = "Reference to a device involved in performing, measuring, or validating this calibration."
* extension[device].value[x] 1..
* extension[device].value[x] only Reference(Device)