// ignore_for_file: lines_longer_than_80_chars
import 'package:meta/meta.dart';

/// Callbacks that return [Success] or [Failure].
typedef Completion<T> = void Function(T value);

/// A value that represents either a success or a failure, including an
/// associated value in each case.
sealed class Result<S, F extends Exception> {
  /// Returns the [Failure] instance if this result is a [Failure],
  /// otherwise throws a cast error.
  Failure<S, F> get _right => this as Failure<S, F>;

  /// Returns the left value of a [Success] instance.
  Success<S, F> get _left => this as Success<S, F>;

  /// Returns true if [Result] is [Failure].
  bool get isFailure => this is Failure<S, F>;

  /// Returns true if [Result] is [Success].
  bool get isSuccess => this is Success<S, F>;

  /// Returns a new value of [Failure] result.
  ///
  /// Throws an exception if the result is [Success].
  ///
  /// Example usage.
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
    if (isFailure) {
      return (this as Failure<S, F>).value;
    }

    throw Exception(
      'Make sure that result [isFailure] before accessing [failure]. /n$_left',
    );
  }

  /// Returns a new value of [Success] result.
  ///
  /// Throws an exception if the result is [Failure].
  ///
  /// Example usage.
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
    if (isSuccess) {
      return (this as Success<S, F>).value;
    }

    throw Exception(
      'Make sure that result [isSuccess] before accessing [success]. \n$_right',
    );
  }

  /// Returns a new value of [Result] from closure
  /// either a success or a failure.
  ///
  /// Example usage:
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
      success(_left.value);
    } else {
      failure(_right.value);
    }
  }

  /// Maps a [Result<S, F>] to [Result<U, F>] by applying a function
  /// to a contained [Success] value, leaving an [Failure] value untouched.
  /// This function can be used to compose the results of two functions.
  ///
  /// Example usage.
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
  Result<U, F> map<U, E extends Exception>(U Function(S) transform) {
    // return switch (this) {
    //   Success(value: final data) => transform(data) as Success<U, F>,
    //   Failure(value: final error) => error as Failure<U, F>,
    // };
    if (isSuccess) {
      return Success(transform(_left.value));
    } else {
      return Failure(_right.value);
    }
  }

  /// Maps a [Result<S, F>] to [Result<S, E>] by applying a function
  /// to a contained [Failure] value, leaving an [Success] value untouched.
  ///
  /// This function can be used to pass through a successful result
  /// while applying transformation to [Failure].
  ///
  Result<S, E> mapError<V, E extends Exception>(E Function(F) transform) {
    if (isSuccess) {
      return Success(_left.value);
    } else {
      return Failure(transform(_right.value));
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
  /// Example usage:
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
  Result<U, F> flatMap<U, E extends Exception>(
    Result<U, F> Function(S) transform,
  ) {
    if (isSuccess) {
      return transform(_left.value);
    } else {
      return Failure(_right.value);
    }
  }

  /// Maps a [Result<S, F>] to [Result<S, E>] by applying a function
  /// to a contained [Failure] value, leaving an [Success] value untouched.
  ///
  /// This function can be used to pass through a successful result
  /// while unboxing [Failure] and applying transformation to it.
  ///
  Result<S, E> flatMapError<V, E extends Exception>(
    Result<S, E> Function(F) transform,
  ) {
    if (isSuccess) {
      return Success(_left.value);
    } else {
      return transform(_right.value);
    }
  }

  /// Unwraps the [Result] and returns the [Success] value.
  ///
  /// If the result is a [Success], returns the success value.
  /// If the result is a [Failure], throws an exception.
  ///
  /// Use this method when you are certain that the result is a success
  /// and you want to access the [Success] value directly.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// final result = await someAsyncOperation();
  ///
  /// final value = result.unwrap();
  /// print('Success value: $value');
  /// ```
  Result<S, F> unwrap() {
    if (isSuccess) {
      return Success(_left.value);
    } else {
      throw Exception('Cannot unwrap a failure result. \n$_right');
    }
  }

  /// Unwraps the [Result] and returns the [Success] value.
  /// If the result is a [Success], returns the success value.
  /// If the result is a [Failure], returns the provided [initial] value
  /// as a [Success].
  ///
  /// Use this method when you want to access the [Success] value directly,
  /// but also handle the case when the result is a [Failure].
  ///
  /// Example usage:
  ///
  /// ```dart
  /// final result = await someAsyncOperation();
  ///
  /// final value = result.unwrapOr(0);
  /// print('Success value: $value');
  /// ```
  Success<S, F> unwrapOr<T>(T initial) {
    if (isSuccess) {
      return Success(_left.value);
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
class Failure<S, F extends Exception> extends Result<S, F> {
  final F value;
  final Object? message;

  Failure(this.value, [this.message]);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Failure<S, F> && o.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  StackTrace get _stackTrace => StackTrace.current;

  @override
  String toString() => 'Failure: $value, $message, $_stackTrace';
}
