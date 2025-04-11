import 'package:meta/meta.dart';

import 'list.dart';
import 'types.dart';
import 'union.dart';

@immutable
// ignore: camel_case_types
class boolean extends AcanthisType<bool> {
  const boolean([
    AcanthisOperation<bool>? op1,
    AcanthisOperation<bool>? op2,
  ]) : super(isNullable: false, op1: op1, op2: op2);

  const boolean.nullable([
    AcanthisOperation<bool>? op1,
    AcanthisOperation<bool>? op2,
  ]) : super(isNullable: true, op1: op1, op2: op2);

  const boolean.withDefault(
    bool defaultValue, [
    AcanthisOperation<bool>? op1,
    AcanthisOperation<bool>? op2,
  ]) : super(isNullable: false, op1: op1, op2: op2, defaultValue: defaultValue);

  const boolean.raw({
    super.defaultValue,
    required super.isNullable,
    super.operations,
  });

  /// Add a check to the boolean to check if it is true
  boolean isTrue() {
    return withCheck(BooleanChecks.isTrue);
  }

  /// Add a check to the boolean to check if it is false
  boolean isFalse() {
    return withCheck(BooleanChecks.isFalse);
  }

  /// Create a list of booleans
  AcanthisList<bool> list() {
    return AcanthisList(this);
  }

  /// Create a union from the nullable
  AcanthisUnion or(List<AcanthisType> elements) {
    return AcanthisUnion([this, ...elements]);
  }

  @override
  boolean withAsyncCheck(BaseAcanthisAsyncCheck<bool> check) {
    return boolean.raw(
      isNullable: isNullable,
      operations: [...operations, check],
      defaultValue: defaultValue,
    );
  }

  @override
  boolean withCheck(BaseAcanthisCheck<bool> check) {
    return boolean.raw(
      isNullable: isNullable,
      operations: [...operations, check],
      defaultValue: defaultValue,
    );
  }

  @override
  boolean withTransformation(BaseAcanthisTransformation<bool> transformation) {
    return boolean.raw(
      isNullable: isNullable,
      operations: [...operations, transformation],
      defaultValue: defaultValue,
    );
  }
}

abstract class BooleanChecks extends BaseAcanthisCheck<bool> {
  const BooleanChecks();
  static bool _isTrueCheck(bool value) => value;
  static const isTrue = AcanthisCheck<bool>(
      name: 'isTrue', error: 'Value must be true', onCheck: _isTrueCheck);
  static bool _isFalseCheck(bool value) => !value;
  static const isFalse = AcanthisCheck<bool>(
      name: 'isFalse', error: 'Value must be false', onCheck: _isFalseCheck);
}
