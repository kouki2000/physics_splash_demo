import 'dart:math';
import 'package:flutter/material.dart';
import 'simple_particle.dart';
import 'vector2d.dart';

/// 雪のパーティクル
class SnowParticle extends SimpleParticle {
  double size; // 雪の大きさ

  SnowParticle({required Vector2D position, this.size = 8.0})
    : super(position: position);

  @override
  void draw(Canvas canvas) {
    _drawSnowflake(canvas, position, size);
  }

  /// 雪の結晶を描画
  void _drawSnowflake(Canvas canvas, Vector2D pos, double size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final center = Offset(pos.x, pos.y);

    // 6本の線を描画（60度ずつ）
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * pi / 180;

      // メインの線
      final endX = pos.x + cos(angle) * size;
      final endY = pos.y + sin(angle) * size;
      canvas.drawLine(center, Offset(endX, endY), paint);

      // 枝を描画
      final branchSize = size * 0.4;
      final branchStart = size * 0.6;

      final branchX = pos.x + cos(angle) * branchStart;
      final branchY = pos.y + sin(angle) * branchStart;

      // 左の枝
      final leftAngle = angle - pi / 6;
      final leftX = branchX + cos(leftAngle) * branchSize;
      final leftY = branchY + sin(leftAngle) * branchSize;
      canvas.drawLine(Offset(branchX, branchY), Offset(leftX, leftY), paint);

      // 右の枝
      final rightAngle = angle + pi / 6;
      final rightX = branchX + cos(rightAngle) * branchSize;
      final rightY = branchY + sin(rightAngle) * branchSize;
      canvas.drawLine(Offset(branchX, branchY), Offset(rightX, rightY), paint);
    }
  }
}
