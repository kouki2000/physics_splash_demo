import 'dart:async';

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
      home: const Step6Screen(),
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

class Step4Screen extends StatefulWidget {
  const Step4Screen({Key? key}) : super(key: key);

  @override
  State<Step4Screen> createState() => _Step4ScreenState();
}

class _Step4ScreenState extends State<Step4Screen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late PhysicsEngine _engine;
  DateTime _lastTime = DateTime.now();
  final Random _random = Random();
  bool _initialized = false;
  double _windStrength = 0.0; // 風の強さ

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

  void _addRandomSnowParticle() {
    final screenWidth = MediaQuery.of(context).size.width;
    final particle = SnowParticle(
      position: Vector2D(
        _random.nextDouble() * screenWidth,
        _random.nextDouble() * -200,
      ),
      size: 6 + _random.nextDouble() * 6,
      rotationSpeed: -1.0 + _random.nextDouble() * 2.0, // 回転速度を追加
    );
    _engine.addParticle(particle);
  }

  void _onFrame() {
    final now = DateTime.now();
    final dt = now.difference(_lastTime).inMicroseconds / 1000000.0;
    _lastTime = now;

    setState(() {
      // 風の強さを時間で変化させる
      _windStrength = sin(now.millisecondsSinceEpoch / 2000) * 30;
      final wind = Vector2D(_windStrength, 0);

      // 全パーティクルに風を適用
      for (var particle in _engine.particles) {
        particle.applyForce(wind);
      }

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
                    'Step 4: 回転・横揺れを追加',
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
                    '風: ${_windStrength.toStringAsFixed(1)}',
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

class Step5Screen extends StatefulWidget {
  const Step5Screen({Key? key}) : super(key: key);

  @override
  State<Step5Screen> createState() => _Step5ScreenState();
}

class _Step5ScreenState extends State<Step5Screen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late PhysicsEngine _engine;
  DateTime _lastTime = DateTime.now();
  final Random _random = Random();
  bool _initialized = false;
  double _windStrength = 0.0;
  double _opacity = 0.0; // フェードイン用

  @override
  void initState() {
    super.initState();

    _engine = PhysicsEngine(gravity: Vector2D(0, 100));

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(days: 1),
    )..addListener(_onFrame);

    _controller.repeat();

    // フェードイン開始
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });
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

  void _addRandomSnowParticle() {
    final screenWidth = MediaQuery.of(context).size.width;
    final particle = SnowParticle(
      position: Vector2D(
        _random.nextDouble() * screenWidth,
        _random.nextDouble() * -200,
      ),
      size: 6 + _random.nextDouble() * 6,
      rotationSpeed: -1.0 + _random.nextDouble() * 2.0,
    );
    _engine.addParticle(particle);
  }

  void _onFrame() {
    final now = DateTime.now();
    final dt = now.difference(_lastTime).inMicroseconds / 1000000.0;
    _lastTime = now;

    setState(() {
      _windStrength = sin(now.millisecondsSinceEpoch / 2000) * 30;
      final wind = Vector2D(_windStrength, 0);

      for (var particle in _engine.particles) {
        particle.applyForce(wind);
      }

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
          Center(
            child: AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: // Image.asset() の代わりに Icon() を使う
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.ac_unit, // 雪のアイコン
                          size: 120,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'My Awesome App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start),
            ),
          ),
        ],
      ),
    );
  }
}

class Step6Screen extends StatefulWidget {
  const Step6Screen({Key? key}) : super(key: key);

  @override
  State<Step6Screen> createState() => _Step6ScreenState();
}

class _Step6ScreenState extends State<Step6Screen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late PhysicsEngine _engine;
  DateTime _lastTime = DateTime.now();
  final Random _random = Random();
  bool _initialized = false;
  double _windStrength = 0.0;
  double _opacity = 0.0;
  Timer? _snowGeneratorTimer; // 追加

  static const int maxParticles = 100; // 追加

  @override
  void initState() {
    super.initState();

    _engine = PhysicsEngine(gravity: Vector2D(0, 100));

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(days: 1),
    )..addListener(_onFrame);

    _controller.repeat();

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    // 定期的に雪を追加（0.2秒ごと）
    _snowGeneratorTimer = Timer.periodic(const Duration(milliseconds: 200), (
      timer,
    ) {
      if (_engine.particleCount < maxParticles) {
        _addRandomSnowParticle();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      // 初期は20個だけ生成
      for (int i = 0; i < 20; i++) {
        _addRandomSnowParticle();
      }
      _initialized = true;
    }
  }

  void _addRandomSnowParticle() {
    final screenWidth = MediaQuery.of(context).size.width;
    final particle = SnowParticle(
      position: Vector2D(
        _random.nextDouble() * screenWidth,
        _random.nextDouble() * -200,
      ),
      size: 6 + _random.nextDouble() * 6,
      rotationSpeed: -1.0 + _random.nextDouble() * 2.0,
    );
    _engine.addParticle(particle);
  }

  void _onFrame() {
    final now = DateTime.now();
    final dt = now.difference(_lastTime).inMicroseconds / 1000000.0;
    _lastTime = now;

    setState(() {
      _windStrength = sin(now.millisecondsSinceEpoch / 2000) * 30;
      final wind = Vector2D(_windStrength, 0);

      for (var particle in _engine.particles) {
        particle.applyForce(wind);
      }

      final screenSize = MediaQuery.of(context).size;
      _engine.update(dt, screenSize);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _snowGeneratorTimer?.cancel(); // 追加
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A237E),
      body: Stack(
        children: [
          CustomPaint(painter: EnginePainter(_engine), size: Size.infinite),
          Center(
            child: AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.ac_unit, // 雪のアイコン
                          size: 120,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'My Awesome App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start),
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
