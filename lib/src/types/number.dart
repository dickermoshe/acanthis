import 'dart:math' as math;

import 'list.dart';
import 'types.dart';
import 'union.dart';

/// A class to validate number types
class AcanthisNumber extends AcanthisType<num> {
  const AcanthisNumber({super.isAsync, super.operations});

  /// Add a check to the number to check if it is less than or equal to [value]
  AcanthisNumber lte(num value) {
    return withCheck(NumericChecks.lte(value));
  }

  /// Add a check to the number to check if it is greater than or equal to [value]
  AcanthisNumber gte(num value) {
    return withCheck(NumericChecks.gte(value));
  }

  AcanthisNumber between(num min, num max) {
    return withCheck(
      NumericChecks.between(
        min: min,
        max: max,
      ),
    );
  }

  /// Add a check to the number to check if it is greater than [value]
  AcanthisNumber gt(num value) {
    return withCheck(NumericChecks.gt(value));
  }

  /// Add a check to the number to check if it is less than [value]
  AcanthisNumber lt(num value) {
    return withCheck(NumericChecks.lt(value));
  }

  /// Add a check to the number to check if it is positive
  AcanthisNumber positive() {
    return withCheck(NumericChecks.positive);
  }

  /// Add a check to the number to check if it is negative
  AcanthisNumber negative() {
    return withCheck(NumericChecks.negative);
  }

  /// Add a check to the number to check if it is an integer
  AcanthisNumber integer() {
    return withCheck(NumericChecks.int);
  }

  /// Add a check to the number to check if it is a double
  AcanthisNumber double() {
    return withCheck(NumericChecks.double);
  }

  /// Add a check to the number to check if it is a multiple of [value]
  AcanthisNumber multipleOf(int value) {
    return withCheck(NumericChecks.multipleOf(value));
  }

  /// Add a check to the number to check if it is finite
  AcanthisNumber finite() {
    return withCheck(NumericChecks.finite);
  }

  /// Add a check to the number to check if it is infinite
  AcanthisNumber infinite() {
    return withCheck(NumericChecks.infinite);
  }

  /// Add a check to the number to check if it is "not a number"
  AcanthisNumber nan() {
    return withCheck(NumericChecks.nan);
  }

  /// Add a check to the number to check if it is not "not a number"
  AcanthisNumber notNaN() {
    return withCheck(NumericChecks.notNaN);
  }

  /// Create a list of numbers
  AcanthisList<num> list() {
    return AcanthisList<num>(this);
  }

  /// Transform the number to a power of [value]
  AcanthisNumber pow(num value) {
    return withTransformation(NumericTansforms.pow(value));
  }

  /// Create a union from the number
  AcanthisUnion or(List<AcanthisType> elements) {
    return AcanthisUnion([this, ...elements]);
  }

  @override
  AcanthisNumber withAsyncCheck(BaseAcanthisAsyncCheck<num> check) {
    return AcanthisNumber(operations: operations.add(check), isAsync: true);
  }

  @override
  AcanthisNumber withCheck(BaseAcanthisCheck<num> check) {
    return AcanthisNumber(operations: operations.add(check));
  }

  @override
  AcanthisNumber withTransformation(
      BaseAcanthisTransformation<num> transformation) {
    return AcanthisNumber(operations: operations.add(transformation));
  }
}

/// Create a number type
AcanthisNumber number() => AcanthisNumber();

abstract class NumericChecks extends BaseAcanthisCheck<num> {
  const NumericChecks({
    required super.error,
    required super.name,
  });

  const factory NumericChecks.lte(num value) = _LteCheck;
  const factory NumericChecks.gte(num value) = _GteCheck;
  const factory NumericChecks.gt(num value) = _GtCheck;
  const factory NumericChecks.lt(num value) = _LtCheck;
  const factory NumericChecks.between({required num min, required num max}) =
      _BetweenCheck;
  const factory NumericChecks.multipleOf(num value) = _MultipleOfCheck;
  static const positive = _PositiveCheck();
  static const negative = _NegativeCheck();
  static const int = _IntCheck();
  static const double = _DoubleCheck();
  static const finite = _IsFiniteCheck();
  static const infinite = _IsInfiniteCheck();
  static const nan = _IsNaNCheck();
  static const notNaN = _IsNotNaNCheck();
}

class _LteCheck extends NumericChecks {
  final num value;
  const _LteCheck(this.value)
      : super(
          error: 'Value must be less than or equal to $value',
          name: 'lte',
        );

  @override
  bool onCheck(num toTest) => toTest <= value;
}

class _GteCheck extends NumericChecks {
  final num value;
  const _GteCheck(this.value)
      : super(
          error: 'Value must be greater than or equal to $value',
          name: 'gte',
        );

  @override
  bool onCheck(num toTest) => toTest >= value;
}

class _GtCheck extends NumericChecks {
  final num value;
  const _GtCheck(this.value)
      : super(
          error: 'Value must be greater than $value',
          name: 'gt',
        );

  @override
  bool onCheck(num toTest) => toTest > value;
}

class _LtCheck extends NumericChecks {
  final num value;
  const _LtCheck(this.value)
      : super(
          error: 'Value must be less than $value',
          name: 'lt',
        );

  @override
  bool onCheck(num toTest) => toTest < value;
}

class _BetweenCheck extends NumericChecks {
  final num min;
  final num max;
  const _BetweenCheck({required this.min, required this.max})
      : super(
          error: 'Value must be between $min and $max',
          name: 'between',
        );

  @override
  bool onCheck(num toTest) => toTest >= min && toTest <= max;
}

class _PositiveCheck extends NumericChecks {
  const _PositiveCheck()
      : super(
          error: 'Value must be positive',
          name: 'positive',
        );

  @override
  bool onCheck(num toTest) => toTest > 0;
}

class _NegativeCheck extends NumericChecks {
  const _NegativeCheck()
      : super(
          error: 'Value must be negative',
          name: 'negative',
        );

  @override
  bool onCheck(num toTest) => toTest < 0;
}

class _IntCheck extends NumericChecks {
  const _IntCheck()
      : super(
          error: 'Value must be an integer',
          name: 'integer',
        );

  @override
  bool onCheck(num toTest) => toTest is int;
}

class _DoubleCheck extends NumericChecks {
  const _DoubleCheck()
      : super(
          error: 'Value must be a double',
          name: 'double',
        );

  @override
  bool onCheck(num toTest) => toTest is double;
}

class _MultipleOfCheck extends NumericChecks {
  final num value;

  const _MultipleOfCheck(
    this.value,
  ) : super(
          error: 'Value must be a multiple of $value',
          name: 'multipleOf',
        );

  @override
  bool onCheck(num toTest) => toTest % value == 0;
}

class _IsFiniteCheck extends NumericChecks {
  const _IsFiniteCheck()
      : super(
          error: 'Value must be finite',
          name: 'isFinite',
        );

  @override
  bool onCheck(num toTest) => toTest.isFinite;
}

class _IsInfiniteCheck extends NumericChecks {
  const _IsInfiniteCheck()
      : super(
          error: 'Value must be infinite',
          name: 'isInfinite',
        );

  @override
  bool onCheck(num toTest) => toTest.isInfinite;
}

class _IsNaNCheck extends NumericChecks {
  const _IsNaNCheck()
      : super(
          error: 'Value is not NaN',
          name: 'nan',
        );

  @override
  bool onCheck(num toTest) => toTest.isNaN;
}

class _IsNotNaNCheck extends NumericChecks {
  const _IsNotNaNCheck()
      : super(
          error: 'Value is NaN',
          name: 'notNaN',
        );

  @override
  bool onCheck(num toTest) => !toTest.isNaN;
}

abstract class NumericTansforms extends BaseAcanthisTransformation<num> {
  const NumericTansforms();
  const factory NumericTansforms.pow(num value) = _PowerTransformation;
}

class _PowerTransformation extends NumericTansforms {
  final num exponent;
  const _PowerTransformation(this.exponent);

  @override
  num transformation(num toTransform) => math.pow(toTransform, exponent);
}
