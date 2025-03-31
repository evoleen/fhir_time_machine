import 'package:fhir/r4.dart';
import 'package:time_machine2/time_machine2.dart';

extension FhirInstantX on FhirInstant {
  /// Converts a [FhirDateTime] to an [Insant] using the FHIR date time pattern.
  ///
  /// Throws a [FormatException] if:
  /// - The input string doesn't match any of the expected formats
  /// - The timestamp doesn't include a time zone specification
  Instant toInstant() {
    try {
      final pattern = OffsetDateTimePattern.createWithInvariantCulture(
        "uuuu-MM-dd'T'HH:mm:ss[.FFF]O",
      );

      if (!toString().contains('+') &&
          !toString().contains('-') &&
          !toString().contains('Z')) {
        throw FormatException(
          'Timestamp must include a time zone offset or UTC "Z" specification.',
        );
      }

      final offsetDateTime = pattern.parse(toString()).value;
      return offsetDateTime.toInstant();
    } catch (e) {
      if (e is FormatException) {
        rethrow;
      }
      throw FormatException(
        'Failed to parse "$valueString". Input must include a valid time zone specification and match one of the supported formats.',
      );
    }
  }
}

extension FhirDateTimeX on FhirDateTime {
  /// Converts a [FhirDateTime] to an [Insant] using the FHIR date time pattern.
  /// It first attempts to parse the string using the extended ISO 8601 format.
  /// If unsuccessful, it will try the general ISO 8601 format.
  /// If both fail, it will try the FHIR specific format. The FHIR time stamp
  /// MUST have a time zone offset or UTC "Z" specification, otherwise an
  /// exception is thrown.
  ///
  /// Throws a [FormatException] if:
  /// - The input string doesn't match any of the expected formats
  /// - The timestamp doesn't include a time zone specification
  Instant toInstant() {
    // try extended format first, then simple format, then the FHIR specific format
    try {
      return ZonedDateTimePattern.extendedFormatOnlyIso
          .withDefaultZoneProvider()
          .parse(toString())
          .value
          .toInstant();
    } catch (e) {
      try {
        return ZonedDateTimePattern.generalFormatOnlyIso
            .withDefaultZoneProvider()
            .parse(toString())
            .value
            .toInstant();
      } catch (e) {
        try {
          final pattern = OffsetDateTimePattern.createWithInvariantCulture(
            "uuuu-MM-dd'T'HH:mm[:ss[.FFF]]O",
          );

          if (!toString().contains('+') &&
              !toString().contains('-') &&
              !toString().contains('Z')) {
            throw FormatException(
              'Timestamp must include a time zone offset or UTC "Z" specification.',
            );
          }

          final offsetDateTime = pattern.parse(toString()).value;
          return offsetDateTime.toInstant();
        } catch (e) {
          if (e is FormatException) {
            rethrow;
          }
          throw FormatException(
            'Failed to parse "$valueString". Input must include a valid time zone specification and match one of the supported formats.',
          );
        }
      }
    }
  }
}
