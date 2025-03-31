import 'package:fhir/r4.dart';
import 'package:fhir_time_machine/fhir_time_machine.dart';
import 'package:test/test.dart';
import 'package:time_machine2/time_machine2.dart';

void main() {
  group('FhirDateTimeX', () {
    test('toInstant() converts timestamp with Z offset correctly', () {
      final dateTime = FhirDateTime('2021-01-01T00:00:00Z');
      final instant = dateTime.toInstant();
      expect(instant, isA<Instant>());
      expect(instant, Instant.utc(2021, 1, 1, 0, 0));
    });

    test('toInstant() converts timestamp with +00:00 offset correctly', () {
      final dateTime = FhirDateTime('2021-01-01T00:00:00+00:00');
      final instant = dateTime.toInstant();
      expect(instant, isA<Instant>());
      expect(instant, Instant.utc(2021, 1, 1, 0, 0));
    });

    test('toInstant() converts timestamp with -00:00 offset correctly', () {
      final dateTime = FhirDateTime('2021-01-01T00:00:00-00:00');
      final instant = dateTime.toInstant();
      expect(instant, isA<Instant>());
      expect(instant, Instant.utc(2021, 1, 1, 0, 0));
    });

    test('toInstant() converts timestamp with +01:00 offset correctly', () {
      final dateTime = FhirDateTime('2021-01-01T00:00:00+01:00');
      final instant = dateTime.toInstant();
      expect(instant, isA<Instant>());
      expect(instant, Instant.utc(2020, 12, 31, 23, 0));
    });

    test('toInstant() converts timestamp with -01:00 offset correctly', () {
      final dateTime = FhirDateTime('2021-01-01T00:00:00-01:00');
      final instant = dateTime.toInstant();
      expect(instant, isA<Instant>());
      expect(instant, Instant.utc(2021, 1, 1, 1, 0));
    });

    test('toInstant() converts timestamp with milliseconds correctly', () {
      final dateTime = FhirDateTime('2021-01-01T00:00:00.123+00:00');
      final instant = dateTime.toInstant();
      expect(instant, isA<Instant>());
      expect(
        instant,
        Instant.utc(2021, 1, 1, 0, 0, 0).add(Time(milliseconds: 123)),
      );
    });
  });

  group('FhirInstantX', () {
    test('toFhirDateTime() converts instant with Z offset correctly', () {
      final fhirInstant = FhirInstant('2021-01-01T00:00:00Z');
      final instant = fhirInstant.toInstant();
      expect(instant, isA<Instant>());
      expect(instant, Instant.utc(2021, 1, 1, 0, 0));
    });

    test('toFhirDateTime() converts instant with +00:00 offset correctly', () {
      final fhirInstant = FhirInstant('2021-01-01T00:00:00+00:00');
      final instant = fhirInstant.toInstant();
      expect(instant, isA<Instant>());
      expect(instant, Instant.utc(2021, 1, 1, 0, 0));
    });

    test('toFhirDateTime() converts instant with -00:00 offset correctly', () {
      final fhirInstant = FhirInstant('2021-01-01T00:00:00-00:00');
      final instant = fhirInstant.toInstant();
      expect(instant, isA<Instant>());
      expect(instant, Instant.utc(2021, 1, 1, 0, 0));
    });

    test('toFhirDateTime() converts instant with +01:00 offset correctly', () {
      final fhirInstant = FhirInstant('2021-01-01T00:00:00+01:00');
      final instant = fhirInstant.toInstant();
      expect(instant, isA<Instant>());
      expect(instant, Instant.utc(2020, 12, 31, 23, 0));
    });

    test('toFhirDateTime() converts instant with -01:00 offset correctly', () {
      final fhirInstant = FhirInstant('2021-01-01T00:00:00-01:00');
      final instant = fhirInstant.toInstant();
      expect(instant, isA<Instant>());
      expect(instant, Instant.utc(2021, 1, 1, 1, 0));
    });
  });
}
