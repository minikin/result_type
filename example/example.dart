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

  // Print the result of the last operation: `Success: Default Data`
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
