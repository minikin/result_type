import 'dart:math';

import 'package:http/http.dart' as http;

import 'photo.dart';
import 'photos_service.dart';

final client = http.Client();
final random = Random();

void main() async {
  final photosResult = await PhotosService.getPhotos(client);

  final outOfRangeException = await PhotosService.outOfRangeException(client);
  final photosResult2 = await PhotosService.getPhotos(client);
  final nullPointerException = await PhotosService.nullPointerException(client);
  final photosResult3 = await PhotosService.getPhotos(client);

  final photosOr = photosResult.unwrapOr([
    const Photo(
      id: 1,
      title: 'title',
      thumbnailUrl: 'thumbnailUrl',
    )
  ]);

  //print(photosOr);

  /// Use `switch` to handle both success and failure.
  // final _ = switch (result) {
  //   Success(value: final data) => data,
  //   Failure(value: final error) => 'Error: $error'
  // };

  /// Do something with successful operation results or handle an error.
  // if (result.isSuccess) {
  //   print('Photos Items: ${result.success}');
  // } else {
  //   print('Error: ${result.failure}');
  // }

  /// Apply transformation to successful operation results or handle an error.
  // if (result.isSuccess) {
  //   final items = result
  //       .map(
  //         (i) => i.where(
  //           (j) => j.title.length > 60,
  //         ),
  //       )
  //       .success;
  //   print('Number of Long Titles: ${items.length}');
  // } else {
  //   print('Error: ${result.failure}');
  // }

  /// In this example, note the difference in the result of using `map` and
  /// `flatMap` with a transformation that returns an result type.
  // Result<int, Exception> getNextInteger() => Success(random.nextInt(4));
  // Result<int, Exception> getNextAfterInteger(int n) =>
  //     Success(random.nextInt(n + 1));

  // final nextIntegerNestedResults = getNextInteger().map(getNextAfterInteger);
  // print(nextIntegerNestedResults.runtimeType);
  // Prints: Success<Result<int, Error>, dynamic>

  // final nextIntegerUnboxedResults =
  //     getNextInteger().flatMap(getNextAfterInteger);
  // print(nextIntegerUnboxedResults.runtimeType);
  // // Prints: Success<int, Error>

  /// Use completion handler / callback style API if you want to.
//   await PhotosService.getPhotos(client)
//     ..result((photos) {
//       // print('Photos: $photos');
//     }, (error) {
//       print('Error: $error');
//     });
}
