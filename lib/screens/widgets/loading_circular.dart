import 'package:flutter/material.dart';

class LoadingCircular extends StatelessWidget {
  final double size;

  final Color? color;

  const LoadingCircular({
    super.key,
    this.size = 20,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: color ?? Theme.of(context).colorScheme.surface,
      ),
    );
  }
}