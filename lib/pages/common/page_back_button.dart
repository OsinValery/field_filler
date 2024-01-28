import 'package:flutter/material.dart';

class PageBackButton extends StatelessWidget {
  const PageBackButton({super.key, required this.onPress});

  final void Function() onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPress(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 2, top: 16, left: 16, right: 16),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.withAlpha(100),
        ),
        child: const Icon(Icons.arrow_back, size: 24, color: Colors.white),
      ),
    );
  }
}
