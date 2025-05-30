# Number

The number method is used to validate a number.

You can also use the class `AcanthisNumber` to create a number schema.

## Example

```dart
import 'package:acanthis/acanthis.dart';

void main() {
  final age = number().positive();

  final result = age.tryParse(24);

  if (result.success) {
    print('The schema is valid!');
  } else {
    print('The schema is invalid!');
  }
}
```

::: tip
The AcanthisParseResult object, that is returned by the `parse` and `tryParse` method is described [here](/introduction.html#acanthisparseresult).
:::

## Methods

### positive

The positive method is used to validate a positive number.

```dart

import 'package:acanthis/acanthis.dart';

void main() {
  final age = number().positive();

  final result = age.tryParse(24);

  if (result.success) {
    print('The schema is valid!');
  } else {
    print('The schema is invalid!');
  }
}
```

### negative

The negative method is used to validate a negative number.

```dart

import 'package:acanthis/acanthis.dart';

void main() {
  final age = number().negative();

  final result = age.tryParse(-24);

  if (result.success) {
    print('The schema is valid!');
  } else {
    print('The schema is invalid!');
  }
}
```

### integer

The integer method is used to validate an integer.

```dart

import 'package:acanthis/acanthis.dart';

void main() {
  final age = number().integer();

  final result = age.tryParse(24);

  if (result.success) {
    print('The schema is valid!');
  } else {
    print('The schema is invalid!');
  }
}
```

### double

The double method is used to validate a double.

```dart
import 'package:acanthis/acanthis.dart';

void main() {
  final age = number().double();

  final result = age.tryParse(24.5);

  if (result.success) {
  print('The schema is valid!');
  } else {
  print('The schema is invalid!');
  }
}
```

### gte

The gte method is used to validate that a number is greater than or equal to a value.

```dart

import 'package:acanthis/acanthis.dart';

void main() {
  final age = number().gte(18);

  final result = age.tryParse(24);

  if (result.success) {
    print('The schema is valid!');
  } else {
    print('The schema is invalid!');
  }
}
```

### gt

The gt method is used to validate that a number is greater than a value.

```dart

import 'package:acanthis/acanthis.dart';

void main() {
  final age = number().gt(18);

  final result = age.tryParse(24);

  if (result.success) {
    print('The schema is valid!');
  } else {
    print('The schema is invalid!');
  }
}
```

### lte

The lte method is used to validate that a number is less than or equal to a value.

```dart

import 'package:acanthis/acanthis.dart';

void main() {
  final age = number().lte(18);

  final result = age.tryParse(24);

  if (result.success) {
    print('The schema is valid!');
  } else {
    print('The schema is invalid!');
  }
}
```

### lt

The lt method is used to validate that a number is less than a value.

```dart

import 'package:acanthis/acanthis.dart';

void main() {
  final age = number().lt(18);

  final result = age.tryParse(24);

  if (result.success) {
    print('The schema is valid!');
  } else {
    print('The schema is invalid!');
  }
}
```

### between

The between method is used to validate that a number is between two values.

```dart
import 'package:acanthis/acanthis.dart';

void main() {
  final age = number().between(18, 30);

  final result = age.tryParse(24);

  if (result.success) {
    print('The schema is valid!');
  } else {
    print('The schema is invalid!');
  }
}
```

### multipleOf

The multipleOf method is used to validate that a number is a multiple of a value.

```dart

import 'package:acanthis/acanthis.dart';

void main() {
  final age = number().multipleOf(2);

  final result = age.tryParse(24);

  if (result.success) {
    print('The schema is valid!');
  } else {
    print('The schema is invalid!');
  }
}
```

### finite

The finite method is used to validate that a number is finite.

```dart

import 'package:acanthis/acanthis.dart';

void main() {
  final age = number().finite();

  final result = age.tryParse(24);

  if (result.success) {
    print('The schema is valid!');
  } else {
    print('The schema is invalid!');
  }
}
```

### infinite

The infinite method is used to validate that a number is infinite.

```dart

import 'package:acanthis/acanthis.dart';

void main() {
  final age = number().infinite();

  final result = age.tryParse(double.infinity);

  if (result.success) {
    print('The schema is valid!');
  } else {
    print('The schema is invalid!');
  }
}
```

### nan

The nan method is used to validate that a number is NaN.

```dart

import 'package:acanthis/acanthis.dart';

void main() {
  final age = number().nan();

  final result = age.tryParse(double.nan);

  if (result.success) {
    print('The schema is valid!');
  } else {
    print('The schema is invalid!');
  }
}
```

### notNaN

The notNaN method is used to validate that a number is not NaN.

```dart

import 'package:acanthis/acanthis.dart';

void main() {
  final age = number().notNaN();

  final result = age.tryParse(24);

  if (result.success) {
    print('The schema is valid!');
  } else {
    print('The schema is invalid!');
  }
}
```

### list

The list method is used to validate a list of `num` objects.

For the list validations methods, you check the [List](/types/list) page.

```dart

import 'package:acanthis/acanthis.dart';

void main() {
  final numbers = number().list();

  final result = numbers.tryParse([24, 255]);

  if (result.success) {
    print('The schema is valid!');
  } else {
    print('The schema is invalid!');
  }
}
```
