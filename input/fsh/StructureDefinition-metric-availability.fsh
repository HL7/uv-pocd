Extension: MetricAvailability
Id: metric-availability
Title: "Metric availability extension"
Description: "StructureDefinition that adds metric availability to a DeviceMetric."
Context: DeviceMetric
* ^url = "http://hl7.org/fhir/uv/pocd/StructureDefinition/metric-availability"
* . ^short = "Availability of metrics"
* . ^definition = "Availability of the means that derives the metric state."
* url = "http://hl7.org/fhir/uv/pocd/StructureDefinition/metric-availability" (exactly)
* value[x] 1..
* value[x] only CodeableConcept
* value[x] from DeviceMetricAvailability (extensible)
* value[x] ^short = "Metric availability"
* value[x] ^binding.description = "Metric Availability"