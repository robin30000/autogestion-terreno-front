import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const CustomButtom({
    Key? key,
    required this.icon,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      shape: const StadiumBorder(),
      onPressed: onPressed,
      backgroundColor: const Color.fromARGB(255, 0, 51, 94),
      child: Icon(icon),
    );
  }
}
