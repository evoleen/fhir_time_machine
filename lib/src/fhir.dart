import 'package:fhir/r4.dart';
import 'package:time_machine2/time_machine2.dart';

extension FhirInstantX on FhirInstant {
  /// Converts a [FhirDateTime] to an [Instant] using the FHIR date time pattern.
  /// The upstream implementation of [FhirInstant] is very forgiving and will
  /// add missing time components to the timestamp.
  ///
  /// Throws a [FormatException] if:
  /// - The input string doesn't match any of the expected formats
  /// - The timestamp doesn't include a time zone specification
  Instant toInstant() {
    // try with milliseconds first
    try {
      final pattern = OffsetDateTimePattern.createWithInvariantCulture(
        "uuuu-MM-dd'T'HH:mm:ss.FFFFFFo<G>",
      );

      final offsetDateTime = pattern.parse(toString()).value;
      return offsetDateTime.toInstant();
    } catch (e) {
      // try with seconds only
      try {
        final pattern = OffsetDateTimePattern.createWithInvariantCulture(
          "uuuu-MM-dd'T'HH:mm:sso<G>",
        );

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

extension FhirDateTimeX on FhirDateTime {
  /// Converts a [FhirDateTime] to an [Instant] using the FHIR date time pattern.
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
    // try with milliseconds first
    try {
      final pattern = OffsetDateTimePattern.createWithInvariantCulture(
        "uuuu-MM-dd'T'HH:mm:ss.FFFFFFo<G>",
      );

      final offsetDateTime = pattern.parse(toString()).value;
      return offsetDateTime.toInstant();
    } catch (e) {
      // try with seconds only
      try {
        final pattern = OffsetDateTimePattern.createWithInvariantCulture(
          "uuuu-MM-dd'T'HH:mm:sso<G>",
        );

        final offsetDateTime = pattern.parse(toString()).value;
        return offsetDateTime.toInstant();
      } catch (e) {
        // try with minutes only
        try {
          final pattern = OffsetDateTimePattern.createWithInvariantCulture(
            "uuuu-MM-dd'T'HH:mmo<G>",
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

  /// Converts a [FhirDateTime] to a [LocalDateTime]
  ///
  /// Throws a [FormatException] if:
  /// - The input string doesn't match any of the expected formats
  LocalDateTime toLocalDateTime() {
    // try with milliseconds first
    try {
      final pattern = LocalDateTimePattern.createWithInvariantCulture(
        "uuuu-MM-dd'T'HH:mm:ss.fff",
      );

      final localDateTime = pattern.parse(toString()).value;
      return localDateTime;
    } catch (e) {
      // try with seconds only
      try {
        final pattern = LocalDateTimePattern.createWithInvariantCulture(
          "uuuu-MM-dd'T'HH:mm:ss",
        );

        final localDateTime = pattern.parse(toString()).value;
        return localDateTime;
      } catch (e) {
        // try with minutes only
        try {
          final pattern = LocalDateTimePattern.createWithInvariantCulture(
            "uuuu-MM-dd'T'HH:mm",
          );

          final localDateTime = pattern.parse(toString()).value;
          return localDateTime;
        } catch (e) {
          throw FormatException(
            'Failed to parse "$valueString". Input must match one of the supported formats.',
          );
        }
      }
    }
  }

  /// Converts a [FhirDate] to a [LocalDate]
  LocalDate toLocalDate() {
    try {
      final pattern = LocalDatePattern.iso;
      return pattern.parse(valueString).value;
    } catch (e) {
      throw FormatException(
        'Failed to parse "$valueString". Input must be a valid date in the format YYYY-MM-DD.',
      );
    }
  }
}

extension FhirDateX on FhirDate {
  /// Converts a [FhirDate] to a [LocalDate]
  LocalDate toLocalDate() {
    try {
      final pattern = LocalDatePattern.iso;
      return pattern.parse(valueString).value;
    } catch (e) {
      throw FormatException(
        'Failed to parse "$valueString". Input must be a valid date in the format YYYY-MM-DD.',
      );
    }
  }
}

extension FhirTimeX on FhirTime {
  /// Converts a [FhirTime] to a [LocalTime]
  LocalTime toLocalTime() {
    try {
      final pattern = LocalTimePattern.createWithInvariantCulture(
        "HH':'mm':'ss",
      );
      return pattern.parse(value!).value;
    } catch (e) {
      throw FormatException(
        'Failed to parse "$value". Input must be a valid time in the format HH:MM:SS.',
      );
    }
  }
}
