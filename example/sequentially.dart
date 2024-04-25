// ignore_for_file: inference_failure_on_instance_creation

import 'package:result_type/result_type.dart';

void main() async {
  // Chain multiple asynchronous operations.
  final result1 = await ImaginaryService.fetchData1();
  final result2 = await ImaginaryService.fetchData2(result1.success);
  final result3 = await ImaginaryService.fetchData2(result2.success);

  // Print the result of the last operation: `Success: Default Data`
  print(result3.unwrapOr('Default Data'));

  // This will throw an exception as `_handleResult`
  // has a case with 'Wrong Data'.
  //print(result3.unwrap());

  final one = result3.unwrapOrElse('Default (((((Data)))))', length);
  // Print the result of the last operation: `Success: 22`
  print(one);
}

String length(String string) => string.length.toString();

final class ImaginaryService {
  ImaginaryService._();

  static Future<Result<String, IOError>> fetchData1() async {
    await Future.delayed(const Duration(seconds: 1));
    final value = 'Data from fetchData1';

    return _handleResult(value);
  }

  static Future<Result<String, IOError>> fetchData2(String data) async {
    await Future.delayed(const Duration(seconds: 1));
    final value = 'Data from fetchData2 + $data';

    return _handleResult(value);
  }

  static Future<Result<String, IOError>> fetchData3(String data) async {
    await Future.delayed(const Duration(seconds: 1));
    final value = 'Data from fetchData3 + $data';

    return _handleResult(value);
  }

  static Result<String, IOError> _handleResult(Object data) {
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
          ReadError(data),
        );
    }
  }
}

sealed class IOError implements Comparable<IOError>, Exception {
  final String description;

  IOError({
    required this.description,
  });
}

final class ReadError implements IOError {
  final String description = 'Can not read from the file.';

  Object? data;

  ReadError(this.data);

  @override
  String toString() => 'IOError(description: $description, data: $data)';

  @override
  int compareTo(IOError other) => description.length - other.description.length;
}