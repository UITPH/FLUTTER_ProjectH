import 'package:flutter/material.dart';

class TopNaviChild extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isSelected;

  const TopNaviChild({
    super.key,
    required this.text,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : null,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 20,
                color: isSelected ? Colors.black : Colors.white54,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
