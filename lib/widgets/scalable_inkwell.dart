import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScalableInkWell extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;
  final double scale;

  const ScalableInkWell({
    super.key,
    required this.onTap,
    required this.child,
    this.scale = 0.95,
  });

  @override
  State<ScalableInkWell> createState() => _ScalableInkWellState();
}

class _ScalableInkWellState extends State<ScalableInkWell> {
  double _scale = 1.0;

  Future<void> _handleTap() async {
    // 눌렸을 때 크기를 작게
    setState(() {
      _scale = widget.scale;
    });
    HapticFeedback.lightImpact();
    // 애니메이션 대기
    await Future.delayed(const Duration(milliseconds: 100));

    // 다시 크기를 원래대로
    setState(() {
      _scale = 1.0;
    });

    // 애니메이션 대기
    await Future.delayed(const Duration(milliseconds: 100));

    // onTap 콜백 실행
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }
}
