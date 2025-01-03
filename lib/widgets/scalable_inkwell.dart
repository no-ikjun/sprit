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

  void _onTapDown(TapDownDetails details) {
    HapticFeedback.lightImpact();
    setState(() {
      _scale = widget.scale; // 눌렀을 때 크기를 5% 줄임
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0;
    });
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }
}
