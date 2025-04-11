import 'dart:collection';

import 'package:meta/meta.dart';
import '../exceptions/async_exception.dart';
import '../exceptions/validation_error.dart';
import 'nullable.dart';

/// A class to validate types
@immutable
abstract class AcanthisType<O> {
  // This should not be accessed anywhere else besides for the `operations` getter
  final List<AcanthisOperation<O>> __operations;

  /// The operations that the type should perform
  @internal
  UnmodifiableListView<AcanthisOperation<O>> get operations =>
      UnmodifiableListView(__operations);

  final bool isAsync;

  /// The constructor of the class
  const AcanthisType(
      {List<AcanthisOperation<O>> operations = const [], this.isAsync = false})
      : __operations = operations;

  /// The parse method to parse the value
  /// it returns a [AcanthisParseResult] with the parsed value and throws a [ValidationError] if the value is not valid
  AcanthisParseResult<O> parse(O value) {
    if (isAsync) {
      throw AsyncValidationException('Cannot use parse with async operations');
    }
    O newValue = value;
    for (var operation in operations) {
      switch (operation) {
        case BaseAcanthisCheck operation:
          if (!operation(newValue)) {
            throw ValidationError(operation.error);
          }
        case BaseAcanthisTransformation operation:
          newValue = operation(newValue);
      }
    }
    return AcanthisParseResult(value: newValue);
  }

  /// The tryParse method to try to parse the value
  /// it returns a [AcanthisParseResult]
  /// that has the following properties:
  /// - success: A boolean that indicates if the parsing was successful or not.
  /// - value: The value of the parsing. If the parsing was successful, this will contain the parsed value.
  /// - errors: The errors of the parsing. If the parsing was unsuccessful, this will contain the errors of the parsing.
  AcanthisParseResult<O> tryParse(O value) {
    if (isAsync) {
      throw AsyncValidationException(
          'Cannot use tryParse with async operations');
    }
    final errors = <String, String>{};
    O newValue = value;
    for (var operation in operations) {
      switch (operation) {
        case BaseAcanthisCheck operation:
          if (!operation(newValue)) {
            errors[operation.name] = operation.error;
          }
        case BaseAcanthisTransformation operation:
          newValue = operation(newValue);
      }
    }
    return AcanthisParseResult(
        value: newValue, errors: errors, success: errors.isEmpty);
  }

  /// The parseAsync method to parse the value that uses [AcanthisAsyncCheck]
  /// it returns a [AcanthisParseResult] with the parsed value and throws a [ValidationError] if the value is not valid
  Future<AcanthisParseResult<O>> parseAsync(O value) async {
    O newValue = value;
    for (var operation in operations) {
      switch (operation) {
        case BaseAcanthisCheck operation:
          if (!operation(newValue)) {
            throw ValidationError(operation.error);
          }
          break;
        case BaseAcanthisAsyncCheck operation:
          if (!await operation(newValue)) {
            throw ValidationError(operation.error);
          }
          break;
        case BaseAcanthisTransformation operation:
          newValue = operation(newValue);
          break;
      }
    }
    return AcanthisParseResult(value: newValue);
  }

  /// The tryParseAsync method to try to parse the value that uses [AcanthisAsyncCheck]
  /// it returns a [AcanthisParseResult]
  /// that has the following properties:
  /// - success: A boolean that indicates if the parsing was successful or not.
  /// - value: The value of the parsing. If the parsing was successful, this will contain the parsed value.
  /// - errors: The errors of the parsing. If the parsing was unsuccessful, this will contain the errors of the parsing.
  Future<AcanthisParseResult<O>> tryParseAsync(O value) async {
    final errors = <String, String>{};
    O newValue = value;
    for (var operation in operations) {
      switch (operation) {
        case BaseAcanthisCheck operation:
          if (!operation(newValue)) {
            errors[operation.name] = operation.error;
          }
          break;
        case BaseAcanthisAsyncCheck operation:
          if (!await operation(newValue)) {
            errors[operation.name] = operation.error;
          }
          break;
        case BaseAcanthisTransformation operation:
          newValue = operation(newValue);
          break;
      }
    }
    return AcanthisParseResult(
        value: newValue, errors: errors, success: errors.isEmpty);
  }

  /// Add a check to the type
  AcanthisType<O> withCheck(BaseAcanthisCheck<O> check);

  /// Add an async check to the type
  AcanthisType<O> withAsyncCheck(BaseAcanthisAsyncCheck<O> check);

  /// Make the type nullable
  AcanthisNullable nullable({O? defaultValue}) {
    return AcanthisNullable(this, defaultValue: defaultValue);
  }

  /// Add a custom check to the number
  AcanthisType<O> refine(
      {required bool Function(O value) onCheck,
      required String error,
      required String name}) {
    return withCheck(
        AcanthisCheck<O>(onCheck: onCheck, error: error, name: name));
  }

  /// Add a custom async check to the number
  AcanthisType<O> refineAsync(
      {required Future<bool> Function(O value) onCheck,
      required String error,
      required String name}) {
    return withAsyncCheck(
        AcanthisAsyncCheck<O>(onCheck: onCheck, error: error, name: name));
  }

  /// Add a pipe transformation to the type to transform the value to another type
  AcanthisPipeline<O, T> pipe<T>(
    AcanthisType<T> type, {
    required T Function(O value) transform,
  }) {
    return AcanthisPipeline(inType: this, outType: type, transform: transform);
  }

  /// Add a transformation to the type
  AcanthisType<O> withTransformation(
      BaseAcanthisTransformation<O> transformation);

  /// Add a typed transformation to the type. It does not transform the value if the type is not the same
  AcanthisType<O> transform(O Function(O value) transformation) {
    return withTransformation(
        AcanthisTransformation<O>(transformation: transformation));
  }
}

/// A base class for creating synchronous check operations.
///
/// This class is designed for scenarios where checks need to be
/// instantiated using `const` constructors. It provides a foundation
/// for implementing custom validation logic.
///
/// In most cases, prefer using the [AcanthisCheck] class unless
/// you require a more specialized implementation that cannot be
/// achieved with [AcanthisCheck].
///
/// For checks that are executed asynchronously, use the
/// [BaseAcanthisAsyncCheck] class.
@immutable
abstract class BaseAcanthisCheck<O> extends AcanthisOperation<O> {
  /// The error message of the check
  String get error;

  /// The name of the check
  String get name;

  /// The constructor of the class
  const BaseAcanthisCheck();

  /// The function to check the value
  bool onCheck(O toTest);

  /// The call method to create a Callable class
  @override
  bool call(O value) {
    try {
      return onCheck(value);
    } catch (e) {
      return false;
    }
  }
}

/// A class that represents a check operation.
///
/// This class is used to encapsulate the logic and data associated with
/// performing a check operation.
///
/// ```dart
/// final schema = number().withCheck(
///  AcanthisCheck(
///    error: 'Value must be a valid email',
///    name: 'over18',
///    onCheck: (value) => value > 18,
/// ));
/// ```
///
/// If you need to create a check that can be used with `const`, you can
/// use the [BaseAcanthisCheck] class instead.
///
/// For checks are executed asynchronously, use the [AcanthisAsyncCheck] class.
@immutable
class AcanthisCheck<O> extends BaseAcanthisCheck<O> {
  /// The function to check the value
  final bool Function(O value) onCheckCallback;

  @override
  final String error;

  @override
  final String name;

  /// The constructor of the class
  const AcanthisCheck(
      {this.error = '',
      this.name = '',
      required bool Function(O value) onCheck})
      : onCheckCallback = onCheck;

  @override
  bool onCheck(O toTest) => onCheckCallback(toTest);
}

/// A base class for creating asynchronous check operations.
///
/// This class is designed for scenarios where checks need to be
/// instantiated using `const` constructors. It provides a foundation
/// for implementing custom validation logic.
///
/// In most cases, prefer using the [AcanthisAsyncCheck] class unless
/// you require a more specialized implementation that cannot be
/// achieved with [AcanthisAsyncCheck].
///
/// For checks that are executed synchronously, use the
/// [BaseAcanthisCheck] class.
@immutable
abstract class BaseAcanthisAsyncCheck<O> extends AcanthisOperation<O> {
  /// The error message of the check
  String get error;

  /// The name of the check
  String get name;

  /// The constructor of the class
  const BaseAcanthisAsyncCheck();

  /// The function to check the value
  Future<bool> onCheck(O toTest);

  /// The call method to create a Callable class
  @override
  Future<bool> call(O value) async {
    try {
      return onCheck(value);
    } catch (e) {
      return false;
    }
  }
}

/// A class that represents an asynchronous check operation.
///
/// This class is used to encapsulate the logic and data associated with
/// performing a check operation.
///
/// ```dart
/// final schema = string().url().withCheck(
///  AcanthisCheck(
///    error: 'Value must be a working link',
///    name: 'workingLink',
///    onCheck: (value) async {
///    final response = await http.get(Uri.parse(value));
///    return response.statusCode == 200;
///   }
/// ));
/// ```
///
/// If you need to create a check that can be used with `const`, you can
/// use the [BaseAcanthisCheck] class instead.
///
/// For checks are executed asynchronously, use the [AcanthisAsyncCheck] class.
@immutable
class AcanthisAsyncCheck<O> extends BaseAcanthisAsyncCheck<O> {
  /// The function to check the value asynchronously
  final Future<bool> Function(O value) onCheckCallback;

  @override
  final String error;

  @override
  final String name;

  /// The constructor of the class
  const AcanthisAsyncCheck(
      {this.error = '',
      this.name = '',
      required Future<bool> Function(O value) onCheck})
      : onCheckCallback = onCheck;

  @override
  Future<bool> onCheck(O toTest) => onCheckCallback(toTest);
}

/// A base class for creating synchronous check operations.
///
/// This class is designed for scenarios where checks need to be
/// instantiated using `const` constructors. It provides a foundation
/// for implementing custom validation logic.
///
/// In most cases, prefer using the [AcanthisTransformation] class unless
/// you require a more specialized implementation that cannot be
/// achieved with [AcanthisTransformation].
@immutable
abstract class BaseAcanthisTransformation<O> extends AcanthisOperation<O> {
  /// The transformation function
  O transformation(O toTransform);

  /// The constructor of the class
  const BaseAcanthisTransformation();

  /// The call method to create a Callable class
  @override
  O call(O toTransform) {
    return transformation(toTransform);
  }
}

/// A class that represents a transformation operation.
///
/// This class is used to encapsulate the logic and data associated with
/// performing a transformation operation.
///
/// ```dart
/// final schema = number().withTransformation(
///   AcanthisTransformation(
///     transformation: (value) => value * 50,
/// ));
/// ```
///
/// If you need to create a transformation that can be used with `const`, you can
/// use the [BaseAcanthisTransformation] class instead.
@immutable
class AcanthisTransformation<O> extends BaseAcanthisTransformation<O> {
  /// Callback function to transform the value
  final O Function(O value) transformationCallback;

  /// The constructor of the class
  const AcanthisTransformation({required O Function(O value) transformation})
      : transformationCallback = transformation;

  /// The call method to create a Callable class
  @override
  O call(O toTransform) {
    return transformation(toTransform);
  }

  @override
  O transformation(O toTransform) {
    return transformationCallback(toTransform);
  }
}

/// A class that represents an operation
@immutable
abstract class AcanthisOperation<O> {
  /// The constructor of the class
  const AcanthisOperation();

  /// The call method to create a Callable class
  dynamic call(O value);
}

@immutable
class AcanthisPipeline<O, T> {
  final AcanthisType<O> inType;

  final AcanthisType<T> outType;

  final T Function(O value) transform;

  const AcanthisPipeline(
      {required this.inType, required this.outType, required this.transform});

  AcanthisParseResult parse(O value) {
    var inResult = inType.parse(value);
    final T newValue;
    try {
      newValue = transform(inResult.value);
    } catch (e) {
      return AcanthisParseResult(
          value: inResult.value,
          errors: {'transform': 'Error transforming the value from $O -> $T'},
          success: false);
    }
    var outResult = outType.parse(newValue);
    return outResult;
  }

  AcanthisParseResult tryParse(O value) {
    var inResult = inType.tryParse(value);
    if (!inResult.success) {
      return inResult;
    }
    final T newValue;
    try {
      newValue = transform(inResult.value);
    } catch (e) {
      return AcanthisParseResult(
          value: inResult.value,
          errors: {'transform': 'Error transforming the value from $O -> $T'},
          success: false);
    }
    var outResult = outType.tryParse(newValue);
    return outResult;
  }

  Future<AcanthisParseResult> parseAsync(O value) async {
    final inResult = await inType.parseAsync(value);
    final T newValue;
    try {
      newValue = transform(inResult.value);
    } catch (e) {
      return AcanthisParseResult(
          value: inResult.value,
          errors: {'transform': 'Error transforming the value from $O -> $T'},
          success: false);
    }
    final outResult = await outType.parseAsync(newValue);
    return outResult;
  }

  Future<AcanthisParseResult> tryParseAsync(O value) async {
    var inResult = await inType.tryParseAsync(value);
    if (!inResult.success) {
      return inResult;
    }
    final T newValue;
    try {
      newValue = transform(inResult.value);
    } catch (e) {
      return AcanthisParseResult(
          value: inResult.value,
          errors: {'transform': 'Error transforming the value from $O -> $T'},
          success: false);
    }
    var outResult = await outType.tryParseAsync(newValue);
    return outResult;
  }
}

/// A class to represent the result of a parse operation
@immutable
class AcanthisParseResult<O> {
  /// The value of the parsing
  final O value;

  /// The errors of the parsing
  final Map<String, dynamic> errors;

  /// A boolean that indicates if the parsing was successful or not
  final bool success;

  /// The constructor of the class
  const AcanthisParseResult(
      {required this.value, this.errors = const {}, this.success = true});

  @override
  String toString() {
    return 'AcanthisParseResult<$O>{value: $value, errors: $errors, success: $success}';
  }
}
