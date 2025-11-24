import 'package:flutter/material.dart';
import 'core/vector2d.dart';
import 'core/simple_particle.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Physics Splash Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const Step1Screen(),
    );
  }
}

class Step1Screen extends StatefulWidget {
  const Step1Screen({Key? key}) : super(key: key);

  @override
  State<Step1Screen> createState() => _Step1ScreenState();
}

class _Step1ScreenState extends State<Step1Screen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late SimpleParticle _particle;
  DateTime _lastTime = DateTime.now();

  @override
  void initState() {
    super.initState();

    // パーティクルを作成（画面中央上部）
    _particle = SimpleParticle(position: Vector2D(200, 100));

    // 60FPSのアニメーションコントローラー
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(days: 1), // 無限ループ
    )..addListener(_onFrame);

    _controller.repeat();
  }

  void _onFrame() {
    final now = DateTime.now();
    final dt = now.difference(_lastTime).inMicroseconds / 1000000.0;
    _lastTime = now;

    setState(() {
      // 重力を適用
      final gravity = Vector2D(0, 100); // 下向き
      _particle.applyForce(gravity);

      // 更新
      _particle.update(dt);

      // 画面下に到達したらリセット
      if (_particle.position.y > MediaQuery.of(context).size.height) {
        _particle.position = Vector2D(200, 100);
        _particle.velocity = Vector2D.zero();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A237E), // 深い青
      body: Stack(
        children: [
          // パーティクルを描画
          CustomPaint(painter: ParticlePainter(_particle), size: Size.infinite),
          // 情報表示
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Step 1: 1個の点が落ちる',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '位置: (${_particle.position.x.toInt()}, ${_particle.position.y.toInt()})',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    '速度: (${_particle.velocity.x.toStringAsFixed(1)}, ${_particle.velocity.y.toStringAsFixed(1)})',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// パーティクルを描画するPainter
class ParticlePainter extends CustomPainter {
  final SimpleParticle particle;

  ParticlePainter(this.particle);

  @override
  void paint(Canvas canvas, Size size) {
    particle.draw(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
