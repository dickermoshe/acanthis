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
    return withCheck(AcanthisCheck<bool>(
        onCheck: (value) => value,
        error: 'Value must be true',
        name: 'isTrue'));
  }

  /// Add a check to the boolean to check if it is false
  AcanthisBoolean isFalse() {
    return withCheck(AcanthisCheck<bool>(
        onCheck: (value) => !value,
        error: 'Value must be false',
        name: 'isFalse'));
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
  AcanthisBoolean withAsyncCheck(AcanthisAsyncCheck<bool> check) {
    return AcanthisBoolean(
      operations: operations.add(check),
      isAsync: true,
    );
  }

  @override
  AcanthisBoolean withCheck(AcanthisCheck<bool> check) {
    return AcanthisBoolean(
      operations: operations.add(check),
    );
  }

  @override
  AcanthisBoolean withTransformation(
      AcanthisTransformation<bool> transformation) {
    return AcanthisBoolean(
      operations: operations.add(transformation),
    );
  }
}

/// Create a boolean validator
AcanthisBoolean boolean() => AcanthisBoolean();
