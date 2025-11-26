import 'package:flutter/material.dart';
import 'package:physics_splash_demo/core/snow_particle.dart';
import 'dart:math';
import 'core/vector2d.dart';
import 'core/simple_particle.dart';
import 'core/physics_engine.dart';

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
      home: const Step3Screen(),
    );
  }
}

class Step2Screen extends StatefulWidget {
  const Step2Screen({Key? key}) : super(key: key);

  @override
  State<Step2Screen> createState() => _Step2ScreenState();
}

class _Step2ScreenState extends State<Step2Screen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late PhysicsEngine _engine;
  DateTime _lastTime = DateTime.now();
  final Random _random = Random();
  bool _initialized = false; // 初期化フラグを追加

  @override
  void initState() {
    super.initState();

    // 物理演算エンジンを作成
    _engine = PhysicsEngine(gravity: Vector2D(0, 100));

    // 60FPSのアニメーションコントローラー
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(days: 1),
    )..addListener(_onFrame);

    _controller.repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 初回だけパーティクルを追加
    if (!_initialized) {
      for (int i = 0; i < 50; i++) {
        _addRandomParticle();
      }
      _initialized = true;
    }
  }

  /// ランダムな位置にパーティクルを追加
  void _addRandomParticle() {
    final screenWidth = MediaQuery.of(context).size.width;
    final particle = SimpleParticle(
      position: Vector2D(
        _random.nextDouble() * screenWidth, // ランダムなX座標
        _random.nextDouble() * -200, // 画面上部（少し上から）
      ),
    );
    _engine.addParticle(particle);
  }

  void _onFrame() {
    final now = DateTime.now();
    final dt = now.difference(_lastTime).inMicroseconds / 1000000.0;
    _lastTime = now;

    setState(() {
      final screenSize = MediaQuery.of(context).size;
      _engine.update(dt, screenSize);
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
          CustomPaint(painter: EnginePainter(_engine), size: Size.infinite),
          // 情報表示
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Step 2: 複数の点が降る',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'パーティクル数: ${_engine.particleCount}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    '重力: ${_engine.gravity}',
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

class Step3Screen extends StatefulWidget {
  const Step3Screen({Key? key}) : super(key: key);

  @override
  State<Step3Screen> createState() => _Step3ScreenState();
}

class _Step3ScreenState extends State<Step3Screen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late PhysicsEngine _engine;
  DateTime _lastTime = DateTime.now();
  final Random _random = Random();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    _engine = PhysicsEngine(gravity: Vector2D(0, 100));

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(days: 1),
    )..addListener(_onFrame);

    _controller.repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      for (int i = 0; i < 50; i++) {
        _addRandomSnowParticle();
      }
      _initialized = true;
    }
  }

  /// ランダムな位置に雪のパーティクルを追加
  void _addRandomSnowParticle() {
    final screenWidth = MediaQuery.of(context).size.width;
    final particle = SnowParticle(
      position: Vector2D(
        _random.nextDouble() * screenWidth,
        _random.nextDouble() * -200,
      ),
      size: 6 + _random.nextDouble() * 6, // 6〜12のランダムなサイズ
    );
    _engine.addParticle(particle);
  }

  void _onFrame() {
    final now = DateTime.now();
    final dt = now.difference(_lastTime).inMicroseconds / 1000000.0;
    _lastTime = now;

    setState(() {
      final screenSize = MediaQuery.of(context).size;
      _engine.update(dt, screenSize);
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
      backgroundColor: const Color(0xFF1A237E),
      body: Stack(
        children: [
          CustomPaint(painter: EnginePainter(_engine), size: Size.infinite),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Step 3: 点を雪の形にする',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'パーティクル数: ${_engine.particleCount}',
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

/// PhysicsEngineを描画するPainter
class EnginePainter extends CustomPainter {
  final PhysicsEngine engine;

  EnginePainter(this.engine);

  @override
  void paint(Canvas canvas, Size size) {
    engine.draw(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
