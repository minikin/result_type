final class Crasher {
  Crasher._();

  /// This will throw an index out of range exception.
  static void outOfRange() {
    final numbers = <int>[1, 2, 3];
    print(numbers[5]);
  }

  /// This will throw a null pointer exception because text is null.
  static void nullPointerException() {
    String? text;
    print(text!.length);
  }
}
