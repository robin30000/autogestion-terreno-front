import 'package:autogestion_tecnico/global/custom_show_dialog.dart';
import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/providers/providers.dart';
import 'package:autogestion_tecnico/services/services.dart';
import 'package:autogestion_tecnico/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CodigoIncompletoPage extends StatefulWidget {
  const CodigoIncompletoPage({super.key});

  @override
  State<CodigoIncompletoPage> createState() => _CodigoIncompletoPageState();
}

class _CodigoIncompletoPageState extends State<CodigoIncompletoPage> {
  final GlobalKey<FormState> _formKeyCodInc = GlobalKey<FormState>();

  TextEditingController tareaController = TextEditingController();

  String codIncRes = '';
  String tipoCodigo = '';
  String catCodigo = '';
  @override
  void dispose() {
    tareaController.dispose();
    if (_formKeyCodInc.currentState != null) {
      _formKeyCodInc.currentState!.dispose();
    }
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
                      left: mq.width * 0.00,
                      right: mq.width * 0.00,
                      top: mq.height * 0.01),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Solicitud códigos',
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
                        FutureBuilder(
                          future: codigoIncompletoService.getCategoriaCodigo(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return Column(
                                children: [
                                  Container(
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: const CircularProgressIndicator()),
                                ],
                              );
                            }

                            return CustomDropdown(
                                mq: mq,
                                options: snapshot.data,
                                value: catCodigo,
                                function: (value) async {
                                  catCodigo = value!;
                                  uiProvider.notifyListeners();
                                },
                                functionOnTap: () {
                                  catCodigo = '';

                                  uiProvider.notifyListeners();
                                },
                                hintText: 'Tipo código*',
                                icon: Icons.devices_outlined);
                          },
                        ),
                        if (catCodigo == 'Salesforce')
                          SizedBox(
                            height: mq.height * 0.02,
                          ),
                        if (catCodigo == 'Salesforce')
                          FutureBuilder(
                            future: codigoIncompletoService.getTipoCodigo(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (!snapshot.hasData) {
                                return Column(
                                  children: [
                                    Container(
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        child:
                                            const CircularProgressIndicator()),
                                  ],
                                );
                              }

                              return CustomDropdown(
                                  mq: mq,
                                  options: snapshot.data,
                                  value: tipoCodigo,
                                  function: (value) async {
                                    tipoCodigo = value!;
                                    uiProvider.notifyListeners();
                                  },
                                  functionOnTap: () {
                                    tipoCodigo = '';

                                    uiProvider.notifyListeners();
                                  },
                                  hintText: 'Tipo código*',
                                  icon: Icons.devices_fold);
                            },
                          ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
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

                                  if (tareaController.text == '' ||
                                      tipoCodigo == '') {
                                    CustomShowDialog.alert(
                                        context: context,
                                        title: 'Error',
                                        message:
                                            'Debes de diligenciar los campos obligatorios.');
                                    return false;
                                  }

                                  final resp = await codigoIncompletoService
                                      .getCodigoIncompleto(
                                          tarea: tareaController.text,
                                          tipoCodigo: tipoCodigo,
                                          catCodigo: catCodigo);

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
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        codIncRes == ''
                            ? Container()
                            : const Text('Su código es:'),
                        Text(
                          codIncRes,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: mq.width * 0.08),
                        )
                      ]),
                ),
              ))),
      floatingActionButton: FloatingActionButton.small(
        //tareaController.text = '';
        onPressed: () {
          setState(() {
            tareaController.text = '';
            tipoCodigo = '';
            codIncRes = '';
          });
        },

        backgroundColor: const Color.fromARGB(255, 0, 51, 94),
        child: const Icon(Icons.restore_from_trash_rounded),
      ),
    );
  }
}
