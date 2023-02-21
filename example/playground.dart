(double x, double y) geoLocation(String name) {
  if (name == 'Nairobi') {
    return (-1.2921, 36.8219);
  } else {
    return (0.0, 0.0);
  }
}

sealed class Shape {
}

class Square implements Shape {
  final double length;
  Square(this.length);
}

class Circle implements Shape {
  final double radius;
  Circle(this.radius);
}

double calculateArea(Shape shape) => switch (shape) {
   Square(length: final l) => l * l,
   Circle(radius: final r) => 2 * r * r
};

void main() {

}