import 'dart:ui';
import 'package:flutter/material.dart';

class GradientScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;

  const GradientScaffold({
    super.key,
    this.appBar,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.1, -0.5),
                radius: 0.8,
                colors: [
                  const Color(0xFF001C58).withOpacity(0.6),
                  const Color(0xFF0047FF),
                  const Color(0xFF001D5E),
                ],
                stops: const [0.2, 0.2, 1.0],
              ),
            ),
          ),

          // Second overlay gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  const Color(0xFF001C58).withOpacity(0.6),
                  const Color(0xFF007BFF).withOpacity(0.5),
                  const Color(0xFF001C58).withOpacity(0.6),
                ],
              ),
            ),
          ),

          // Blur layer
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
            child: Container(color: Colors.transparent),
          ),

          // Child content
          SafeArea(child: body),
        ],
      ),
    );
  }
}
