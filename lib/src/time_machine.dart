import 'package:fhir_r4/fhir_r4.dart';
import 'package:time_machine2/time_machine2.dart';

extension InstantX on Instant {
  FhirInstant toFhirInstant() {
    final pattern = OffsetDateTimePattern.createWithInvariantCulture(
      "uuuu-MM-dd'T'HH:mm:ss.fffo<G>",
    );

    return FhirInstant.fromString(pattern.format(inUtc().toOffsetDateTime()));
  }

  FhirDateTime toFhirDateTime() {
    final pattern = OffsetDateTimePattern.createWithInvariantCulture(
      "uuuu-MM-dd'T'HH:mm:ss.fffo<G>",
    );

    return FhirDateTime.fromString(pattern.format(inUtc().toOffsetDateTime()));
  }
}

extension LocalDateTimeX on LocalDateTime {
  FhirDateTime toFhirDateTime() {
    final pattern = LocalDateTimePattern.createWithInvariantCulture(
      "uuuu-MM-dd'T'HH:mm:ss.fff",
    );

    return FhirDateTime.fromString(pattern.format(this));
  }
}

extension LocalDateX on LocalDate {
  FhirDate toFhirDate() {
    final pattern = LocalDatePattern.iso;

    return FhirDate.fromString(pattern.format(this));
  }
}

extension LocalTimeX on LocalTime {
  FhirTime toFhirTime() {
    final pattern = LocalTimePattern.createWithInvariantCulture("HH:mm:ss.fff");
    return FhirTime(pattern.format(this));
  }
}
