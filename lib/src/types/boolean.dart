import 'list.dart';
import 'types.dart';
import 'union.dart';

class AcanthisBoolean extends AcanthisType<bool> {
  const AcanthisBoolean({
    super.operations,
    super.isAsync,
  });

  /// Add a check to the boolean to check if it is true
  AcanthisBoolean isTrue() {
    return withCheck(BooleanChecks.isTrue);
  }

  /// Add a check to the boolean to check if it is false
  AcanthisBoolean isFalse() {
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
  AcanthisBoolean withAsyncCheck(BaseAcanthisAsyncCheck<bool> check) {
    return AcanthisBoolean(
      operations: operations.add(check),
      isAsync: true,
    );
  }

  @override
  AcanthisBoolean withCheck(BaseAcanthisCheck<bool> check) {
    return AcanthisBoolean(
      operations: operations.add(check),
    );
  }

  @override
  AcanthisBoolean withTransformation(
      BaseAcanthisTransformation<bool> transformation) {
    return AcanthisBoolean(
      operations: operations.add(transformation),
    );
  }
}

/// Create a boolean validator
AcanthisBoolean boolean() => AcanthisBoolean();

abstract class BooleanChecks extends BaseAcanthisCheck<bool> {
  const BooleanChecks({
    required super.error,
    required super.name,
  });
  static const isTrue = _IsTrueCheck();
  static const isFalse = _IsFalseCheck();
}

class _IsTrueCheck extends BooleanChecks {
  const _IsTrueCheck()
      : super(
          error: 'Value must be true',
          name: 'isTrue',
        );

  @override
  bool onCheck(bool toTest) => toTest;
}

class _IsFalseCheck extends BooleanChecks {
  const _IsFalseCheck()
      : super(
          error: 'Value must be false',
          name: 'isFalse',
        );

  @override
  bool onCheck(bool toTest) => !toTest;
}
