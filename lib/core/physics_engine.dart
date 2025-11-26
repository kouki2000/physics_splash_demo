import 'package:flutter/material.dart';
import 'simple_particle.dart';
import 'vector2d.dart';

/// 物理演算エンジン
/// 複数のパーティクルを管理
class PhysicsEngine {
  final List<SimpleParticle> particles = [];
  Vector2D gravity;

  PhysicsEngine({Vector2D? gravity}) : gravity = gravity ?? Vector2D(0, 100);

  /// パーティクルを追加
  void addParticle(SimpleParticle particle) {
    particles.add(particle);
  }

  /// 全てのパーティクルを更新
  void update(double dt, Size screenSize) {
    for (var particle in particles) {
      // 重力を適用
      particle.applyForce(gravity);

      // 更新
      particle.update(dt);

      // 画面下に到達したら上に戻す
      if (particle.position.y > screenSize.height) {
        particle.position.y = -10;
        particle.velocity = Vector2D.zero();
      }
    }
  }

  /// 全てのパーティクルを描画
  void draw(Canvas canvas) {
    for (var particle in particles) {
      particle.draw(canvas);
    }
  }

  /// パーティクル数を取得
  int get particleCount => particles.length;
}
