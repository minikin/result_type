import 'package:http/http.dart' as http;
import 'package:result_type/result_type.dart';

import 'crasher.dart';
import 'network_error.dart';
import 'photo.dart';

final class PhotosService {
  PhotosService._();

  static final _photosUri = Uri.parse(
    'https://jsonplaceholder.typicode.com/photos',
  );

  static Future<Result<List<Photo>, NetworkError>> getPhotos(
    http.Client client,
  ) async {
    final response = await client.get(_photosUri);

    return _handleResult(response);
  }

  static Future<Result<List<Photo>, NetworkError>> outOfRangeException(
    http.Client client,
  ) async {
    final response = await client.get(_photosUri);

    Crasher.outOfRange();

    return _handleResult(response);
  }

  static Future<Result<List<Photo>, NetworkError>> nullPointerException(
    http.Client client,
  ) async {
    final response = await client.get(_photosUri);

    Crasher.nullPointerException();

    return _handleResult(response);
  }

  static Result<List<Photo>, NetworkError> _handleResult(
    http.Response response,
  ) {
    switch (response.statusCode) {
      case 200:
        return Success(PhotoExtension.parsePhotos(response.body));
      case 400:
        return Failure(BadRequest(stackTrace: StackTrace.current));
      case 404:
        return Failure(NotFound(stackTrace: StackTrace.current));
      default:
        return Failure(UnsupportedError(stackTrace: StackTrace.current));
    }
  }
}
