import 'failure.dart';
import 'success.dart';

/// Callbacks that return [Failure] or [Success].
typedef Completion<T> = void Function(T value);

/// A value that represents either a success or a failure, including an
/// associated value in each case.
abstract class Result<F, S> {
  Result() {
    if (!isFailure && !isSuccess) {
      throw Exception('The Result must be a [Failure] or a [Success].');
    }
  }

  /// Returns true if [Result] is [Failure].
  bool get isFailure => this is Failure<F, S>;

  /// Returns true if [Result] is [Success].
  bool get isSuccess => this is Success<F, S>;

  /// Returns a new value of [Failure] result.
  F get failure {
    if (this is Failure<F, S>) {
      return (this as Failure<F, S>).value;
    }

    throw Exception('Check if result [isFailure] before accessing [failure]');
  }

  /// Returns a new value of [Success] result.
  S get success {
    if (this is Success<F, S>) {
      return (this as Success<F, S>).value;
    }

    throw Exception('Check if result [isSuccess] before accessing [success]');
  }

  /// Returns a new value of [Result] from closure.
  void result(Completion<F> failure, Completion<S> success) {
    if (isFailure) {
      final left = this as Failure<F, S>;
      failure(left.value);
    }

    if (isSuccess) {
      final right = this as Success<F, S>;
      success(right.value);
    }
  }
}
