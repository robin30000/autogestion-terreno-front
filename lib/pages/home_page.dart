import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:autogestion_tecnico/services/services.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: false);
    final mq = MediaQuery.of(context).size;

    authService.getMenuApp();

    return Center(
      child: FutureBuilder(
        future: authService.readAllData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: const AssetImage('assets/img/phone-mockup.png'),
                width: mq.width * 0.60,
              ),
              Text(
                'Bienvenido',
                style: TextStyle(
                  fontSize: mq.width * 0.10
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                snapshot.data['nombre'],
                style: TextStyle(
                  fontSize: mq.width * 0.06
                ),
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
      
    );
  }
}