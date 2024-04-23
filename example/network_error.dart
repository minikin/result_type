sealed class NetworkError implements Comparable<NetworkError>, Exception {
  final int code;
  final String description;

  NetworkError({
    required this.code,
    required this.description,
  });
}

final class BadRequest implements NetworkError {
  final int code = 400;
  final String description = 'Bad request';

  BadRequest();

  @override
  String toString() => 'NetworkError(code: $code, description: $description)';

  @override
  int compareTo(NetworkError other) => code - other.code;
}

final class NotFound implements NetworkError {
  final int code = 404;
  final String description = 'Not found';

  NotFound();

  @override
  String toString() => 'NetworkError(code: $code, description: $description)';

  @override
  int compareTo(NetworkError other) => code - other.code;
}

final class UnsupportedError implements NetworkError {
  final int code = 9999;
  final String description = 'Unsupported error';

  UnsupportedError();

  @override
  String toString() => 'NetworkError(code: $code, description: $description)';

  @override
  int compareTo(NetworkError other) => code - other.code;
}
