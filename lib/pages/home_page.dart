import 'package:autogestion_tecnico/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final mq = MediaQuery.of(context).size;

    Future<void> _launchInBrowser(Uri url) async {
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      )) {
        throw Exception('Could not launch $url');
      }
    }

    authService.getMenuApp();
    authService.getEncuesta();

    return Center(
      child: FutureBuilder(
        future: authService.readAllData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot);
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data['alert'] == 'si') {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                barrierDismissible:
                    false, // Evita que el modal se cierre al tocar fuera de él
                builder: (BuildContext context) {
                  return AlertDialog(
                    title:
                        const Text('Por favor realiza la siguiente encuesta'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Haz clic en el enlace para completar la encuesta.',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            authService.validaEncuesta();
                            await _launchInBrowser(Uri.parse(
                              'https://forms.office.com/pages/responsepage.aspx?id=_TkAZSpx4U-4Y4YQPEJcF75PHT7gAhpPpZdF6l0mEvNUNjdQVzZET0FWTlNVTEc3V0NQUkJTS1NNSS4u',
                            ));
                          },
                          child: const Text('Ir a la encuesta'),
                        ),
                      ],
                    ),
                  );
                },
              );
            });
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
                style: TextStyle(fontSize: mq.width * 0.10),
                textAlign: TextAlign.center,
              ),
              if (snapshot.data['nombre'] != null)
                Text(
                  snapshot.data['nombre'],
                  style: TextStyle(fontSize: mq.width * 0.06),
                  textAlign: TextAlign.center,
                ),

              // Text(
              //   snapshot.data['nombre'],
              //   style: TextStyle(fontSize: mq.width * 0.06),
              //   textAlign: TextAlign.center,
              // ),
            ],
          );
        },
      ),
    );
  }
}
