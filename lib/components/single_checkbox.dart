import 'package:flutter/material.dart';

class SingleGenreCheckbox extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SingleGenreCheckbox({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(value: isSelected, onChanged: (_) => onTap()),
          Text(label),
        ],
      ),
    );
  }
}
