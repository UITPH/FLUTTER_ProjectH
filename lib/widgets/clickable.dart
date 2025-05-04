import 'package:flutter/material.dart';

class Clickable extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final VoidCallback? onSecondaryLongPress;
  final VoidCallback? onSecondaryTap;

  const Clickable({
    required this.child,
    required this.onTap,
    this.onSecondaryTap,
    this.onSecondaryLongPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        onSecondaryTap: onSecondaryTap,
        onSecondaryLongPress: onSecondaryLongPress,
        child: child,
      ),
    );
  }
}
