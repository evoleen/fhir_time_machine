import 'package:fhir/r4.dart';
import 'package:fhir_time_machine/fhir_time_machine.dart';
import 'package:test/test.dart';
import 'package:time_machine2/time_machine2.dart';

void main() {
  group('InstantX', () {
    test('toFhirInstant() converts UTC Instant correctly', () {
      final instant = Instant.utc(2021, 1, 1, 0, 0);
      final fhirInstant = instant.toFhirInstant();
      expect(fhirInstant, isA<FhirInstant>());
      expect(fhirInstant.valueString, '2021-01-01T00:00:00.000Z');
    });

    test('toFhirInstant() converts Instant with milliseconds correctly', () {
      final instant = Instant.utc(
        2021,
        1,
        1,
        0,
        0,
        0,
      ).add(Time(milliseconds: 123));
      final fhirInstant = instant.toFhirInstant();
      expect(fhirInstant, isA<FhirInstant>());
      expect(fhirInstant.valueString, '2021-01-01T00:00:00.123Z');
    });

    test('toFhirDateTime() converts UTC Instant correctly', () {
      final instant = Instant.utc(2021, 1, 1, 0, 0);
      final fhirDateTime = instant.toFhirDateTime();
      expect(fhirDateTime, isA<FhirDateTime>());
      expect(fhirDateTime.valueString, '2021-01-01T00:00:00.000Z');
    });

    test('toFhirDateTime() converts Instant with milliseconds correctly', () {
      final instant = Instant.utc(
        2021,
        1,
        1,
        0,
        0,
        0,
      ).add(Time(milliseconds: 123));
      final fhirDateTime = instant.toFhirDateTime();
      expect(fhirDateTime, isA<FhirDateTime>());
      expect(fhirDateTime.valueString, '2021-01-01T00:00:00.123Z');
    });
  });

  group('LocalDateTimeX', () {
    test('toFhirDateTime() converts LocalDateTime correctly', () {
      final localDateTime = LocalDateTime(2021, 1, 1, 0, 0, 0);
      final fhirDateTime = localDateTime.toFhirDateTime();
      expect(fhirDateTime, isA<FhirDateTime>());
      expect(fhirDateTime.valueString, '2021-01-01T00:00:00.000');
    });

    test(
      'toFhirDateTime() converts LocalDateTime with milliseconds correctly',
      () {
        final localDateTime = LocalDateTime(2021, 1, 1, 0, 0, 0, ms: 123);
        final fhirDateTime = localDateTime.toFhirDateTime();
        expect(fhirDateTime, isA<FhirDateTime>());
        expect(fhirDateTime.valueString, '2021-01-01T00:00:00.123');
      },
    );
  });

  group('LocalDateX', () {
    test('toFhirDate() converts LocalDate correctly', () {
      final localDate = LocalDate(2021, 2, 1);
      final fhirDate = localDate.toFhirDate();
      expect(fhirDate, isA<FhirDate>());
      expect(fhirDate.valueString, '2021-02-01');
    });
  });

  group('LocalTimeX', () {
    test('toFhirTime() converts LocalTime correctly', () {
      final localTime = LocalTime(1, 2, 3);
      final fhirTime = localTime.toFhirTime();
      expect(fhirTime, isA<FhirTime>());
      expect(fhirTime.value, '01:02:03.000');
    });

    test('toFhirTime() converts LocalTime with milliseconds correctly', () {
      final localTime = LocalTime(1, 2, 3, ms: 123);
      final fhirTime = localTime.toFhirTime();
      expect(fhirTime, isA<FhirTime>());
      expect(fhirTime.value, '01:02:03.123');
    });
  });
}
