import 'package:autogestion_tecnico/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import 'tutorial/tutorial_gpon.dart';

class TipsPage extends StatelessWidget {
  const TipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthService>(context, listen: false);

    authServices.getMenuApp();

    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VideoPlayerScreen()),
              );
            },
            child: const Text('Soporte GPON (Ver video)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 51, 94),
                )))
      ],
    );
  }
}
