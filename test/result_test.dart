import 'dart:math';

import 'package:result_type/result_type.dart';
import 'package:test/test.dart';

import 'utils/mock_error.dart';

void main() {
  group('Result:', () {
    Random? random;

    setUp(() {
      random = Random();
    });

    tearDown(() {
      random = null;
    });

    test('Returns Success', () {
      final result = getUser(value: true);
      if (result.isSuccess) {
        print('Success: ${result.success}');
      } else {
        print('Error: ${result.failure}');
      }

      expect(result.success, 'John Doe');
    });

    test('Returns Failure', () {
      final result = getUser(value: false);
      if (result.isSuccess) {
        print('Success: ${result.success}');
      } else {
        print('Error: ${result.failure}');
      }

      expect(result.failure, const MockError(404));
    });

    test('Returns Success From Callbacks', () {
      getUser(value: true)
        ..result((success) {
          expect(success, 'John Doe');
        }, (_) {});
    });

    test('Returns Failure From Callbacks', () {
      getUser(value: false)
        ..result((_) {}, (error) {
          expect(error, const MockError(404));
        });
    });

    test(
        '''Throw Exception when accessing success value without checking if isSuccess''',
        () {
      final result = getUser(value: false);

      expect(() => result.success, throwsException);
    });

    test(
        '''Throw Exception when accessing failure value without checking if isFailure''',
        () {
      final result = getUser(value: true);

      expect(() => result.failure, throwsException);
    });

    test('Apply map transformation to successful operation results', () {
      final result = getUser(value: true);
      final user =
          result.map<String, MockError>((i) => i.toUpperCase()).success;

      expect(user, 'JOHN DOE');
    });

    test(
        '''Throw an error from map transformation without applying transformation to error type''',
        () {
      final result = getUser(value: false);
      final error =
          result.map<String, MockError>((i) => i.toUpperCase()).failure;

      expect(error, const MockError(404));
    });

    test('Apply mapError transformation to failure type', () {
      final error = getUser(value: false)
          .mapError<String, MockError>((i) => MockError(i.code - 4))
          .failure;

      expect(error.code, const MockError(400).code);
    });

    test(
        '''Returns successful result without applying mapError transformation''',
        () {
      final maybeError = getUser(value: true)
          .mapError<String, MockError>((i) => MockError(i.code - 4));

      if (maybeError.isFailure) {
      } else {
        expect(maybeError.success, 'John Doe');
      }
    });

    test('Apply flatMap transformation to successful operation results', () {
      Result<int, MockError> getNextInteger() => Success(random!.nextInt(4));
      Result<int, MockError> getNextAfterInteger(int n) =>
          Success(random!.nextInt(n + 1));

      final nextIntegerUnboxedResults =
          getNextInteger().flatMap(getNextAfterInteger);

      expect(
        nextIntegerUnboxedResults,
        const TypeMatcher<Success<int, MockError>>(),
      );
    });

    test('flatMap does not apply transformation to Failure', () {
      Result<int, MockError> getNextInteger() => Failure(const MockError(451));
      Result<int, MockError> getNextAfterInteger(int n) =>
          Failure(const MockError(404));

      final nextIntegerUnboxedResults =
          getNextInteger().flatMap(getNextAfterInteger);

      expect(
        nextIntegerUnboxedResults,
        const TypeMatcher<Failure<int, MockError>>(),
      );
    });

    test('Apply flatMapError transformation to failure operation results', () {
      Result<int, MockError> getNextInteger() => Failure(const MockError(451));
      Result<int, MockError> getNextAfterInteger(MockError error) =>
          Failure(MockError(error.code));

      final nextIntegerUnboxedResults =
          getNextInteger().flatMapError<int, MockError>(getNextAfterInteger);

      expect(
        nextIntegerUnboxedResults,
        const TypeMatcher<Failure<int, MockError>>(),
      );
    });

    test(
        '''flatMapError does not apply transformation to success operation results''',
        () {
      Result<int, MockError> getNextInteger() => Success(random!.nextInt(4));
      Result<int, MockError> getNextAfterInteger(MockError error) =>
          Failure(MockError(error.code));

      final nextIntegerUnboxedResults =
          getNextInteger().flatMapError<int, MockError>(getNextAfterInteger);

      expect(
        nextIntegerUnboxedResults,
        const TypeMatcher<Success<int, MockError>>(),
      );
    });
  });

  test('isFailure returns true for Failure result', () {
    final result = Failure<int, MockError>(const MockError(404));
    expect(result.isFailure, isTrue);
  });

  test('isFailure returns false for Success result', () {
    final result = Success<int, MockError>(42);
    expect(result.isFailure, isFalse);
  });

  test('isSuccess returns true for Success result', () {
    final result = Success<int, MockError>(42);
    expect(result.isSuccess, isTrue);
  });

  test('isSuccess returns false for Failure result', () {
    final result = Failure<int, MockError>(const MockError(404));
    expect(result.isSuccess, isFalse);
  });

  test('unwrapOrElse returns success value if result is success', () {
    final result = Success<int, MockError>(42);
    final unwrapped = result.unwrapOrElse(0, (t) => t + 1);

    expect(unwrapped, 42);
  });

  test('unwrapOrElse returns operation result if result is failure', () {
    final result = Failure<int, MockError>(const MockError(404));
    final unwrapped = result.unwrapOrElse(0, (t) => t + 1);

    expect(unwrapped, 1);
  });

  test('unwrapOr returns success value if result is success', () {
    final result = Success<int, MockError>(42);
    final unwrapped = result.unwrapOr(0);

    expect(unwrapped, 42);
  });

  test('unwrapOr returns initial value if result is failure', () {
    final result = Failure<int, MockError>(const MockError(404));
    final unwrapped = result.unwrapOr(0);

    expect(unwrapped, 0);
  });

  test('Unwrap success result', () {
    final result = Success<int, MockError>(42);
    final unwrapped = result.unwrap();

    expect(unwrapped, 42);
  });

  test('Throw exception when unwrapping failure result', () {
    final result = Failure<int, MockError>(const MockError(404));

    expect(result.unwrap, throwsException);
  });
}

Result<String, MockError> getUser({required bool value}) =>
    value ? Success('John Doe') : Failure(const MockError(404));
