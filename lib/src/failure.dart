import 'result.dart';

/// A failure, storing a [Failure] value.
class Failure<F, S> extends Result<F, S> {
  final F value;

  Failure(this.value);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Failure<F, S> && o.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Failure: $value';
}
