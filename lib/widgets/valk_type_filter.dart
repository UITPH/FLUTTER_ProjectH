import 'package:flutter/material.dart';

class ValkTypeFilter extends StatelessWidget {
  final String imageName;
  final VoidCallback onTap;
  final bool isSelected;

  const ValkTypeFilter({
    super.key,
    required this.imageName,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.black54,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(scale: 2, 'lib/assets/images/types&dame/$imageName'),
      ),
    );
  }
}
