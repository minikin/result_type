// ignore_for_file: inference_failure_on_instance_creation

import 'package:result_type/result_type.dart';

final class ImaginaryService {
  ImaginaryService._();

  static Future<Result<String, ImaginaryException>> fetchData1() async {
    await Future.delayed(const Duration(seconds: 1));
    final value = 'Data from fetchData1';

    return _handleResult(value);
  }

  static Future<Result<String, ImaginaryException>> fetchData2(
      String data) async {
    await Future.delayed(const Duration(seconds: 1));
    final value = 'Data from fetchData2 + $data';

    return _handleResult(value);
  }

  static Future<Result<String, ImaginaryException>> fetchData3(
      String data) async {
    await Future.delayed(const Duration(seconds: 1));
    final value = 'Data from fetchData3 + $data';

    return _handleResult(value);
  }

  static Result<String, ImaginaryException> _handleResult(Object data) {
    switch (data) {
      case 'Data from fetchData1':
        return Success('Data from fetchData1');
      case 'Data from fetchData2 + Data from fetchData1':
        return Success('Data from fetchData2');
      case 'Data from fetchData3':
        return Success('Data from fetchData3');
      case 'Data from fetchData2 + Data from fetchData2 + Wrong Data':
        return Success('Data from fetchData2');
      default:
        return Failure(
          ReadException(data),
        );
    }
  }
}

sealed class ImaginaryException
    implements Comparable<ImaginaryException>, Exception {
  final String description;

  ImaginaryException({
    required this.description,
  });
}

final class ReadException implements ImaginaryException {
  final String description = 'Can not read from the file.';

  Object? data;

  ReadException(this.data);

  @override
  String toString() =>
      'ImaginaryException(description: $description, data: $data)';

  @override
  int compareTo(ImaginaryException other) =>
      description.length - other.description.length;
}
