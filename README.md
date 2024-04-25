<h1 align="center">Result Type for Dart</h1>

<p align="center">
    <a href="https://github.com/minikin/result_type/actions">
    <img src="https://github.com/minikin/result_type/actions/workflows/build.yml/badge.svg" alt="CI Status" />
  </a>

  <a href="https://codecov.io/gh/minikin/result_type">
    <img src="https://codecov.io/gh/minikin/result_type/branch/main/graph/badge.svg?token=dpljQutAnj"/>
  </a>

   <a href="https://github.com/minikin/result_type/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="Result Type is released under the MIT license." />
  </a>

  <a href="https://github.com/minikin/result_type/blob/main/CODE_OF_CONDUCT.md">
    <img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg" alt="PRs welcome!" />
  </a>
</p>

# Content

- [Content](#content)
  - [Features](#features)
  - [Requirements](#requirements)
  - [Install](#install)
  - [Example](#example)
  - [Support](#support)
  - [License](#license)

## Features

Result is a type that represents either [Success](https://github.com/minikin/result_type/blob/main/lib/src/success.dart) or [Failure](https://github.com/minikin/result_type/blob/main/lib/src/failure.dart).

Inspired by [functional programming](https://hackage.haskell.org/package/base-4.12.0.0/docs/Data-Either.html), [Rust](https://doc.rust-lang.org/std/result/enum.Result.html) and [Swift](https://developer.apple.com/documentation/swift/result).

## Requirements

- Dart: 3.3.0+

## Install

```yaml
dependencies:
  result_type: ^1.0.0
```

## Example

The detailed example can be found at [result_type/example/example.dart](https://github.com/minikin/result_type/blob/main/example/example.dart).

```dart
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:result_type/src/result.dart';

import 'imaginary_service.dart';
import 'photo.dart';
import 'photos_service.dart';

final client = http.Client();
final random = Random();

void main() async {
  final photosResult = await PhotosService.getPhotos(client);

  final photosOr = photosResult.unwrapOr([Photo.initial()]);

  print(photosOr);

  /// Use `switch` to handle both success and failure.
  final _ = switch (photosResult) {
    Success(value: final data) => data,
    Failure(value: final error) => 'Error: $error'
  };

  /// Do something with successful operation results or handle an error.
  if (photosResult.isSuccess) {
    print('Photos Items: ${photosResult.success}');
  } else {
    print('Error: ${photosResult.failure}');
  }

  // Chain multiple asynchronous operations.
  final result1 = await ImaginaryService.fetchData1();
  final result2 = await ImaginaryService.fetchData2(result1.success);
  final result3 = await ImaginaryService.fetchData2(result2.success);

  // Print the result of the last operation: `Default Data`
  print(result3.unwrapOr('Default Data'));

  // This will throw an exception as `_handleResult`
  // has a case with 'Wrong Data'.
  //print(result3.unwrap());

  String length(String string) => string.length.toString();

  final one = result3.unwrapOrElse('Default (((((Data)))))', length);
  // Print the result of the last operation: `22`
  print(one);

  /// Apply transformation to successful operation results or handle an error.
  if (photosResult.isSuccess) {
    final items = photosResult
        .map(
          (i) => i.where(
            (j) => j.title.length > 60,
          ),
        )
        .success;
    print('Number of Long Titles: ${items.length}');
  } else {
    print('Error: ${photosResult.failure}');
  }

  /// In this example, note the difference in the result of using `map` and
  /// `flatMap` with a transformation that returns an result type.
  Result<int, Exception> getNextInteger() => Success(random.nextInt(4));
  Result<int, Exception> getNextAfterInteger(int n) =>
      Success(random.nextInt(n + 1));

  final nextIntegerNestedResults = getNextInteger().map(getNextAfterInteger);
  print(nextIntegerNestedResults.runtimeType);
  // Prints: Success<Result<int, Error>, dynamic>

  final nextIntegerUnboxedResults =
      getNextInteger().flatMap(getNextAfterInteger);
  print(nextIntegerUnboxedResults.runtimeType);
  // Prints: Success<int, Error>

  /// Use completion handler / callback style API if you want to.
  await PhotosService.getPhotos(client)
    ..result((photos) {
      // print('Photos: $photos');
    }, (error) {
      print('Error: $error');
    });
}
```

To see examples of the following package in action:

```sh
cd example && dart run
```

## Support

Post issues and feature requests on the GitHub [issue tracker](https://github.com/minikin/result_type/issues).

## License

The source code is distributed under the MIT license.
See the [LICENSE](https://github.com/minikin/result_type/blob/main/LICENSE) file for more info.
