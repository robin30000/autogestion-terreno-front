import 'package:autogestion_tecnico/global/custom_show_dialog.dart';
import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/models/models.dart';
import 'package:autogestion_tecnico/providers/providers.dart';
import 'package:autogestion_tecnico/services/services.dart';
import 'package:autogestion_tecnico/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConsultaGponPage extends StatefulWidget {
  const ConsultaGponPage({super.key});

  @override
  State<ConsultaGponPage> createState() => _ConsultaGponPageState();
}

class _ConsultaGponPageState extends State<ConsultaGponPage> {
  final GlobalKey<FormState> _formKeyCodInc = GlobalKey<FormState>();

  TextEditingController tareaController = TextEditingController();

  //String codIncRes = '';
  List<GPON> data = [];
  String gponRes = '';
  //final int _count = 0;

  @override
  void dispose() {
    tareaController.dispose();
    if (_formKeyCodInc.currentState != null) {
      _formKeyCodInc.currentState!.dispose();
    }

    data = [];
    gponRes = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final uiProvider = Provider.of<UiProvider>(context);
    final consultaGponService = Provider.of<ConsultaGponService>(context);

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
                            'Consulta Contingencia',
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
                        CustomField(
                            controller: tareaController,
                            hintText: 'Tarea*',
                            icon: Icons.pin_outlined),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        CustomButton(
                          mq: mq,
                          function: consultaGponService.isLoading
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

                                  final resp = await consultaGponService
                                      .consultaContingencia(
                                          tarea: tareaController.text);

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
                                      setState(() {
                                        gponRes = resp[0]['message'];
                                      });
                                    }
                                  }
                                  data = consultaGponService.gpon;
                                },
                          color: consultaGponService.isLoading
                              ? greyColor
                              : blueColor,
                          colorText: whiteColor,
                          text: consultaGponService.isLoading
                              ? 'Obteniendo datos...'
                              : 'Consultar',
                          height: 0.05,
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        if (data.isEmpty)
                          gponRes == ''
                              ? Container()
                              : Center(
                                  child: Text(gponRes),
                                )
                        else
                          //99995290580
                          SizedBox(
                            //width: mq.width * 0.90,
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
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const FittedBox(
                                                child: Text('Tarea:',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ))),
                                            FittedBox(
                                                child: Text(data[i].pedido,
                                                    style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 12))),
                                            const FittedBox(
                                                child: Text('Hora Ingreso:',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ))),
                                            FittedBox(
                                                child: Text(data[i].horagestion,
                                                    style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 12))),
                                            const FittedBox(
                                                child: Text('Hora Gestion:',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ))),
                                            FittedBox(
                                                child: Text(
                                                    data[i].horacontingencia,
                                                    style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 12))),
                                            const FittedBox(
                                                child: Text('Estado',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ))),
                                            FittedBox(
                                                child: Text(data[i].finalizado,
                                                    style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 12))),
                                            const FittedBox(
                                                child: Text('Observacion:',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ))),
                                            Text(
                                              data[i].observacion,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                            Container(height: 2),
                                            const Divider(
                                                thickness: 2,
                                                color: Colors.black),
                                            Container(height: 2),
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
      floatingActionButton: FloatingActionButton.small(
        //tareaController.text = '';
        onPressed: () {
          setState(() {
            tareaController.text = '';
            data.clear();
          });
        },

        backgroundColor: const Color.fromARGB(255, 0, 51, 94),
        child: const Icon(Icons.restore_from_trash_rounded),
      ),
    );
  }
}
