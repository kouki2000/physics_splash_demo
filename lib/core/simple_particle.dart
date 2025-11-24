import 'package:flutter/material.dart';
import 'vector2d.dart';

/// 簡単なパーティクル（1個の点）
class SimpleParticle {
  Vector2D position; // 位置
  Vector2D velocity; // 速度
  Vector2D acceleration; // 加速度

  SimpleParticle({required this.position})
    : velocity = Vector2D.zero(),
      acceleration = Vector2D.zero();

  /// 物理演算を更新
  void update(double dt) {
    // 速度に加速度を加える
    velocity.add(acceleration * dt);

    // 位置に速度を加える
    position.add(velocity * dt);

    // 加速度をリセット
    acceleration = Vector2D.zero();
  }

  /// 力を加える
  void applyForce(Vector2D force) {
    acceleration.add(force);
  }

  /// 画面に描画
  void draw(Canvas canvas) {
    // 白い円を描画
    canvas.drawCircle(
      Offset(position.x, position.y),
      8, // 半径
      Paint()..color = Colors.white,
    );
  }
}
