import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String heroTag; // Agrega el parámetro heroTag aquí

  const CustomButtom({
    super.key,
    required this.icon,
    this.onPressed,
    required this.heroTag, // Agrega el parámetro heroTag aquí
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      shape: const StadiumBorder(),
      onPressed: onPressed,
      backgroundColor: const Color.fromARGB(255, 0, 51, 94),
      heroTag: heroTag, // Usa el parámetro heroTag en el hero

      child: Icon(icon),
    );
  }
}
