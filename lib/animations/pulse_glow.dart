import 'package:flutter/material.dart'
;
class PulsatingGlow extends StatefulWidget {
  final Widget child;

  const PulsatingGlow({super.key, required this.child});

  @override
  State<PulsatingGlow> createState() => _PulsatingGlowState();
}

class _PulsatingGlowState extends State<PulsatingGlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        final blur = 12.0 + (_controller.value * 8.0);
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0xFF00F5FF).withValues(alpha: 0.3),
                blurRadius: blur,
                spreadRadius: 2,
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
