import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:result_type/result_type.dart';

void main() async {
  final random = Random();
  final client = http.Client();
  final result = await getPhotos(client);

  /// Do something with successful operation results or handle an error.
  if (result.isSuccess) {
    print('Photos Items: ${result.success}');
  } else {
    print('Error: ${result.failure}');
  }

  /// Apply transformation to successful operation results or handle an error.
  if (result.isSuccess) {
    final items = result
        .map<Iterable<Photo>, NetworkError>(
            (i) => i.where((j) => j.title.length > 60))
        .success;
    print('Number of Long Titles: ${items.length}');
  } else {
    print('Error: ${result.failure}');
  }

  /// In this example, note the difference in the result of using `map` and
  /// `flatMap` with a transformation that returns an result type.
  Result<int, Error> getNextInteger() => Success(random.nextInt(4));
  Result<int, Error> getNextAfterInteger(int n) =>
      Success(random.nextInt(n + 1));

  final nextIntegerNestedResults =
      getNextInteger().map<Result<int, Error>, dynamic>(getNextAfterInteger);
  print(nextIntegerNestedResults.runtimeType);
  // Prints: Success<Result<int, Error>, dynamic>

  final nextIntegerUnboxedResults =
      getNextInteger().flatMap(getNextAfterInteger);
  print(nextIntegerUnboxedResults.runtimeType);
  // Prints: Success<int, Error>

  /// Use completion handler / callback style API if you want to.
  await getPhotos(client)
    ..result((photos) {
      print('Photos: $photos');
    }, (error) {
      print('Error: $error');
    });
}

class Photo {
  final int id;
  final String title;
  final String thumbnailUrl;

  const Photo({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
  });

  factory Photo.fromJson(Map<String, Object> json) {
    return Photo(
      id: json['id'] as int,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }

  @override
  String toString() =>
      'Photo(id: $id, title: $title, thumbnailUrl: $thumbnailUrl)';
}

extension PhotoExtension on Photo {
  static List<Photo> parsePhotos(String responseBody) {
    final jsonObject = jsonDecode(responseBody) as Iterable;
    return jsonObject
        .map<Photo>((json) => Photo.fromJson(Map<String, Object>.from(json)))
        .toList();
  }
}

enum NetworkError implements Comparable<NetworkError> {
  badRequest(400, 'Bad request'),
  notFound(404, 'Not found');

  final int code;
  final String description;

  const NetworkError(this.code, this.description);

  @override
  String toString() => 'NetworkError(code: $code, description: $description)';

  @override
  int compareTo(NetworkError other) => code - other.code;
}

Future<Result<List<Photo>, NetworkError>> getPhotos(http.Client client) async {
  const path = 'https://jsonplaceholder.typicode.com/photos';
  try {
    final jsonString = await client.get(Uri.parse(path));
    return Success(PhotoExtension.parsePhotos(jsonString.body));
  } on NetworkError catch (error) {
    switch (error) {
      case NetworkError.badRequest:
        return Failure(NetworkError.notFound);
      default:
        return Failure(NetworkError.badRequest);
    }
  }
}
