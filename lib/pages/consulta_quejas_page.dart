import 'package:autogestion_tecnico/global/custom_show_dialog.dart';
import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/models/models.dart';
import 'package:autogestion_tecnico/providers/providers.dart';
import 'package:autogestion_tecnico/services/services.dart';
import 'package:autogestion_tecnico/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class ConsultaQuejasPage extends StatefulWidget {
  const ConsultaQuejasPage({super.key});

  @override
  State<ConsultaQuejasPage> createState() => _ConsultaQuejasPageState();
}

class _ConsultaQuejasPageState extends State<ConsultaQuejasPage> {
  final GlobalKey<FormState> _formKeyCodInc = GlobalKey<FormState>();

  TextEditingController tareaController = TextEditingController();

  //String codIncRes = '';
  List<QUEJAS> data = [];
  String quejaRes = '';

  @override
  void dispose() {
    tareaController.dispose();
    if (_formKeyCodInc.currentState != null) {
      _formKeyCodInc.currentState!.dispose();
    }

    data = [];
    quejaRes = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final uiProvider = Provider.of<UiProvider>(context);
    final consultaQuejaService = Provider.of<ConsultaQuejasService>(context);

    final textController = TextEditingController();

    final outLineInputBorder = UnderlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent),
        borderRadius: BorderRadius.circular(5));

    const storage = FlutterSecureStorage();

    final inputDecoration = InputDecoration(
      hintText: 'Ingresar observaciones',
      enabledBorder: outLineInputBorder,
      focusedBorder: outLineInputBorder,
      filled: true,
      suffixIcon: IconButton(
          icon: const Icon(Icons.send),
          color: const Color.fromARGB(255, 0, 51, 94),
          onPressed: () async {
            final textValue = textController.value.text;

            if (textValue == '') {
              CustomShowDialog.alert(
                context: context,
                title: 'Error',
                message: 'Debes agregar una observación',
              );

              return;
            } else {
              final identificacion = await storage.read(key: 'identificacion');
              final nombre = await storage.read(key: 'nombre');
              final Map? resp = await consultaQuejaService.postQuejaGo(
                  observacion: textValue,
                  data: data,
                  identificacion: identificacion,
                  nombre: nombre);
              if (resp!['type'] == 'errorAuth') {
                if (resp == 'OK') {
                  uiProvider.selectedMenuOpt = 0;
                  uiProvider.selectedMenuName = 'Autogestión Terreno';
                  Navigator.pushReplacementNamed(context, 'login');
                }

                return;
              }

              if (resp['type'] == 'error') {
                CustomShowDialog.alert(
                    context: context, title: 'Error', message: resp['message']);
                return;
              } else {
                CustomShowDialog.alert(
                    context: context,
                    title: 'Excelente',
                    message: resp['message']);

                //textValue = '';
              }
            }
          }),
    );

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
                        top: mq.height * 0.05),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomField(
                              controller: tareaController,
                              hintText: 'Numero de SS',
                              icon: Icons.pin_outlined),
                          SizedBox(
                            height: mq.height * 0.02,
                          ),
                          CustomButton(
                            mq: mq,
                            function: consultaQuejaService.isLoading
                                ? null
                                : () async {
                                    FocusScope.of(context).unfocus();
                                    final authService =
                                        Provider.of<AuthService>(context,
                                            listen: false);

                                    final resp = await consultaQuejaService
                                        .getQueja(pedido: tareaController.text);

                                    if (tareaController.text == '') {
                                      CustomShowDialog.alert(
                                          context: context,
                                          title: 'Error',
                                          message:
                                              'Debes de diligenciar los campos obligatorios.');
                                      return false;
                                    }

                                    if (resp != null) {
                                      if (resp[0]['type'] == 'errorAuth') {
                                        final String resp =
                                            await authService.logout();

                                        if (resp == 'OK') {
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
                                        setState(() {
                                          quejaRes = resp[0]['message'];
                                        });
                                      }
                                    }
                                    data = consultaQuejaService.quejas;
                                  },
                            color: consultaQuejaService.isLoading
                                ? greyColor
                                : blueColor,
                            colorText: whiteColor,
                            text: consultaQuejaService.isLoading
                                ? 'Obteniendo datos...'
                                : 'Consultar',
                            height: 0.05,
                          ),
                          CustomDivider(mq: mq, colors: [
                            whiteColor,
                            blueColor,
                            whiteColor,
                          ]),
                          if (data.isEmpty)
                            quejaRes == ''
                                ? Container()
                                : Center(
                                    child: Text(quejaRes),
                                  )
                          else
                            TextFormField(
                                //focusNode: focusNode,
                                //FocusScope.of(context).unfocus();
                                controller: textController,
                                decoration: inputDecoration,
                                onFieldSubmitted: ((value) {
                                  textController.clear();
                                  //focusNode.requestFocus();
                                })),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: mq.width * 0.90,
                            height: mq.height * 300,
                            child: ListView.separated(
                              itemCount: data.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  height: mq.height * 0.03,
                                );
                              },
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  width: mq.width,
                                  height: mq.height * 500,
                                  padding: EdgeInsets.only(
                                      left: mq.width * 0.03,
                                      right: mq.width * 0.03,
                                      top: mq.width * 0.03,
                                      bottom: mq.width * 0.03),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: mq.width * 0.01),
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 15,
                                          offset: Offset(3, 2),
                                          spreadRadius: -5),
                                    ],
                                    borderRadius: BorderRadius.circular(
                                      20.0,
                                    ),
                                  ),
                                  child: Column(children: [
                                    for (int i = 0; i < data.length; i++)
                                      Container(
                                        width: mq.width * 0.90,
                                        padding: EdgeInsets.only(
                                            left: mq.width * 0.03),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const FittedBox(
                                                child: Text('SS:',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ))),
                                            FittedBox(
                                                child: Text(data[i].SS,
                                                    style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 12))),
                                            const FittedBox(
                                                child: Text('Nombre Cuenta:',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ))),
                                            FittedBox(
                                                child: Text(
                                                    data[i].NOMBRE_CUENTA,
                                                    style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 12))),
                                            const FittedBox(
                                                child: Text('Identificacion',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ))),
                                            FittedBox(
                                                child: Text(
                                                    data[i].IDENTIFICACION,
                                                    style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 12))),
                                            const FittedBox(
                                                child: Text('Celular:',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ))),
                                            Text(
                                              data[i].CELULAR,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                            const FittedBox(
                                                child: Text('Fijo:',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ))),
                                            FittedBox(
                                                child: Text(data[i].FIJO,
                                                    style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 12))),
                                            Container(height: 2),
                                            const FittedBox(
                                                child: Text('Dirección:',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ))),
                                            FittedBox(
                                                child: Text(data[i].DIRECCION,
                                                    style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 12))),
                                            Container(height: 2),
                                            const FittedBox(
                                                child: Text('Descripcion:',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ))),
                                            Text(
                                              data[i].DESCRIPCION,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ]),
                                );
                              },
                            ),
                          ),
                        ]),
                  ),
                ))),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomButtom(
              icon: Icons.refresh_rounded,
              onPressed: () {
                setState(() {
                  tareaController.text = '';
                  data.clear();
                });
              },
              heroTag: 'Limpiar',
            ),
            CustomButtom(
              icon: Icons.list_rounded,
              onPressed: () {
                setState(() {
                  uiProvider.selectedMenuOpt = 10;
                  uiProvider.selectedMenuName = 'Lista QuejasGo';
                });
              },
              heroTag: 'ListQueja',
            ),
          ],
        ));
  }
}
