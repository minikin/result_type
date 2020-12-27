import 'result.dart';

/// A success, storing a [Success] value.
class Success<F, S> extends Result<F, S> {
  final S value;

  Success(this.value);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Success<F, S> && o.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Success: $value';
}
