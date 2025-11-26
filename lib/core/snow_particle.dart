import 'dart:math';
import 'package:flutter/material.dart';
import 'simple_particle.dart';
import 'vector2d.dart';

/// 雪のパーティクル
class SnowParticle extends SimpleParticle {
  double size;
  double rotation; // 回転角度
  double rotationSpeed; // 回転速度

  SnowParticle({
    required Vector2D position,
    this.size = 8.0,
    this.rotation = 0.0,
    this.rotationSpeed = 0.0,
  }) : super(position: position);

  @override
  void update(double dt) {
    super.update(dt);
    rotation += rotationSpeed * dt;
  }

  @override
  void draw(Canvas canvas) {
    canvas.save();
    canvas.translate(position.x, position.y);
    canvas.rotate(rotation);
    _drawSnowflake(canvas, Vector2D(0, 0), size);
    canvas.restore();
  }

  /// 雪の結晶を描画
  void _drawSnowflake(Canvas canvas, Vector2D pos, double size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final center = Offset(pos.x, pos.y);

    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * pi / 180;

      final endX = pos.x + cos(angle) * size;
      final endY = pos.y + sin(angle) * size;
      canvas.drawLine(center, Offset(endX, endY), paint);

      final branchSize = size * 0.4;
      final branchStart = size * 0.6;

      final branchX = pos.x + cos(angle) * branchStart;
      final branchY = pos.y + sin(angle) * branchStart;

      final leftAngle = angle - pi / 6;
      final leftX = branchX + cos(leftAngle) * branchSize;
      final leftY = branchY + sin(leftAngle) * branchSize;
      canvas.drawLine(Offset(branchX, branchY), Offset(leftX, leftY), paint);

      final rightAngle = angle + pi / 6;
      final rightX = branchX + cos(rightAngle) * branchSize;
      final rightY = branchY + sin(rightAngle) * branchSize;
      canvas.drawLine(Offset(branchX, branchY), Offset(rightX, rightY), paint);
    }
  }
}
