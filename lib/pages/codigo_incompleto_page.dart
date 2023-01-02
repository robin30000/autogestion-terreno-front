import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:autogestion_tecnico/providers/providers.dart';
import 'package:autogestion_tecnico/services/services.dart';
import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/global/custom_show_dialog.dart';
import 'package:autogestion_tecnico/widgets/widgets.dart';

class CodigoIncompletoPage extends StatefulWidget {
  const CodigoIncompletoPage({super.key});

  @override
  State<CodigoIncompletoPage> createState() => _CodigoIncompletoPageState();
}

class _CodigoIncompletoPageState extends State<CodigoIncompletoPage> {
  final GlobalKey<FormState> _formKeyCodInc = GlobalKey<FormState>();

  TextEditingController tareaController = TextEditingController();

  String codIncRes = '';

  @override
  void dispose() {
    tareaController.dispose();
    if (_formKeyCodInc.currentState != null)
      _formKeyCodInc.currentState!.dispose();
    codIncRes = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final uiProvider = Provider.of<UiProvider>(context);
    final codigoIncompletoService =
        Provider.of<CodigoIncompletoService>(context);

    final authServices = Provider.of<AuthService>(context, listen: false);
    authServices.getMenuApp();

    return Scaffold(
      body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Form(
              key: _formKeyCodInc,
              child: SingleChildScrollView(
                child: Container(
                  width: mq.width,
                  padding: EdgeInsets.only(
                      left: mq.width * 0.05,
                      right: mq.width * 0.05,
                      top: mq.height * 0.25),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomField(
                            controller: tareaController,
                            hintText: 'Tarea*',
                            icon: Icons.pin_outlined),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        CustomButton(
                          mq: mq,
                          function: codigoIncompletoService.isLoading
                              ? null
                              : () async {
                                  FocusScope.of(context).unfocus();

                                  final authService = Provider.of<AuthService>(
                                      context,
                                      listen: false);

                                  if (tareaController.text == '') {
                                    CustomShowDialog.alert(
                                        context: context,
                                        title: 'Error',
                                        message:
                                            'Debes de diligenciar los campos obligatorios.');
                                    return false;
                                  }

                                  final resp = await codigoIncompletoService
                                      .getCodigoIncompleto(
                                          tarea: tareaController.text);

                                  if (resp![0]['type'] == 'errorAuth') {
                                    final String respauth =
                                        await authService.logout();

                                    if (respauth == 'OK') {
                                      uiProvider.selectedMenuOpt = 0;
                                      uiProvider.selectedMenuName =
                                          'Autogestión Terreno';
                                      Navigator.pushReplacementNamed(
                                          context, 'login');
                                    }

                                    return false;
                                  }

                                  if (resp[0]['type'] == 'error') {
                                    CustomShowDialog.alert(
                                        context: context,
                                        title: 'Error',
                                        message: resp[0]['message']);
                                    return false;
                                  }

                                  codIncRes = resp[0]['message'];
                                },
                          color: codigoIncompletoService.isLoading
                              ? greyColor
                              : blueColor,
                          colorText: whiteColor,
                          text: codigoIncompletoService.isLoading
                              ? 'Obteniendo código...'
                              : 'Obtener código',
                          height: 0.05,
                        ),
                        CustomDivider(mq: mq, colors: [
                          whiteColor,
                          blueColor,
                          whiteColor,
                        ]),
                        codIncRes == ''
                            ? Container()
                            : const Text('Su código de incompleto es:'),
                        Text(
                          codIncRes,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: mq.width * 0.08),
                        )
                      ]),
                ),
              ))),
    );
  }
}
