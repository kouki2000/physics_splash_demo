import 'dart:math';

/// 2Dベクトルクラス
class Vector2D {
  double x;
  double y;

  Vector2D(this.x, this.y);

  Vector2D.zero() : this(0, 0);

  Vector2D operator +(Vector2D other) => Vector2D(x + other.x, y + other.y);
  Vector2D operator -(Vector2D other) => Vector2D(x - other.x, y - other.y);
  Vector2D operator *(double scalar) => Vector2D(x * scalar, y * scalar);
  Vector2D operator /(double scalar) => Vector2D(x / scalar, y / scalar);

  double get length => sqrt(x * x + y * y);

  void add(Vector2D other) {
    x += other.x;
    y += other.y;
  }

  @override
  String toString() => 'Vector2D($x, $y)';
}
