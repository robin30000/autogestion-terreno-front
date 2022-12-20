import 'package:flutter/material.dart';


class CustomCheckBox extends StatelessWidget {

  final bool isSelected;
  final String label;
  final ValueChanged<bool> onChanged;
  
  const CustomCheckBox({
    super.key,
    required this.isSelected,
    required this.label,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isSelected,
          onChanged: (bool? newValue) {
            onChanged(newValue!);
          },
        ),
        Text(label),
      ],
    );
  }
}