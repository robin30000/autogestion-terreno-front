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
                  color: Colors.blueGrey,
                )))
      ],
    );
  }

  /* return Scaffold(
        body: GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Expanded(
          child: Stack(children: [
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: 'Search',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TutorialGpon()),
            );
          },
        ),
        TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TutorialGpon()),
              );
            },
            child: const Text(
              'Soporte GPON (Ver video)',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            )),
      ])),
    )); */

}
