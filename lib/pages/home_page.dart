import 'package:autogestion_tecnico/global/custom_show_dialog.dart';
import 'package:autogestion_tecnico/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
    authService.getCelularTecnico();

    return Center(
      child: FutureBuilder(
        future: authService.readAllData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data['alert'] == 'si') {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext dialogContext) {
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
                            Navigator.of(dialogContext).pop();
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

          if (snapshot.data['alertCel'] == 'si') {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext dialogContext) {
                  return PhoneNumberUpdateDialog(
                    authService: authService,
                    parentContext:
                        context, // Pasar el contexto del widget padre
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
            ],
          );
        },
      ),
    );
  }
}

class PhoneNumberUpdateDialog extends StatefulWidget {
  final AuthService authService;
  final BuildContext parentContext; // Añadir el contexto del widget padre

  const PhoneNumberUpdateDialog({
    Key? key,
    required this.authService,
    required this.parentContext,
  }) : super(key: key);

  @override
  _PhoneNumberUpdateDialogState createState() =>
      _PhoneNumberUpdateDialogState();
}

class _PhoneNumberUpdateDialogState extends State<PhoneNumberUpdateDialog> {
  String newPhoneNumber = '';
  bool isButtonEnabled = false;
  String errorMessage = '';

  void _validatePhoneNumber(String value) {
    setState(() {
      newPhoneNumber = value;
      if (newPhoneNumber.isEmpty ||
          !newPhoneNumber.startsWith('3') ||
          newPhoneNumber.length != 10) {
        isButtonEnabled = false;
        if (!newPhoneNumber.startsWith('3')) {
          errorMessage = 'El número debe iniciar con 3.';
        } else if (newPhoneNumber.length != 10) {
          errorMessage = 'El número debe tener 10 dígitos.';
        } else {
          errorMessage = 'Número inválido.';
        }
      } else {
        isButtonEnabled = true;
        errorMessage = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
          'Estamos actualizando tus datos! por favor recuérdanos tu numero de contacto, gracias',
          style: TextStyle(fontSize: 18)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: _validatePhoneNumber,
            decoration: InputDecoration(
              labelText: 'Número de celular',
              errorText: errorMessage.isEmpty ? null : errorMessage,
            ),
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: isButtonEnabled
                ? () async {
                    try {
                      Navigator.of(context).pop();
                      var response = await widget.authService
                          .guardaCelTecnico(celular: newPhoneNumber);
                      print(response);
                      if (response!['type'] == 'error') {
                        CustomShowDialog.alert(
                          context: widget
                              .parentContext, // Usar el contexto del widget padre
                          title: 'Error',
                          message:
                              'Hubo un problema al guardar su número celular.',
                        );
                      } else {
                        CustomShowDialog.alert(
                          context: widget
                              .parentContext, // Usar el contexto del widget padre
                          title: 'Excelente',
                          message: 'Su número celular se guardó correctamente.',
                        );
                      }
                    } catch (error) {
                      CustomShowDialog.alert(
                        context: widget
                            .parentContext, // Usar el contexto del widget padre
                        title: 'Excelente',
                        message: 'Su número celular se guardó correctamente.',
                      );
                    }
                  }
                : null,
            child: Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
