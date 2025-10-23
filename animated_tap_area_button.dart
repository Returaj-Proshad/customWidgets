import 'package:flutter/material.dart';

class AnimatedTapArea extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final Color? splashColor;
  final Duration duration;
  final double pressedScale;

  const AnimatedTapArea({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius,
    this.splashColor,
    this.duration = const Duration(milliseconds: 120),
    this.pressedScale = 0.55,
  });

  @override
  State<AnimatedTapArea> createState() => _AnimatedTapAreaState();
}

class _AnimatedTapAreaState extends State<AnimatedTapArea> {
  bool _isPressed = false;

  void _handleHighlightChanged(bool value) {
    setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? BorderRadius.circular(8);

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        splashColor: widget.splashColor ?? Theme.of(context).splashColor,
        onTap: widget.onTap,
        onHighlightChanged: _handleHighlightChanged,
        child: AnimatedScale(
          scale: _isPressed ? widget.pressedScale : 1.0,
          duration: widget.duration,
          curve: Curves.easeOut,
          child: AnimatedOpacity(
            opacity: _isPressed ? 0.9 : 1.0,
            duration: widget.duration,
            curve: Curves.easeOut,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
