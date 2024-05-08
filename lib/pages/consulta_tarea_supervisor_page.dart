import 'package:autogestion_tecnico/global/custom_show_dialog.dart';
import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/models/models.dart';
import 'package:autogestion_tecnico/providers/providers.dart';
import 'package:autogestion_tecnico/services/services.dart';
import 'package:autogestion_tecnico/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConsultaTareaSupervisorPage extends StatefulWidget {
  const ConsultaTareaSupervisorPage({super.key});

  @override
  State<ConsultaTareaSupervisorPage> createState() =>
      _ConsultaTareaSupervisorPageState();
}

class _ConsultaTareaSupervisorPageState
    extends State<ConsultaTareaSupervisorPage> {
  final GlobalKey<FormState> _formKeyCodInc = GlobalKey<FormState>();

  TextEditingController tareaController = TextEditingController();

  //String codIncRes = '';
  List<TAREASUPER> data = [];
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
    final consultaTareaSuperService =
        Provider.of<ConsultaTareaSuperService>(context);

    //final textController = TextEditingController();

    final authServices = Provider.of<AuthService>(context, listen: false);
    authServices.getMenuApp();

    return Scaffold(
        body: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Form(
                key: _formKeyCodInc,
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: mq.width,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(
                                top: mq.height * 0.01,
                                bottom: 0,
                                left: mq.width * 0.10,
                                right: mq.width * 0.10),
                            child: Text(
                              'Consultar Tarea',
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
                              hintText: 'Tarea',
                              icon: Icons.pin_outlined),
                          SizedBox(
                            height: mq.height * 0.02,
                          ),
                          CustomButton(
                            mq: mq,
                            function: consultaTareaSuperService.isLoading
                                ? null
                                : () async {
                                    FocusScope.of(context).unfocus();
                                    final authService =
                                        Provider.of<AuthService>(context,
                                            listen: false);

                                    final resp = await consultaTareaSuperService
                                        .getTareaSuper(
                                            tarea: tareaController.text);

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
                                    data = consultaTareaSuperService.tareas;
                                    print(data);
                                  },
                            color: consultaTareaSuperService.isLoading
                                ? greyColor
                                : blueColor,
                            colorText: whiteColor,
                            text: consultaTareaSuperService.isLoading
                                ? 'Obteniendo datos...'
                                : 'Consultar',
                            height: 0.05,
                          ),
                          if (data.isEmpty)
                            quejaRes == ''
                                ? Container()
                                : const Center(
                                    //child: Text(quejaRes),
                                    )
                          else
                            // TextFormField(
                            //     controller: textController,
                            //     onFieldSubmitted: ((value) {
                            //       textController.clear();
                            //     })),
                            const SizedBox(
                              height: 10,
                            ),
                          SizedBox(
                            width: mq.width * 100,
                            height: mq.height * 0.6,
                            child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                //TAREASUPER tarea = data[index];
                                return Container(
                                  width: mq.width,
                                  padding: EdgeInsets.all(mq.width * 0.03),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: mq.width * 0.01),
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 15,
                                        offset: Offset(3, 2),
                                        spreadRadius: -5,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('MODULO: ${data[index].modulo}'),
                                      const SizedBox(
                                        height: 1,
                                      ),
                                      Text(
                                          'HORA INGRESO: ${data[index].fecha_ingreso}'),
                                      const SizedBox(
                                        height: 1,
                                      ),
                                      Text(
                                          'HORA GESTIÓN: ${data[index].fecha_fin}'),
                                      const SizedBox(
                                        height: 1,
                                      ),
                                      Text('ESTADO: ${data[index].gestion}'),
                                      const SizedBox(
                                        height: 1,
                                      ),
                                      Text(
                                          'LOGIN GESTIÓN: ${data[index].logincontingencia}'),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                          'OBSERVACIÓN TERRENO: ${data[index].observacion}'),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                          'OBSERVACIÓN ASESOR: ${data[index].observacion_asesor}'),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          // SizedBox(
                          //   width: mq.width * 0.90,
                          //   height: mq.height * 300,
                          //   child: ListView.separated(
                          //     itemCount: data.length,
                          //     separatorBuilder:
                          //         (BuildContext context, int index) {
                          //       return SizedBox(
                          //         height: mq.height * 0.03,
                          //       );
                          //     },
                          //     itemBuilder: (BuildContext context, int index) {
                          //       return Container(
                          //         width: mq.width,
                          //         height: mq.height * 500,
                          //         padding: EdgeInsets.only(
                          //             left: mq.width * 0.03,
                          //             right: mq.width * 0.03,
                          //             top: mq.width * 0.03,
                          //             bottom: mq.width * 0.03),
                          //         margin: EdgeInsets.symmetric(
                          //             horizontal: mq.width * 0.01),
                          //         decoration: BoxDecoration(
                          //           color: whiteColor,
                          //           boxShadow: const [
                          //             BoxShadow(
                          //                 color: Colors.black26,
                          //                 blurRadius: 15,
                          //                 offset: Offset(3, 2),
                          //                 spreadRadius: -5),
                          //           ],
                          //           borderRadius: BorderRadius.circular(
                          //             20.0,
                          //           ),
                          //         ),
                          //         child: Column(
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.start,
                          //           children: [
                          //             Text('Módulo: ${data[index].modulo}'),
                          //             Text(
                          //                 'Hora ingreso: ${data[index].modulo}'),
                          //             Text(
                          //                 'Hora gestión: ${data[index].modulo}'),
                          //             Text('Estado: ${data[index].modulo}'),
                          //             Text(
                          //                 'Observación terreno: ${data[index].observacion}'),
                          //             Text(
                          //                 'Observación asesor: ${data[index].observacion_asesor}'),
                          //           ],
                          //         ),
                          //         // child: Column(children: [
                          //         //   for (int i = 0; i < data.length; i++)
                          //         //     Container()
                          //         // ]),
                          //       );
                          //     },
                          //   ),
                          // ),
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
            )
          ],
        ));
  }
}
