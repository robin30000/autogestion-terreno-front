import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/services/services.dart';
import 'package:autogestion_tecnico/pages/pages.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  bool tokenAuth = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () async {

      final authService = Provider.of<AuthService>(context, listen: false);

      String tokenAuth = await authService.readToken();

      if (tokenAuth == '') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          )
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MasterPage(),
          )
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: mq.width,
        height: mq.height,
        color: blueBlackColor,
        child: Center(
          child: Container(
            width: mq.width * 0.50,
            height: mq.width * 0.50,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img/logo-white.png")
              )
            )
          ),
        ),
      ),
    );
  }
}
