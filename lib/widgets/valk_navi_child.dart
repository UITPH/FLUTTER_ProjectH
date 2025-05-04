import 'package:flutter/material.dart';
import 'package:flutter_honkai/widgets/clickable.dart';

class ValkNaviChild extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool isSelected;

  const ValkNaviChild({
    super.key,
    required this.text,
    required this.onTap,
    required this.isSelected,
  });

  @override
  State<ValkNaviChild> createState() => _ValkNaviChildState();
}

class _ValkNaviChildState extends State<ValkNaviChild> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    bool onlyHover = isHover && !widget.isSelected;
    BoxDecoration decoration;
    if (widget.isSelected) {
      decoration = BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.lightBlue, Colors.lightBlueAccent],
        ),
        borderRadius: BorderRadius.circular(10),
      );
    } else if (onlyHover) {
      decoration = BoxDecoration(
        color: Colors.transparent,
        border: Border.all(width: 1, color: Colors.white),
        borderRadius: BorderRadius.circular(10),
      );
    } else {
      decoration = BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      );
    }
    return MouseRegion(
      onEnter:
          (event) => setState(() {
            isHover = true;
          }),
      onExit:
          (event) => setState(() {
            isHover = false;
          }),
      child: Clickable(
        onTap: widget.onTap,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            decoration: decoration,
            child: Center(
              child: Text(
                widget.text,
                style: TextStyle(
                  color: widget.isSelected ? Colors.white : Colors.white,
                  fontWeight:
                      widget.isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
