import 'package:flutter/material.dart';

class GlowingSendButtonWidget extends StatelessWidget {
  const GlowingSendButtonWidget({
    Key? key,
    required this.color,
    required this.icon,
    this.size = 54,
    required this.onPressed,
  }) : super(key: key);

  final Color color;
  final IconData icon;
  final double size;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            spreadRadius: 8,
            blurRadius: 24,
          ),
        ],
      ),
      child: ClipOval(
        child: Material(
          color: color,
          child: IconButton(
            icon: Icon(
              icon,
              size: 26,
              color: Colors.white,
            ),
            iconSize: size,
            onPressed: onPressed,
            splashColor: Colors.white.withOpacity(0.3),
            highlightColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
