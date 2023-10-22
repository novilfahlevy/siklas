import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const Tag({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8)
      ),
      child: Text(label, style: TextStyle(color: textColor),),
    );
  }
}