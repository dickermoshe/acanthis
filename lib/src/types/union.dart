import 'package:acanthis/src/types/nullable.dart';

import 'types.dart';
import '../exceptions/validation_error.dart';

/// A class to validate union types that can be one of the elements in the list
class AcanthisUnion extends AcanthisType<dynamic> {
  final List<AcanthisType> elements;

  const AcanthisUnion(this.elements, {super.operations, super.isAsync});

  /// override of the [parse] method from [AcanthisType]
  @override
  AcanthisParseResult<dynamic> parse(dynamic value) {
    for (var element in elements) {
      try {
        final result = element.tryParse(value);
        if (result.success) {
          return result;
        }
      } catch (_) {}
    }
    throw ValidationError('Value does not match any of the elements');
  }

  /// override of the [tryParse] method from [AcanthisType]
  @override
  AcanthisParseResult<dynamic> tryParse(dynamic value) {
    for (var element in elements) {
      try {
        final result = element.tryParse(value);
        if (result.success) {
          return result;
        }
      } catch (_) {}
    }
    return AcanthisParseResult(
        value: value,
        errors: {'union': 'Value does not match any of the elements'},
        success: false);
  }

  @override
  AcanthisNullable nullable({defaultValue}) {
    for (var element in elements) {
      if (element is AcanthisNullable) {
        return element;
      }
      return element.nullable(defaultValue: defaultValue);
    }
    return AcanthisNullable(this, defaultValue: defaultValue);
  }

  @override
  AcanthisUnion withAsyncCheck(AcanthisAsyncCheck check) {
    return AcanthisUnion(
      elements,
      operations: operations.add(check),
      isAsync: true,
    );
  }

  @override
  AcanthisUnion withCheck(AcanthisCheck check) {
    return AcanthisUnion(
      elements,
      operations: operations.add(check),
    );
  }

  @override
  AcanthisUnion withTransformation(AcanthisTransformation transformation) {
    return AcanthisUnion(
      elements,
      operations: operations.add(transformation),
    );
  }
}

/// A class that represents a transformation operation
AcanthisUnion union(List<AcanthisType> elements) {
  return AcanthisUnion(elements);
}
