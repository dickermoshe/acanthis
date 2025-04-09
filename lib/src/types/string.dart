// Numeric transformations
import 'dart:convert' as convert;
import 'package:acanthis/acanthis.dart';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:email_validator/email_validator.dart';

/// A class to validate string types
class AcanthisString extends AcanthisType<String> {
  const AcanthisString({super.isAsync, super.operations});

  /// Add a check to the string to check if it is a valid email
  AcanthisString email() {
    return withCheck(StringChecks.email);
  }

  /// Add a check to the string to check if its length is at least [length]
  AcanthisString min(int length) {
    return withCheck(StringChecks.min(length));
  }

  /// Add a check to the string to check if its length is at most [length]
  AcanthisString max(int length) {
    return withCheck(StringChecks.max(length));
  }

  /// Add a check to the string to check if follows the pattern [pattern]
  AcanthisString pattern(RegExp pattern) {
    return withCheck(StringChecks.pattern(pattern));
  }

  /// Add a check to the string to check if it contains letters
  AcanthisString letters({bool strict = true}) {
    return withCheck(switch (strict) {
      true => StringChecks.strictLetters,
      false => StringChecks.letters,
    });
  }

  /// Add a check to the string to check if it contains digits
  AcanthisString digits({bool strict = true}) {
    return withCheck(switch (strict) {
      true => StringChecks.strictDigits,
      false => StringChecks.digits
    });
  }

  /// Add a check to the string to check if it contains alphanumeric characters
  AcanthisString alphanumeric({bool strict = true}) {
    return withCheck(switch (strict) {
      true => StringChecks.strictAlphanumeric,
      false => StringChecks.alphanumeric
    });
  }

  /// Add a check to the string to check if it contains alphanumeric characters and spaces
  AcanthisString alphanumericWithSpaces({bool strict = true}) {
    return withCheck(switch (strict) {
      true => StringChecks.strictAlphanumericWithSpaces,
      false => StringChecks.alphanumericWithSpaces,
    });
  }

  /// Add a check to the string to check if it contains special characters
  AcanthisString specialCharacters({bool strict = true}) {
    return withCheck(switch (strict) {
      true => StringChecks.strictSpecialCharacters,
      false => StringChecks.specialCharacters
    });
  }

  /// Add a check to the string to check if it contains all characters
  AcanthisString allCharacters({bool strict = true}) {
    return withCheck(switch (strict) {
      true => StringChecks.strictAllCharacters,
      false => StringChecks.allCharacters
    });
  }

  /// Add a check to the string to check if it is in uppercase
  AcanthisString upperCase() {
    return withCheck(StringChecks.upperCase);
  }

  /// Add a check to the string to check if it is in lowercase
  AcanthisString lowerCase() {
    return withCheck(StringChecks.lowerCase);
  }

  /// Add a check to the string to check if it is in mixed case
  AcanthisString mixedCase() {
    return withCheck(StringChecks.mixedCase);
  }

  /// Add a check to the string to check if it is a valid date time
  AcanthisString dateTime() {
    return withCheck(StringChecks.dateTime);
  }

  AcanthisString time() {
    return withCheck(StringChecks.time);
  }

  AcanthisString hexColor() {
    return withCheck(StringChecks.hexColor);
  }

  /// Add a check to the string to check if it is a valid uri
  AcanthisString uri() {
    return withCheck(StringChecks.uri);
  }

  AcanthisString url() {
    return withCheck(StringChecks.url);
  }

  AcanthisString uncompromised() {
    return withAsyncCheck(StringChecks.uncompromised);
  }

  /// Add a check to the string to check if it is not empty
  AcanthisString required() {
    return withCheck(StringChecks.required);
  }

  /// Add a check to the string to check if it's length is exactly [length]
  AcanthisString length(int length) {
    return withCheck(StringChecks.length(length));
  }

  /// Add a check to the string to check if it contains [value]
  AcanthisString contains(String value) {
    return withCheck(StringChecks.contains(value));
  }

  /// Add a check to the string to check if it starts with [value]
  AcanthisString startsWith(String value) {
    return withCheck(StringChecks.startsWith(value));
  }

  /// Add a check to the string to check if it ends with [value]
  AcanthisString endsWith(String value) {
    return withCheck(StringChecks.endsWith(value));
  }

  AcanthisString card() {
    return withCheck(StringChecks.card);
  }

  AcanthisString cuid() {
    return withCheck(StringChecks.cuid);
  }

  AcanthisString cuid2() {
    return withCheck(StringChecks.cuid2);
  }

  AcanthisString ulid() {
    return withCheck(StringChecks.ulid);
  }

  AcanthisString uuid() {
    return withCheck(StringChecks.uuid);
  }

  AcanthisString nanoid() {
    return withCheck(StringChecks.nanoid);
  }

  AcanthisString jwt() {
    return withCheck(StringChecks.jwt);
  }

  AcanthisString base64() {
    return withCheck(StringChecks.base64);
  }

  /// Create a list of strings
  AcanthisList<String> list() {
    return AcanthisList<String>(this);
  }

  /// Add a transformation to the string to encode it to base64
  AcanthisString encode() {
    return withTransformation(StringTransforms.base64Encode);
  }

  /// Add a transformation to the string to decode it from base64
  AcanthisString decode() {
    return withTransformation(StringTransforms.base64Decode);
  }

  /// Add a transformation to the string to transform it to uppercase
  AcanthisString toUpperCase() {
    return withTransformation(StringTransforms.toUpperCase);
  }

  /// Add a transformation to the string to transform it to lowercase
  AcanthisString toLowerCase() {
    return withTransformation(StringTransforms.toLowerCase);
  }

  /// Create a union from the string
  AcanthisUnion or(List<AcanthisType> elements) {
    return AcanthisUnion([this, ...elements]);
  }

  // AcanthisDate date() {
  //   addTransformation(AcanthisTransformation(transformation: (value) => DateTime.parse(value)));
  //   return AcanthisDate();
  // }

  @override
  AcanthisString withAsyncCheck(BaseAcanthisAsyncCheck<String> check) {
    return AcanthisString(operations: operations.add(check), isAsync: true);
  }

  @override
  AcanthisString withCheck(BaseAcanthisCheck<String> check) {
    return AcanthisString(operations: operations.add(check));
  }

  @override
  AcanthisString withTransformation(
      BaseAcanthisTransformation<String> transformation) {
    return AcanthisString(operations: operations.add(transformation));
  }
}

/// Create a new AcanthisString instance
AcanthisString string() => AcanthisString();

// Checks for Strings

const _lettersStrict = r'^[a-zA-Z]+$';
const _digitsStrict = r'^[0-9]+$';
const _alphanumericStrict = r'^[a-zA-Z0-9]+$';
const _alphanumericWithSpacesStrict = r'^[a-zA-Z0-9 ]+$';
const _specialCharactersStrict = r'^[!@#\$%^&*(),.?":{}|<>]+$';
const _allCharactersStrict =
    r'^[a-zA-Z0-9!@#\$%^&*(),.?":{}\(\)\[\];_\-\?\!\£\|<> ]+$';
const _letters = r'[a-zA-Z]+';
const _digits = r'[0-9]+';
const _alphanumeric = r'[a-zA-Z0-9]+';
const _alphanumericWithSpaces = r'[a-zA-Z0-9 ]+';
const _specialCharacters = r'[!@#\$%^&*(),.?":{}|<>]+';
const _allCharacters = r'[a-zA-Z0-9!@#\$%^&*(),.?":{}\(\)\[\];_\-\?\!\£\|<> ]+';
const _cuidRegex = r'^c[^\s-]{8,}$';
const _cuid2Regex = r'^[0-9a-z]+$';
const _ulidRegex = r'^[0-9A-HJKMNP-TV-Z]{26}$';
// const uuidRegex =
//   /^([a-f0-9]{8}-[a-f0-9]{4}-[1-5][a-f0-9]{3}-[a-f0-9]{4}-[a-f0-9]{12}|00000000-0000-0000-0000-000000000000)$/i;
const _uuidRegex =
    r'^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$';
const _nanoidRegex = r'^[a-z0-9_-]{21}$';
const _jwtRegex = r'^[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+\.[A-Za-z0-9-_]*$';
const _base64Regex =
    r'^([0-9a-zA-Z+/]{4})*(([0-9a-zA-Z+/]{2}==)|([0-9a-zA-Z+/]{3}=))?$';
const _timeRegex = r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9](?::([0-5]\d))?$';

abstract class StringChecks extends BaseAcanthisCheck<String> {
  const StringChecks({
    required super.name,
  });

  static const email = _EmailCheck();
  const factory StringChecks.min(int length) = _MinCheck;
  const factory StringChecks.max(int length) = _MaxCheck;
  const factory StringChecks.pattern(RegExp pattern) = _PatternCheck;
  static const letters = _LettersCheck();
  static const strictLetters = _StrictLettersCheck();
  static const digits = _DigitsCheck();
  static const strictDigits = _StrictDigitsCheck();
  static const alphanumeric = _AlphanumericCheck();
  static const strictAlphanumeric = _StrictAlphanumericCheck();
  static const alphanumericWithSpaces = _AlphanumericWithSpacesCheck();
  static const strictAlphanumericWithSpaces =
      _StrictAlphanumericWithSpacesCheck();
  static const specialCharacters = _SpecialCharactersCheck();
  static const strictSpecialCharacters = _StrictSpecialCharactersCheck();
  static const allCharacters = _AllCharactersCheck();
  static const strictAllCharacters = _StrictAllCharactersCheck();
  static const upperCase = _UppercaseCheck();
  static const lowerCase = _LowercaseCheck();
  static const mixedCase = _MixedcaseCheck();
  static const dateTime = _DatetimeCheck();
  static const time = _TimeCheck();
  static const uri = _UriCheck();
  static const required = _RequiredCheck();
  const factory StringChecks.length(int length) = _LengthCheck;
  const factory StringChecks.contains(String value) = _ContainsCheck;
  const factory StringChecks.startsWith(String value) = _StartswithCheck;
  const factory StringChecks.endsWith(String value) = _EndswithCheck;
  static const cuid = _CuidCheck();
  static const cuid2 = _Cuid2Check();
  static const ulid = _UlidCheck();
  static const uuid = _UuidCheck();
  static const nanoid = _NanoidCheck();
  static const jwt = _JwtCheck();
  static const base64 = _Base64Check();
  static const hexColor = _HexCodeCheck();
  static const url = _UrlCheck();
  static const card = _CardCheck();
  static const uncompromised = _UncompromisedCheck();
}

class _EmailCheck extends StringChecks {
  const _EmailCheck()
      : super(
          name: 'email',
        );

  @override
  bool onCheck(String toTest) => EmailValidator.validate(toTest);

  @override
  String get error => 'Invalid email format';
}

class _MinCheck extends StringChecks {
  final int length;
  const _MinCheck(this.length)
      : super(
          name: 'min',
        );

  @override
  bool onCheck(String toTest) => toTest.length >= length;
  @override
  String get error => 'Value must be at least $length characters long';
}

class _MaxCheck extends StringChecks {
  final int length;

  const _MaxCheck(
    this.length,
  ) : super(
          name: 'maxLength',
        );

  @override
  bool onCheck(String toTest) => toTest.length <= length;
  @override
  String get error => 'Value must be at most $length characters long';
}

class _PatternCheck extends StringChecks {
  final RegExp pattern;
  const _PatternCheck(
    this.pattern,
  ) : super(
          name: 'pattern',
        );

  @override
  bool onCheck(String toTest) => pattern.hasMatch(toTest);
  @override
  String get error => 'Value does not match the pattern $pattern';
}

class _LettersCheck extends StringChecks {
  const _LettersCheck()
      : super(
          name: 'letters',
        );

  @override
  bool onCheck(String toTest) => RegExp(_letters).hasMatch(toTest);

  @override
  String get error => 'Value must contain letters';
}

class _StrictLettersCheck extends StringChecks {
  const _StrictLettersCheck()
      : super(
          name: 'letters',
        );

  @override
  bool onCheck(String toTest) => RegExp(_lettersStrict).hasMatch(toTest);
  @override
  String get error => 'Value must contain only letters';
}

class _DigitsCheck extends StringChecks {
  const _DigitsCheck()
      : super(
          name: 'digits',
        );

  @override
  bool onCheck(String toTest) => RegExp(_digits).hasMatch(toTest);
  @override
  String get error => 'Value must contain digits';
}

class _StrictDigitsCheck extends StringChecks {
  const _StrictDigitsCheck()
      : super(
          name: 'digits',
        );

  @override
  bool onCheck(String toTest) => RegExp(_digitsStrict).hasMatch(toTest);

  @override
  String get error => 'Value must contain only digits';
}

class _AlphanumericCheck extends StringChecks {
  const _AlphanumericCheck()
      : super(
          name: 'alphanumeric',
        );

  @override
  bool onCheck(String toTest) => RegExp(_alphanumeric).hasMatch(toTest);

  @override
  String get error => 'Value must contain alphanumeric characters';
}

class _StrictAlphanumericCheck extends StringChecks {
  const _StrictAlphanumericCheck()
      : super(
          name: 'alphanumeric',
        );

  @override
  bool onCheck(String toTest) => RegExp(_alphanumericStrict).hasMatch(toTest);

  @override
  String get error => 'Value must contain only alphanumeric characters';
}

class _AlphanumericWithSpacesCheck extends StringChecks {
  const _AlphanumericWithSpacesCheck()
      : super(
          name: 'alphanumericWithSpaces',
        );

  @override
  bool onCheck(String toTest) =>
      RegExp(_alphanumericWithSpaces).hasMatch(toTest);

  @override
  String get error => 'Value must contain alphanumeric or spaces characters';
}

class _StrictAlphanumericWithSpacesCheck extends StringChecks {
  const _StrictAlphanumericWithSpacesCheck()
      : super(
          name: 'alphanumericWithSpaces',
        );

  @override
  bool onCheck(String toTest) =>
      RegExp(_alphanumericWithSpacesStrict).hasMatch(toTest);

  @override
  String get error =>
      'Value must contain only alphanumeric or spaces characters';
}

class _SpecialCharactersCheck extends StringChecks {
  const _SpecialCharactersCheck()
      : super(
          name: 'specialCharacters',
        );

  @override
  bool onCheck(String toTest) => RegExp(_specialCharacters).hasMatch(toTest);
  @override
  String get error => 'Value must contain special characters';
}

class _StrictSpecialCharactersCheck extends StringChecks {
  const _StrictSpecialCharactersCheck()
      : super(
          name: 'specialCharacters',
        );

  @override
  bool onCheck(String toTest) =>
      RegExp(_specialCharactersStrict).hasMatch(toTest);
  @override
  String get error => 'Value must contain only special characters';
}

class _AllCharactersCheck extends StringChecks {
  const _AllCharactersCheck()
      : super(
          name: 'allCharacters',
        );

  @override
  bool onCheck(String toTest) => RegExp(_allCharacters).hasMatch(toTest);
  @override
  String get error => 'Value must contain characters';
}

class _StrictAllCharactersCheck extends StringChecks {
  const _StrictAllCharactersCheck()
      : super(
          name: 'allCharacters',
        );

  @override
  bool onCheck(String toTest) => RegExp(_allCharactersStrict).hasMatch(toTest);
  @override
  String get error => 'Value must contain only characters';
}

class _UppercaseCheck extends StringChecks {
  const _UppercaseCheck()
      : super(
          name: 'upperCase',
        );

  @override
  bool onCheck(String toTest) => toTest == toTest.toUpperCase();
  @override
  String get error => 'Value must be uppercase';
}

class _LowercaseCheck extends StringChecks {
  const _LowercaseCheck()
      : super(
          name: 'lowerCase',
        );

  @override
  bool onCheck(String toTest) => toTest == toTest.toLowerCase();
  @override
  String get error => 'Value must be lowercase';
}

class _MixedcaseCheck extends StringChecks {
  const _MixedcaseCheck()
      : super(
          name: 'mixedCase',
        );

  @override
  bool onCheck(String toTest) =>
      toTest != toTest.toUpperCase() && toTest != toTest.toLowerCase();
  @override
  String get error => 'Value must be mixed case';
}

class _DatetimeCheck extends StringChecks {
  const _DatetimeCheck()
      : super(
          name: 'dateTime',
        );

  @override
  bool onCheck(String toTest) => DateTime.tryParse(toTest) != null;
  @override
  String get error => 'Value must be a valid date time';
}

class _TimeCheck extends StringChecks {
  const _TimeCheck()
      : super(
          name: 'time',
        );

  @override
  bool onCheck(String toTest) => (RegExp(_timeRegex)).hasMatch(toTest);
  @override
  String get error => 'Value must be a valid time format';
}

class _UriCheck extends StringChecks {
  const _UriCheck()
      : super(
          name: 'uri',
        );

  @override
  bool onCheck(String toTest) => Uri.tryParse(toTest) != null;
  @override
  String get error => 'Value must be a valid uri';
}

class _RequiredCheck extends StringChecks {
  const _RequiredCheck()
      : super(
          name: 'required',
        );

  @override
  bool onCheck(String toTest) => toTest.isNotEmpty;
  @override
  String get error => 'Value is required';
}

class _LengthCheck extends StringChecks {
  final int length;
  const _LengthCheck(
    this.length,
  ) : super(
          name: 'length',
        );

  @override
  bool onCheck(String toTest) => toTest.length == length;
  @override
  String get error => 'Value must be $length characters long';
}

class _ContainsCheck extends StringChecks {
  final String value;
  const _ContainsCheck(
    this.value,
  ) : super(
          name: 'contains',
        );

  @override
  bool onCheck(String toTest) => toTest.contains(value);
  @override
  String get error => 'Value must contain $value';
}

class _StartswithCheck extends StringChecks {
  final String value;
  const _StartswithCheck(
    this.value,
  ) : super(
          name: 'startsWith',
        );

  @override
  bool onCheck(String toTest) => toTest.startsWith(value);
  @override
  String get error => 'Value must start with $value';
}

class _EndswithCheck extends StringChecks {
  final String value;
  const _EndswithCheck(
    this.value,
  ) : super(
          name: 'endsWith',
        );

  @override
  bool onCheck(String toTest) => toTest.endsWith(value);
  @override
  String get error => 'Value must end with $value';
}

class _CuidCheck extends StringChecks {
  const _CuidCheck()
      : super(
          name: 'cuid',
        );

  @override
  bool onCheck(String toTest) =>
      RegExp(_cuidRegex, caseSensitive: false).hasMatch(toTest);
  @override
  String get error => 'Value must be a valid cuid';
}

class _Cuid2Check extends StringChecks {
  const _Cuid2Check()
      : super(
          name: 'cuid2',
        );

  @override
  bool onCheck(String toTest) =>
      RegExp(_cuid2Regex, caseSensitive: false).hasMatch(toTest);

  @override
  String get error => 'Value must be a valid cuid2';
}

class _UlidCheck extends StringChecks {
  const _UlidCheck()
      : super(
          name: 'ulid',
        );

  @override
  bool onCheck(String toTest) =>
      RegExp(_ulidRegex, caseSensitive: false).hasMatch(toTest);
  @override
  String get error => 'Value must be a valid ulid';
}

class _UuidCheck extends StringChecks {
  const _UuidCheck()
      : super(
          name: 'uuid',
        );

  @override
  bool onCheck(String toTest) =>
      RegExp(_uuidRegex, caseSensitive: false).hasMatch(toTest);
  @override
  String get error => 'Value must be a valid uuid';
}

class _NanoidCheck extends StringChecks {
  const _NanoidCheck()
      : super(
          name: 'nanoid',
        );

  @override
  bool onCheck(String toTest) =>
      RegExp(_nanoidRegex, caseSensitive: false).hasMatch(toTest);
  @override
  String get error => 'Value must be a valid nanoid';
}

class _JwtCheck extends StringChecks {
  const _JwtCheck()
      : super(
          name: 'jwt',
        );

  @override
  bool onCheck(String toTest) =>
      RegExp(_jwtRegex, caseSensitive: false).hasMatch(toTest);
  @override
  String get error => 'Value must be a valid jwt';
}

class _Base64Check extends StringChecks {
  const _Base64Check()
      : super(
          name: 'base64',
        );

  @override
  bool onCheck(String toTest) =>
      RegExp(_base64Regex, caseSensitive: false).hasMatch(toTest);
  @override
  String get error => 'Value must be a valid base64';
}

class _HexCodeCheck extends StringChecks {
  const _HexCodeCheck()
      : super(
          name: 'hexCode',
        );

  @override
  bool onCheck(String toTest) {
    if (toTest.length != 7) return false;
    if (toTest[0] != '#') return false;
    return RegExp(r'^[0-9a-fA-F]+$').hasMatch(toTest.substring(1));
  }

  @override
  String get error => 'Value must be a valid hex code';
}

class _UrlCheck extends StringChecks {
  const _UrlCheck()
      : super(
          name: 'url',
        );

  @override
  bool onCheck(String toTest) {
    if (toTest.isEmpty) return false;
    final uriValue = Uri.tryParse(toTest);
    if (uriValue == null) return false;
    return uriValue.hasScheme && uriValue.host.isNotEmpty;
  }

  @override
  String get error => 'Value must be a valid url';
}

class _CardCheck extends StringChecks {
  const _CardCheck()
      : super(
          name: 'card',
        );

  @override
  String get error => 'Value must be a valid card number';

  @override
  bool onCheck(String toTest) {
    final sanitized = toTest.replaceAll(RegExp(r'\D'), '');
    if (sanitized.length < 13 || sanitized.length > 19) return false;
    if (!RegExp(r'^\d+$').hasMatch(sanitized)) return false;
    return _isValidLuhn(sanitized);
  }

  bool _isValidLuhn(String number) {
    int sum = 0;
    bool alternate = false;
    for (int i = number.length - 1; i >= 0; i--) {
      int digit = int.parse(number[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }

      sum += digit;
      alternate = !alternate;
    }
    return sum % 10 == 0;
  }
}

class _UncompromisedCheck extends BaseAcanthisAsyncCheck<String> {
  const _UncompromisedCheck()
      : super(
          name: 'uncompromised',
        );

  @override
  Future<bool> onCheck(toTest) async {
    final bytes = convert.utf8.encode(toTest);
    final sha = sha1.convert(bytes);
    final hexString = sha.toString().toUpperCase();
    final client = HttpClient();
    final request = await client.getUrl(
      Uri.parse(
          'https://api.pwnedpasswords.com/range/${hexString.substring(0, 5)}'),
    );
    final response = await request.close();
    final body = await response.transform(convert.utf8.decoder).join();
    final lines = body.split('\n');
    return !lines.any((element) => element.startsWith(hexString.substring(5)));
  }

  @override
  String get error => 'Value is compromised';
}

/// Numeric transformations

/// String transformations
abstract class StringTransforms extends BaseAcanthisTransformation<String> {
  const StringTransforms();

  static const base64Encode = _StringBase64EncodeTransformation();
  static const base64Decode = _StringBase64DecodeTransformation();
  static const toUpperCase = _StringToUpperCaseTransformation();
  static const toLowerCase = _StringToLowerCaseTransformation();
  static const trim = _StringTrimTransformation();
}

class _StringBase64EncodeTransformation extends StringTransforms {
  const _StringBase64EncodeTransformation();

  @override
  String transformation(String toTransform) =>
      convert.base64.encode(toTransform.codeUnits);
}

class _StringBase64DecodeTransformation extends StringTransforms {
  const _StringBase64DecodeTransformation();

  @override
  String transformation(String toTransform) =>
      String.fromCharCodes(convert.base64.decode(toTransform));
}

class _StringToUpperCaseTransformation extends StringTransforms {
  const _StringToUpperCaseTransformation();

  @override
  String transformation(String toTransform) => toTransform.toUpperCase();
}

class _StringToLowerCaseTransformation extends StringTransforms {
  const _StringToLowerCaseTransformation();

  @override
  String transformation(String toTransform) => toTransform.toLowerCase();
}

class _StringTrimTransformation extends StringTransforms {
  const _StringTrimTransformation();

  @override
  String transformation(String toTransform) => toTransform.trim();
}
