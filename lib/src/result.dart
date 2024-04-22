// ignore_for_file: lines_longer_than_80_chars, avoid_shadowing_type_parameters
import 'package:meta/meta.dart';

/// Callbacks that return [Success] or [Failure].
typedef Completion<T> = void Function(T value);

/// A value that represents either a success or a failure, including an
/// associated value in each case.
sealed class Result<S, F extends Exception> {
  /// Returns true if [Result] is [Failure].
  bool get isFailure => this is Failure<S, F>;

  /// Returns true if [Result] is [Success].
  bool get isSuccess => this is Success<S, F>;

  /// Returns a new value of [Failure] result.
  ///
  /// Handle an error or do something with successful operation results:
  ///
  /// ```dart
  /// final result = await getPhotos();
  ///
  /// if (result.isFailure) {
  ///   print('Error: ${result.failure}');
  /// } else {
  ///   print('Photos Items: ${result.success}');
  /// }
  /// ```
  ///
  F get failure {
    if (this is Failure<S, F>) {
      return (this as Failure<S, F>).value;
    }

    throw Exception(
      'Make sure that result [isFailure] before accessing [failure]',
    );
  }

  /// Returns a new value of [Success] result.
  ///
  /// Do something with successful operation results or handle an error:
  ///
  /// ```dart
  /// final result = await getPhotos();
  ///
  /// if (result.isSuccess) {
  ///   print('Photos Items: ${result.success}');
  /// } else {
  ///   print('Error: ${result.failure}');
  /// }
  /// ```
  ///
  S get success {
    if (this is Success<S, F>) {
      return (this as Success<S, F>).value;
    }

    throw Exception(
      'Make sure that result [isSuccess] before accessing [success].',
    );
  }

  /// Returns a new value of [Result] from closure
  /// either a success or a failure.
  ///
  /// This example shows how to use completion handler.
  ///
  /// ```dart
  /// final result = await getPhotos();
  ///
  /// await getPhotos(client)
  /// ..result((photos) {
  ///   print('Photos: $photos');
  /// }, (error) {
  ///   print('Error: $error');
  /// });
  /// ```
  ///
  void result(Completion<S> success, Completion<F> failure) {
    if (isSuccess) {
      final left = this as Success<S, F>;
      success(left.value);
    }

    if (isFailure) {
      final right = this as Failure<S, F>;
      failure(right.value);
    }
  }

  /// Maps a [Result<S, F>] to [Result<U, F>] by applying a function
  /// to a contained [Success] value, leaving an [Failure] value untouched.
  /// This function can be used to compose the results of two functions.
  ///
  /// Apply transformation to successful operation results or handle an error:
  ///
  /// ```dart
  /// final result = await getPhotos();
  ///
  /// if (result.isSuccess) {
  ///   final items = result.map((i) => i.where((j) => j.title.length > 60)).success;
  ///   print('Number of Long Titles: ${items.length}');
  /// } else {
  ///   print('Error: ${result.failure}');
  /// }
  /// ```
  ///
  Result<U, F> map<U, F extends Exception>(U Function(S) transform) {
    return switch (this) {
      Success(value: final data) => transform(data) as Success<U, F>,
      Failure(value: final error) => error as Failure<U, F>,
    };
  }

  /// Maps a [Result<S, F>] to [Result<S, E>] by applying a function
  /// to a contained [Failure] value, leaving an [Success] value untouched.
  ///
  /// This function can be used to pass through a successful result
  /// while applying transformation to [Failure].
  ///
  Result<S, E> mapError<S, E extends Exception>(E Function(F) transform) {
    if (isSuccess) {
      final left = this as Success<S, F>;
      return Success(left.value);
    } else {
      final right = this as Failure<S, F>;
      return Failure(transform(right.value));
    }
  }

  /// Maps a [Result<S, F>] to [Result<U, F>] by applying a function
  /// to a contained [Success] value and unwrapping the produced result,
  /// leaving an [Failure] value untouched.
  ///
  /// Use this method to avoid a nested result when your transformation
  /// produces another [Result] type.
  ///
  /// In this example, note the difference in the result of using `map` and
  /// `flatMap` with a transformation that returns an result type.
  ///
  /// ```dart
  /// Result<int, Error> getNextInteger() => Success(random.nextInt(4));
  /// Result<int, Error> getNextAfterInteger(int n) => Success(random.nextInt(n + 1));
  ///
  /// final nextIntegerNestedResults = getNextInteger().map(getNextAfterInteger);
  /// print(nextIntegerNestedResults.runtimeType);
  /// `Prints: Success<Result<int, Error>, dynamic>`
  ///
  /// final nextIntegerUnboxedResults = getNextInteger().flatMap(getNextAfterInteger);
  /// print(nextIntegerUnboxedResults.runtimeType);
  /// `Prints: Success<int, Error>`
  ///  ```
  Result<U, F> flatMap<U, F extends Exception>(
      Result<U, F> Function(S) transform) {
    if (isSuccess) {
      final left = this as Success<S, F>;
      return transform(left.value);
    } else {
      final right = this as Failure<S, F>;
      return Failure(right.value);
    }
  }

  /// Maps a [Result<S, F>] to [Result<S, E>] by applying a function
  /// to a contained [Failure] value, leaving an [Success] value untouched.
  ///
  /// This function can be used to pass through a successful result
  /// while unboxing [Failure] and applying transformation to it.
  ///
  Result<S, E> flatMapError<S, E extends Exception>(
      Result<S, E> Function(F) transform) {
    if (isSuccess) {
      final left = this as Success<S, F>;
      return Success(left.value);
    } else {
      final right = this as Failure<S, F>;
      return transform(right.value);
    }
  }

  /// Unwraps the result and returns the value or error.
  ///
  /// This method is used to extract the value or error from a `Result` object.
  /// If the result is a `Success`, the value is returned as a `Success` object.
  /// If the result is a `Failure`, the error is returned as a `Failure` object.
  ///
  /// The generic type parameters `U` and `F` represent the type of the value and error, respectively.
  ///
  /// Returns:
  /// - The value as a `Success` object if the result is a `Success`.
  /// - The error as a `Failure` object if the result is a `Failure`.
  Result<S, F> unwrap() {
    if (isSuccess) {
      final left = this as Success<S, F>;
      return Success(left.value);
    } else {
      final right = this as Failure<S, F>;
      return Failure(right.value);
    }
  }

  /// Unwraps the `Success` value or returns the provided initial value.
  ///
  /// If the `Result` is a `Success`, this method returns the inner `Success` value.
  /// If the `Result` is a `Failure`, this method returns the provided initial value.
  ///
  /// The type of the initial value should match the type of the `Success` value.
  ///
  /// Example usage:
  /// ```dart
  /// Result<int, String> result = Success(42);
  /// int unwrappedValue = result.unwrapOr(0); // Returns 42
  ///
  /// Result<int, String> result2 = Failure("Error");
  /// int unwrappedValue2 = result2.unwrapOr(0); // Returns 0
  /// ```
  Success<S, F> unwrapOr<T>(T initial) {
    if (isSuccess) {
      final left = this as Success<S, F>;
      return Success(left.value);
    } else {
      return Success(initial as S);
    }
  }
}

/// A success, storing a [Success] value.
@immutable
final class Success<S, F extends Exception> extends Result<S, F> {
  final S value;

  Success(this.value);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Success<S, F> && o.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Success: $value';
}

/// A failure, storing a [Failure] value.
@immutable
final class Failure<S, F extends Exception> extends Result<S, F> {
  final F value;

  Failure(this.value);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Failure<S, F> && o.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  StackTrace get _stackTrace => StackTrace.current;

  @override
  String toString() => 'Failure: $value, $_stackTrace';
}
