sealed class NetworkError implements Comparable<NetworkError>, Exception {
  final int code;
  final String description;
  StackTrace? stackTrace;

  NetworkError({
    required this.code,
    required this.description,
    required this.stackTrace,
  });
}

final class BadRequest implements NetworkError {
  final int code = 400;
  final String description = 'Bad request';

  BadRequest({required this.stackTrace});

  @override
  String toString() => 'NetworkError(code: $code, description: $description)';

  @override
  int compareTo(NetworkError other) => code - other.code;

  @override
  StackTrace? stackTrace;
}

final class NotFound implements NetworkError {
  final int code = 404;
  final String description = 'Not found';

  NotFound({required this.stackTrace});

  @override
  String toString() => 'NetworkError(code: $code, description: $description)';

  @override
  int compareTo(NetworkError other) => code - other.code;

  @override
  StackTrace? stackTrace;
}

final class UnsupportedError implements NetworkError {
  final int code = 9999;
  final String description = 'Unsupported error';

  UnsupportedError({required this.stackTrace});

  @override
  String toString() => 'NetworkError(code: $code, description: $description)';

  @override
  int compareTo(NetworkError other) => code - other.code;

  @override
  StackTrace? stackTrace;
}
