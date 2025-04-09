import 'list.dart';
import 'types.dart';
import 'union.dart';

/// A class to validate date types
class AcanthisDate extends AcanthisType<DateTime> {
  const AcanthisDate({
    super.operations,
    super.isAsync,
  });

  /// Add a check to the date to check if it is before or equal to [value]
  AcanthisDate min(DateTime value) {
    return withCheck(DateChecks.min(value));
  }

  /// Add a check to the date to check if it is after or equal to [value]
  AcanthisDate differsFromNow(Duration difference) {
    return withCheck(DateChecks.differsFromNow(difference));
  }

  /// Add a check to the date to check if it is less than or equal to [value]
  AcanthisDate max(DateTime value) {
    return withCheck(DateChecks.max(value));
  }

  /// Create a list of dates
  AcanthisList<DateTime> list() {
    return AcanthisList<DateTime>(this);
  }

  /// Create a union from the string
  AcanthisUnion or(List<AcanthisType> elements) {
    return AcanthisUnion([this, ...elements]);
  }

  @override
  AcanthisDate withAsyncCheck(BaseAcanthisAsyncCheck<DateTime> check) {
    return AcanthisDate(
      operations: operations.add(check),
      isAsync: true,
    );
  }

  @override
  AcanthisDate withCheck(BaseAcanthisCheck<DateTime> check) {
    return AcanthisDate(
      operations: operations.add(check),
    );
  }

  @override
  AcanthisDate withTransformation(
      BaseAcanthisTransformation<DateTime> transformation) {
    return AcanthisDate(
      operations: operations.add(transformation),
    );
  }
}

/// Create a new date type
AcanthisDate date() => AcanthisDate();

abstract class DateChecks extends BaseAcanthisCheck<DateTime> {
  const DateChecks({
    required super.name,
  });
  const factory DateChecks.min(DateTime value) = _DateMinCheck;
  const factory DateChecks.max(DateTime value) = _DateMaxCheck;
  const factory DateChecks.differsFromNow(Duration difference) =
      _DateDifferenceCheck;
}

class _DateMinCheck extends DateChecks {
  final DateTime value;

  const _DateMinCheck(this.value)
      : super(
          name: 'min',
        );
  @override
  bool onCheck(DateTime toTest) => toTest.compareTo(value) >= 0;
  @override
  String get error => 'The date must be greater than or equal to $value';
}

class _DateMaxCheck extends DateChecks {
  final DateTime value;

  const _DateMaxCheck(this.value)
      : super(
          name: 'max',
        );
  @override
  bool onCheck(DateTime toTest) => toTest.compareTo(value) <= 0;
  @override
  String get error => 'The date must be less than or equal to $value';
}

class _DateDifferenceCheck extends DateChecks {
  final Duration difference;

  const _DateDifferenceCheck(this.difference)
      : super(
          name: 'differsFromNow',
        );

  @override
  bool onCheck(DateTime toTest) {
    return toTest.difference(DateTime.now()).abs() >= difference;
  }

  @override
  String get error => 'The date must differ from now by $difference or more';
}
