import 'dart:collection';

import 'package:acanthis/src/exceptions/async_exception.dart';
import 'package:acanthis/src/types/nullable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:meta/meta.dart';

import '../exceptions/validation_error.dart';
import 'list.dart';
import 'types.dart';

/// A class to validate map types
class AcanthisMap<V> extends AcanthisType<Map<String, V>> {
  final IMap<String, AcanthisType> _fields;
  Map<String, AcanthisType> get fields => UnmodifiableMapView(_fields.unlock);

  final bool _passthrough;
  final IList<_Dependency> _dependencies;
  final IList<String> _optionalFields;

  const AcanthisMap(
    this._fields,
  )   : _passthrough = false,
        _dependencies = const IList.empty(),
        _optionalFields = const IList.empty();

  AcanthisMap._({
    required IMap<String, AcanthisType<dynamic>> fields,
    required bool passthrough,
    required IList<_Dependency> dependencies,
    required IList<String> optionalFields,
    super.isAsync,
    super.operations,
  })  : _fields = fields,
        _passthrough = passthrough,
        _dependencies = dependencies,
        _optionalFields = optionalFields;

  Map<String, V> _parse(Map<String, V> value) {
    final parsed = <String, V>{};
    if (!_fields.keys.every((element) => value.containsKey(element))) {
      for (var field in _fields.keys) {
        if (!value.containsKey(field)) {
          throw ValidationError('Field $field is required');
        }
      }
    }
    for (var obj in value.entries) {
      if (!_fields.containsKey(obj.key)) {
        if (_passthrough) {
          parsed[obj.key] = obj.value;
          continue;
        }
        throw ValidationError('Field ${obj.key} is not allowed in this object');
      }
      if (_fields[obj.key] is LazyEntry) {
        final type = (_fields[obj.key] as LazyEntry).call(this);
        if (obj.value is List) {
          parsed[obj.key] = type
              .parse(List<Map<String, dynamic>>.from(obj.value as List))
              .value;
        } else {
          parsed[obj.key] = type.parse(obj.value).value;
        }
      } else {
        parsed[obj.key] = _fields[obj.key]!.parse(obj.value).value;
      }
    }
    for (var dependency in _dependencies) {
      final dependFrom = _keyQuery(dependency.dependendsOn, value);
      final dependTo = _keyQuery(dependency.dependent, value);
      if (dependFrom != null && dependTo != null) {
        if (!dependency.dependency(dependFrom, dependTo)) {
          throw ValidationError(
              'Dependency not met: ${dependency.dependendsOn}->${dependency.dependent}');
        }
      } else {
        throw ValidationError(
            'The dependency or dependFrom field does not exist in the map');
      }
    }
    final result = super.parse(parsed);
    return result.value;
  }

  Future<Map<String, V>> _asyncParse(Map<String, V> value) async {
    final parsed = <String, V>{};
    if (!_fields.keys.every((element) => value.containsKey(element))) {
      for (var field in _fields.keys) {
        if (!value.containsKey(field)) {
          throw ValidationError('Field $field is required');
        }
      }
    }
    for (var obj in value.entries) {
      if (!_fields.containsKey(obj.key)) {
        if (_passthrough) {
          parsed[obj.key] = obj.value;
          continue;
        }
        throw ValidationError('Field ${obj.key} is not allowed in this object');
      }
      final dynamic result;
      if (_fields[obj.key] is LazyEntry) {
        final type = (_fields[obj.key] as LazyEntry).call(this);
        if (obj.value is List) {
          result = type
              .parseAsync(List<Map<String, dynamic>>.from(obj.value as List));
        } else {
          result = type.parseAsync(obj.value);
        }
      } else {
        result = await _fields[obj.key]!.parseAsync(obj.value);
      }
      parsed[obj.key] = result.value;
    }
    for (var dependency in _dependencies) {
      final dependFrom = _keyQuery(dependency.dependendsOn, value);
      final dependTo = _keyQuery(dependency.dependent, value);
      if (dependFrom != null && dependTo != null) {
        if (!dependency.dependency(dependFrom, dependTo)) {
          throw ValidationError(
              'Dependency not met: ${dependency.dependendsOn}->${dependency.dependent}');
        }
      } else {
        throw ValidationError(
            'The dependency or dependFrom field does not exist in the map');
      }
    }
    final result = await super.parseAsync(parsed);
    return result.value;
  }

  (Map<String, V> values, Map<String, dynamic> errors) _tryParse(
      Map<String, V> value) {
    final parsed = <String, V>{};
    final errors = <String, dynamic>{};
    if (!_fields.keys.every((element) =>
        value.containsKey(element) || _optionalFields.contains(element))) {
      for (var field in _fields.keys) {
        if (!value.containsKey(field)) {
          errors[field] = {'required': 'Field is required'};
        }
      }
    }
    for (var obj in value.entries) {
      if (!_fields.containsKey(obj.key)) {
        if (_passthrough) {
          parsed[obj.key] = obj.value;
        } else {
          errors[obj.key] = {
            'notAllowed': 'Field is not allowed in this object'
          };
        }
        continue;
      }
      final AcanthisParseResult<dynamic> parsedValue;
      if (_fields[obj.key] is LazyEntry) {
        final type = (_fields[obj.key] as LazyEntry).call(this);
        if (obj.value is List) {
          parsedValue =
              type.tryParse(List<Map<String, dynamic>>.from(obj.value as List));
        } else {
          parsedValue = type.tryParse(obj.value);
        }
      } else {
        parsedValue = _fields[obj.key]!.tryParse(obj.value);
      }
      parsed[obj.key] = parsedValue.value;
      errors[obj.key] = parsedValue.errors;
    }
    final result = super.tryParse(parsed);
    for (var dependency in _dependencies) {
      final dependFrom = _keyQuery(dependency.dependendsOn, value);
      final dependTo = _keyQuery(dependency.dependent, value);
      if (dependFrom != null && dependTo != null) {
        if (!dependency.dependency(dependFrom, dependTo)) {
          errors[dependency.dependent] = {'dependency': 'Dependency not met'};
        }
      } else {
        errors[dependency.dependent] = {
          'dependency[${dependency.dependendsOn}->${dependency.dependent}]':
              'The dependency or dependFrom field does not exist in the map'
        };
      }
    }
    return (result.value, errors);
  }

  Future<({Map<String, V> values, Map<String, dynamic> errors})> _tryParseAsync(
      Map<String, V> value) async {
    final parsed = <String, V>{};
    final errors = <String, dynamic>{};
    if (!_fields.keys.every((element) =>
        value.containsKey(element) || _optionalFields.contains(element))) {
      for (var field in _fields.keys) {
        if (!value.containsKey(field)) {
          errors[field] = {'required': 'Field is required'};
        }
      }
    }
    for (var obj in value.entries) {
      if (!_fields.containsKey(obj.key)) {
        if (_passthrough) {
          parsed[obj.key] = obj.value;
        } else {
          errors[obj.key] = {
            'notAllowed': 'Field is not allowed in this object'
          };
        }
        continue;
      }
      final AcanthisParseResult parsedValue;
      if (_fields[obj.key] is LazyEntry) {
        final type = (_fields[obj.key] as LazyEntry).call(this);
        if (obj.value is List) {
          parsedValue = await type.tryParseAsync(
              List<Map<String, dynamic>>.from(obj.value as List));
        } else {
          parsedValue = await type.tryParseAsync(obj.value);
        }
      } else {
        parsedValue = await _fields[obj.key]!.tryParseAsync(obj.value);
      }
      parsed[obj.key] = parsedValue.value;
      errors[obj.key] = parsedValue.errors;
    }
    final result = await super.tryParseAsync(parsed);
    for (var dependency in _dependencies) {
      final dependFrom = _keyQuery(dependency.dependendsOn, value);
      final dependTo = _keyQuery(dependency.dependent, value);
      if (dependFrom != null && dependTo != null) {
        if (!dependency.dependency(dependFrom, dependTo)) {
          errors[dependency.dependent] = {'dependency': 'Dependency not met'};
        }
      } else {
        errors[dependency.dependent] = {
          'dependency[${dependency.dependendsOn}->${dependency.dependent}]':
              'The dependency or dependFrom field does not exist in the map'
        };
      }
    }
    return (values: result.value, errors: errors);
  }

  dynamic _keyQuery(String key, Map<String, V> value) {
    final keys = key.split('.');
    dynamic result = value;
    for (var k in keys) {
      if (result is Map<String, dynamic>) {
        if (result.containsKey(k)) {
          result = result[k];
        } else {
          return null;
        }
      } else {
        return null;
      }
    }
    return result;
  }

  /// Add optional fields to the map
  ///
  /// The optionals are valid only for the current layer of the object
  AcanthisMap<V> optionals(List<String> fields) {
    return AcanthisMap<V>._(
      fields: _fields,
      passthrough: _passthrough,
      dependencies: _dependencies,
      optionalFields: _optionalFields.addAll(fields),
      operations: operations,
      isAsync: isAsync,
    );
  }

  /// Override of [parse] from [AcanthisType]
  @override
  AcanthisParseResult<Map<String, V>> parse(Map<String, V> value) {
    if (isAsync) {
      throw AsyncValidationException(
          'Cannot use tryParse with async operations');
    }
    final parsed = _parse(value);
    return AcanthisParseResult(value: parsed);
  }

  @override
  Future<AcanthisParseResult<Map<String, V>>> parseAsync(
      Map<String, V> value) async {
    final parsed = await _asyncParse(value);
    return AcanthisParseResult(value: parsed);
  }

  @override
  Future<AcanthisParseResult<Map<String, V>>> tryParseAsync(
      Map<String, V> value) async {
    final parsed = await _tryParseAsync(value);
    return AcanthisParseResult(
        value: parsed.values,
        errors: parsed.errors,
        success: _recursiveSuccess(parsed.errors));
  }

  /// Override of [tryParse] from [AcanthisType]
  @override
  AcanthisParseResult<Map<String, V>> tryParse(Map<String, V> value) {
    if (isAsync) {
      throw AsyncValidationException(
          'Cannot use tryParse with async operations');
    }
    final (parsed, errors) = _tryParse(value);
    return AcanthisParseResult(
        value: parsed, errors: errors, success: _recursiveSuccess(errors));
  }

  /// Create a list of maps
  AcanthisList<Map<String, V>> list() {
    return AcanthisList<Map<String, V>>(this);
  }

  /// Add a field dependency to the map to validate the map based on the [condition]
  /// [dependency] is the field that depends on [dependFrom]
  AcanthisMap<V> addFieldDependency({
    required String dependent,
    required String dependendsOn,
    required bool Function(dynamic, dynamic) dependency,
  }) {
    return AcanthisMap<V>._(
      fields: _fields,
      passthrough: _passthrough,
      dependencies:
          _dependencies.add(_Dependency(dependent, dependendsOn, dependency)),
      optionalFields: _optionalFields,
      operations: operations,
      isAsync: isAsync,
    );
  }

  bool _recursiveSuccess(Map<String, dynamic> errors) {
    List<bool> results = [];
    for (var error in errors.values) {
      results.add(error is Map<String, dynamic>
          ? _recursiveSuccess(error)
          : error.isEmpty);
    }
    return results.every((element) => element);
  }

  /// Add field(s) to the map
  /// It won't overwrite existing fields
  AcanthisMap<V> extend(Map<String, AcanthisType> fields) {
    final newFields = <String, AcanthisType>{};
    for (var field in fields.keys) {
      if (!_fields.containsKey(field)) {
        newFields[field] = fields[field]!;
      }
    }
    return AcanthisMap<V>._(
      fields: _fields.addAll(newFields.toIMap()),
      passthrough: _passthrough,
      dependencies: _dependencies,
      optionalFields: _optionalFields,
      operations: operations,
      isAsync: isAsync,
    );
  }

  /// Merge field(s) to the map
  /// if a field already exists, it will be overwritten
  AcanthisMap<V> merge(Map<String, AcanthisType> fields) {
    return AcanthisMap<V>._(
      fields: _fields.addAll(fields.toIMap()),
      passthrough: _passthrough,
      dependencies: _dependencies,
      optionalFields: _optionalFields,
      operations: operations,
      isAsync: isAsync,
    );
  }

  /// Pick field(s) from the map
  AcanthisMap<V> pick(Iterable<String> fields) {
    final newFields = <String, AcanthisType>{};
    for (var field in fields) {
      if (_fields.containsKey(field)) {
        newFields[field] = _fields[field]!;
      }
    }
    return AcanthisMap<V>._(
      fields: newFields.toIMap(),
      passthrough: _passthrough,
      dependencies: _dependencies,
      optionalFields: _optionalFields,
      operations: operations,
      isAsync: isAsync,
    );
  }

  /// Omit field(s) from the map
  AcanthisMap<V> omit(Iterable<String> toOmit) {
    final newFields = <String, AcanthisType>{};
    for (var field in _fields.keys) {
      if (!toOmit.contains(field)) {
        newFields[field] = _fields[field]!;
      }
    }
    return AcanthisMap<V>._(
      fields: newFields.toIMap(),
      passthrough: _passthrough,
      dependencies: _dependencies,
      optionalFields: _optionalFields,
      operations: operations,
      isAsync: isAsync,
    );
  }

  /// Allow unknown keys in the map
  AcanthisMap<V> passthrough() {
    return AcanthisMap<V>._(
      fields: _fields,
      passthrough: true,
      dependencies: _dependencies,
      optionalFields: _optionalFields,
      operations: operations,
      isAsync: isAsync,
    );
  }

  AcanthisMap<V?> partial({bool deep = false}) {
    if (deep) {
      return AcanthisMap<V?>(_fields.map((key, value) {
        if (value is AcanthisMap) {
          return MapEntry(key, value.partial(deep: deep));
        }
        if (value is LazyEntry) {
          return MapEntry(key, value.call(this).nullable());
        }
        return MapEntry(key, value.nullable());
      }));
    }
    return AcanthisMap<V?>(
        _fields.map((key, value) => MapEntry(key, value.nullable())));
  }

  @override
  AcanthisMap<V> withAsyncCheck(AcanthisAsyncCheck<Map<String, V>> check) {
    return AcanthisMap<V>._(
      fields: _fields,
      passthrough: _passthrough,
      dependencies: _dependencies,
      optionalFields: _optionalFields,
      operations: operations.add(check),
      isAsync: true,
    );
  }

  @override
  AcanthisMap<V> withCheck(AcanthisCheck<Map<String, V>> check) {
    return AcanthisMap<V>._(
      fields: _fields,
      passthrough: _passthrough,
      dependencies: _dependencies,
      optionalFields: _optionalFields,
      operations: operations.add(check),
      isAsync: isAsync,
    );
  }

  @override
  AcanthisMap<V> withTransformation(
      AcanthisTransformation<Map<String, V>> transformation) {
    return AcanthisMap<V>._(
      fields: _fields,
      passthrough: _passthrough,
      dependencies: _dependencies,
      optionalFields: _optionalFields,
      operations: operations.add(transformation),
      isAsync: isAsync,
    );
  }
}

/// Create a map of [fields]
AcanthisMap object(Map<String, AcanthisType> fields) => AcanthisMap<dynamic>(
      fields.toIMap(),
    );

@immutable
class _Dependency {
  final String dependent;
  final String dependendsOn;
  final bool Function(dynamic, dynamic) dependency;

  const _Dependency(this.dependent, this.dependendsOn, this.dependency);
}

class LazyEntry extends AcanthisType<dynamic> {
  final AcanthisType Function(AcanthisMap parent) _type;

  const LazyEntry(
    this._type, {
    super.operations,
    super.isAsync,
  });

  AcanthisType call(AcanthisMap parent) {
    final type = _type(parent);
    if (type is LazyEntry) {
      throw StateError('Circular dependency detected');
    }
    return type;
  }

  @override
  AcanthisNullable nullable({defaultValue}) {
    throw UnimplementedError('The implementation must be done from the parent');
  }

  @override
  LazyEntry withAsyncCheck(AcanthisAsyncCheck check) {
    return LazyEntry(
      _type,
      operations: operations.add(check),
      isAsync: true,
    );
  }

  @override
  LazyEntry withCheck(AcanthisCheck check) {
    return LazyEntry(
      _type,
      operations: operations.add(check),
    );
  }

  @override
  LazyEntry withTransformation(AcanthisTransformation transformation) {
    return LazyEntry(
      _type,
      operations: operations.add(transformation),
    );
  }
}

LazyEntry lazy(AcanthisType Function(AcanthisMap parent) type) =>
    LazyEntry(type);
