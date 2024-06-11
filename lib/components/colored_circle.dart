
import 'package:flutter/material.dart';

class ColoredCircle extends StatelessWidget{
  final Color color;
  
  const ColoredCircle({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15,
      height: 15,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}