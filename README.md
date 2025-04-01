# FHIR / Time Machine converters

Utility extensions to help convert date/time types from Dart's [FHIR package](https://github.com/fhir-fli) to [Time Machine](https://github.com/evoleen/time_machine2) types.

FHIR has very flexible date and time representations. FHIR's `dateTime` type allows YYYY, YYYY-MM, YYYY-MM-dd, etc - all the way to also allowing microsecond precision, with and without time zone offset. This is complicated in practice, because applications usually need to know which format to expect.

At the same time, Dart's date/time system is severely flawed because it doesn't distinguish properly between timestamps with offsets and without offsets. It also doesn't support proper time zones and is unable to handle daylight saving transitions.

[Time Machine](https://pub.dev/packages/time_machine2) is able to handle all these cases and creates a type-safe way to deal with timestamps with different precision / completeness.

This package provides an opinionated way to translate FHIR `dateTime`, `date` and `time` types to Time Machine's `Instant`, `LocalDate` and `LocalTime` types.

## Rationale

Consider a basic scheduling system where a patient can schedule appointments with their healthcare provider. The system consists of a patient app and a backend that manages the appointments. For the sake of this example, the patient is in Europe (CET timezone) and the backend works in UTC (default timezone for any server).

The patient schedules an appointment at 2025-03-17, 15:00 CET, stored as `2025-03-17T15:00+01:00`. After the appointment is completed, the backend shall automatically schedule a follow-up *exactly* two weeks after the initial appointment. The backend would just add two weeks to the initial date and get `2025-03-31T15:00+01:00` as a result. However, this timestamp would be one hour off, because CET would have undergone a DST transition in the meantime and now have an offset of `+02:00` - something that the FHIR presentation unfortunately swallows.

## Best practices

- Always work with `Instant`, for as long as possible - they represent unique, unambiguous points in time globally.
- Convert to `ZonedDateTime` or `LocalDateTime` only for the purpose of displaying a time stamp or when you have to work with wall clock time, otherwise avoid the conversion.
- If you have to convert to a `ZonedDateTime` or `LocalDateTime`, *always* use the time zone of the person / entity that is supposed to receive the converted time stamp. If you don't know the target time zone, don't use UTC as an easy way out - it will be wrong more often than it will be right.
- If you need to modify a time stamp based on local time (for example "last midnight"), use temporary conversions to `ZonedDateTime`: `Instant.now().inZone(clientTimeZone).atStartOfDay().toInstant()`. That way you avoid accidentally working with `ZonedDateTime`, potentially trying to change timezones.
- Don't convert to a FHIR type, modify the FHIR type and convert back to a Time Machine type. Arithmetics and modifications should only be performed on the Time Machine types.
- Don't add extensions to convert to `ZonedDateTime` by using the `inUtc()` or `inLocalZone()` methods. This package doesn't provide these extensions by choice to force developers to make a conscious decision about the target time zone.

## Converting FhirInstant

```dart
final instant = FhirInstant('2025-03-17T15:00+01:00').toInstant();
```

This is the easiest and most straight-forward conversion. A time zone offset *must* be present. Milliseconds are optional, but seconds are required.

## Converting FhirDateTime

A `FhirDateTime` can be converted to an `Instant` or to a `LocalDateTime`. The client needs to know in advance which conversion is needed.

```dart
final dateTime = FhirDateTime('2025-03-17T15:00+01:00').toInstant();
```

The conversion is similar to the `FhirInstant` conversion, but makes milliseconds and seconds optional. A time zone offset is required.

```dart
final localDateTime = FhirDateTime('2025-03-17T15:00').toLocalDateTime();
```

This conversion works if no time zone offset is present.

## Converting FhirDate

```dart
final date = FhirDate('2025-03-17').toLocalDate();
```

A `FhirDate` can only be converted to a `LocalDate` because it doesn't contain any time zone information. The application needs to know the target time zone if it wants to convert the date to a `ZonedDateTime` or `Instant`.

## Converting FhirTime

```dart
final time = FhirTime('15:00').toLocalTime();
```

A `FhirTime` can only be converted to a `LocalTime` because it doesn't contain any date or time zone information.

## Converting from Time Machine types to FHIR types

```dart
final fhirInstant = Instant.now().toFhirInstant();
final fhirDateTime = Instant.now().toFhirDateTime();
final fhirDateTime2 = LocalDateTime.now().toFhirDateTime();
final fhirDate = LocalDate.today().toFhirDate();
final fhirTime = LocalTime.currentClockTime().toFhirTime();
```

Converting from Time Machine types to FHIR types is easier than the other way around, because the conversions are always unambiguous.
