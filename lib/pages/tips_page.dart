import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/pages/tutorial/tutorial_gpon.dart';
import 'package:autogestion_tecnico/services/services.dart';
import 'package:autogestion_tecnico/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class TipsPage extends StatelessWidget {
  const TipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthService>(context, listen: false);
    final mq = MediaQuery.of(context).size;
    authServices.getMenuApp();

    return Scaffold(
      body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: SingleChildScrollView(
              child: Column(children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  top: mq.height * 0.01,
                  bottom: 0,
                  left: mq.width * 0.10,
                  right: mq.width * 0.10),
              child: Text(
                'Guía y explicaciones',
                style: TextStyle(
                  color: blueColor,
                  fontWeight: FontWeight.w500,
                  fontSize: mq.width * 0.06,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            CustomDivider(mq: mq, colors: [
              whiteColor,
              blueColor,
              whiteColor,
            ]),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VideoPlayerScreen()),
                  );
                },
                child: const Text(
                  'Soporte GPON (Ver video)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 51, 94),
                  ),
                  textAlign: TextAlign.left,
                ))
          ]))),
    );

    /* return Column(
      
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
    ); */
  }
}
