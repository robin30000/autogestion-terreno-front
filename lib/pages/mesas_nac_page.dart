import 'package:autogestion_tecnico/global/custom_show_dialog.dart';
import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/providers/providers.dart';
import 'package:autogestion_tecnico/services/services.dart';
import 'package:autogestion_tecnico/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textfield_tags/textfield_tags.dart';

class MesasNacionalesPage extends StatefulWidget {
  const MesasNacionalesPage({super.key});

  @override
  State<MesasNacionalesPage> createState() => _MesasNacionalesPageState();
}

class _MesasNacionalesPageState extends State<MesasNacionalesPage> {
  final GlobalKey<FormState> _formKeySoporteGpon = GlobalKey<FormState>();

  TextEditingController tareaController = TextEditingController();
  TextEditingController detalleSolicitudController = TextEditingController();
  TextfieldTagsController macSaleController = TextfieldTagsController();
  TextfieldTagsController macEntraController = TextfieldTagsController();
  String accion1 = '';
  bool ata = false;

  int? soporte;
  void _updateSoporte(int value) {
    setState(() {
      soporte = value;
    });
  }

  @override
  void dispose() {
    tareaController.dispose();
    detalleSolicitudController.dispose();
    if (_formKeySoporteGpon.currentState != null) {
      _formKeySoporteGpon.currentState!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final uiProvider = Provider.of<UiProvider>(context);
    final mesasNacionalesService = Provider.of<MesasNacionalesService>(context);

    final authServices = Provider.of<AuthService>(context, listen: false);
    authServices.getMenuApp();

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SingleChildScrollView(
          child: Form(
            key: _formKeySoporteGpon,
            child: Column(children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                    top: mq.height * 0.01,
                    bottom: 0,
                    left: mq.width * 0.10,
                    right: mq.width * 0.10),
                child: Text(
                  'Operaciones Nacionales',
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05),
                child: Column(children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: CustomField(
                          controller: tareaController,
                          hintText: 'Tarea*',
                          icon: Icons.document_scanner_outlined,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () async {
                            try {
                              var response = await mesasNacionalesService
                                  .validaPedido(pedido: tareaController.text);
                              if (response!['type'] == 'error') {
                                CustomShowDialog.alert(
                                    context: context,
                                    title: 'Error',
                                    message: response['message']);
                              } else {
                                if (response['message'] == 'EDA') {
                                  _updateSoporte(1);
                                } else if (response['message'] == 'ELT-POE') {
                                  _updateSoporte(2);
                                } else if (response['message'] == 'PRE') {
                                  _updateSoporte(3);
                                } else if (response['message'] == 'DTH') {
                                  _updateSoporte(4);
                                } else if (response['message'] == 'BSC') {
                                  _updateSoporte(5);
                                }
                              }
                            } catch (error) {}
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: mq.height * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: mq.width * 0.00),
                    child: Column(children: [
                      if (soporte == 1) ...[
                        FutureBuilder(
                          future: mesasNacionalesService.getAccion1(),
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
                                value: accion1,
                                function: (value) async {
                                  //print(accion1);
                                  setState(() {
                                    accion1 = value!;
                                  });
                                  print(accion1);
                                  uiProvider.notifyListeners();
                                },
                                functionOnTap: () {
                                  accion1 = '';
                                  uiProvider.notifyListeners();
                                },
                                hintText: 'Accion*',
                                icon: Icons.table_restaurant_outlined);
                          },
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        CustomField(
                          controller: detalleSolicitudController,
                          hintText: 'Detalle de solicitud*',
                          icon: null,
                          minLines: 6,
                          maxLines: 6,
                          height: null,
                          paddingTop: 20,
                          paddingLeft: 20,
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        Visibility(
                          visible: accion1 == 'Cambio de equipo',
                          child: Column(
                            children: [
                              CustomTag(
                                mq: mq,
                                controller: macEntraController,
                                hintText: 'MAC Entra...*',
                                colorTag: blueColor,
                              ),
                              SizedBox(
                                height: mq.height * 0.02,
                              ),
                              CustomTag(
                                mq: mq,
                                controller: macSaleController,
                                hintText: 'MAC Sale...*',
                                colorTag: blueColor,
                              ),
                              SizedBox(
                                height: mq.height * 0.02,
                              ),
                            ],
                          ),
                        ),
                        CustomButton(
                          mq: mq,
                          function: mesasNacionalesService.isLoading
                              ? null
                              : () async {
                                  FocusScope.of(context).unfocus();

                                  if (tareaController.text == '' ||
                                      detalleSolicitudController.text == '' ||
                                      accion1 == '') {
                                    CustomShowDialog.alert(
                                        context: context,
                                        title: 'Error',
                                        message:
                                            'Debes de diligenciar los campos obligatorios.');
                                    return false;
                                  }

                                  String strAta = (ata) ? 'SI' : 'NO';

                                  final Map? resp = await mesasNacionalesService
                                      .postContingencia(
                                          tarea: tareaController.text,
                                          observacion:
                                              detalleSolicitudController.text,
                                          accion: accion1,
                                          ata: strAta);

                                  if (resp!['type'] == 'error') {
                                    CustomShowDialog.alert(
                                        context: context,
                                        title: 'Error',
                                        message: resp['message']);
                                    return false;
                                  } else {
                                    CustomShowDialog.alert(
                                        context: context,
                                        title: 'Excelente',
                                        message: resp['message']);

                                    await Future.delayed(
                                        const Duration(milliseconds: 500));

                                    uiProvider.selectedMenuOpt = 99;
                                    uiProvider.selectedMenuName = 'Soporte ETP';

                                    await Future.delayed(
                                        const Duration(seconds: 1));

                                    uiProvider.selectedMenuOpt = 20;
                                    uiProvider.selectedMenuName =
                                        'Operaciones Nacionales';
                                  }
                                },
                          color: mesasNacionalesService.isLoading
                              ? greyColor
                              : blueColor,
                          colorText: whiteColor,
                          text: mesasNacionalesService.isLoading
                              ? 'Cargando...'
                              : 'Enviar Solicitud',
                          height: 0.05,
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        )
                      ],
                      if (soporte == 2) ...[
                        FutureBuilder(
                          future: mesasNacionalesService.getAccion2(),
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
                                value: accion1,
                                function: (value) async {
                                  accion1 = value!;
                                  uiProvider.notifyListeners();
                                },
                                functionOnTap: () {
                                  accion1 = '';
                                  uiProvider.notifyListeners();
                                },
                                hintText: 'Accion*',
                                icon: Icons.wifi_find_sharp);
                          },
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        CustomField(
                          controller: detalleSolicitudController,
                          hintText: 'Detalle de solicitud*',
                          icon: null,
                          minLines: 6,
                          maxLines: 6,
                          height: null,
                          paddingTop: 20,
                          paddingLeft: 20,
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        CustomButton(
                          mq: mq,
                          function: mesasNacionalesService.isLoading
                              ? null
                              : () async {
                                  FocusScope.of(context).unfocus();

                                  if (tareaController.text == '' ||
                                      accion1 == '' ||
                                      detalleSolicitudController.text == '') {
                                    CustomShowDialog.alert(
                                        context: context,
                                        title: 'Error',
                                        message:
                                            'Debes de diligenciar los campos obligatorios.');
                                    return false;
                                  }

                                  String strAta = (ata) ? 'SI' : 'NO';

                                  final Map? resp = await mesasNacionalesService
                                      .postContingencia(
                                          tarea: tareaController.text,
                                          observacion:
                                              detalleSolicitudController.text,
                                          accion: accion1,
                                          ata: strAta);

                                  if (resp!['type'] == 'error') {
                                    CustomShowDialog.alert(
                                        context: context,
                                        title: 'Error',
                                        message: resp['message']);
                                    return false;
                                  } else {
                                    CustomShowDialog.alert(
                                        context: context,
                                        title: 'Excelente',
                                        message: resp['message']);

                                    await Future.delayed(
                                        const Duration(milliseconds: 500));

                                    uiProvider.selectedMenuOpt = 99;
                                    uiProvider.selectedMenuName = 'Soporte ETP';

                                    await Future.delayed(
                                        const Duration(seconds: 1));

                                    uiProvider.selectedMenuOpt = 20;
                                    uiProvider.selectedMenuName = 'Soporte ETP';
                                  }
                                },
                          color: mesasNacionalesService.isLoading
                              ? greyColor
                              : blueColor,
                          colorText: whiteColor,
                          text: mesasNacionalesService.isLoading
                              ? 'Cargando...'
                              : 'Enviar Solicitud',
                          height: 0.05,
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        )
                      ],
                      if (soporte == 3) ...[
                        CustomField(
                          controller: detalleSolicitudController,
                          hintText: 'Detalle de solicitud*',
                          icon: null,
                          minLines: 6,
                          maxLines: 6,
                          height: null,
                          paddingTop: 20,
                          paddingLeft: 20,
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        CustomButton(
                          mq: mq,
                          function: mesasNacionalesService.isLoading
                              ? null
                              : () async {
                                  FocusScope.of(context).unfocus();

                                  if (tareaController.text == '' ||
                                      detalleSolicitudController.text == '') {
                                    CustomShowDialog.alert(
                                        context: context,
                                        title: 'Error',
                                        message:
                                            'Debes de diligenciar los campos obligatorios.');
                                    return false;
                                  }

                                  String accion1 = 'Infraestructura';
                                  String strAta = (ata) ? 'SI' : 'NO';

                                  final Map? resp = await mesasNacionalesService
                                      .postContingencia(
                                          tarea: tareaController.text,
                                          observacion:
                                              detalleSolicitudController.text,
                                          accion: accion1,
                                          ata: strAta);

                                  if (resp!['type'] == 'error') {
                                    CustomShowDialog.alert(
                                        context: context,
                                        title: 'Error',
                                        message: resp['message']);
                                    return false;
                                  } else {
                                    CustomShowDialog.alert(
                                        context: context,
                                        title: 'Excelente',
                                        message: resp['message']);

                                    await Future.delayed(
                                        const Duration(milliseconds: 500));

                                    uiProvider.selectedMenuOpt = 99;
                                    uiProvider.selectedMenuName =
                                        'Operaciones Nacionales';

                                    await Future.delayed(
                                        const Duration(seconds: 1));

                                    uiProvider.selectedMenuOpt = 20;
                                    uiProvider.selectedMenuName =
                                        'Operaciones Nacionales';
                                  }
                                },
                          color: mesasNacionalesService.isLoading
                              ? greyColor
                              : blueColor,
                          colorText: whiteColor,
                          text: mesasNacionalesService.isLoading
                              ? 'Cargando...'
                              : 'Enviar Solicitud',
                          height: 0.05,
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        )
                      ],
                      if (soporte == 4) ...[
                        CustomField(
                          controller: detalleSolicitudController,
                          hintText: 'Detalle de solicitud*',
                          icon: null,
                          minLines: 6,
                          maxLines: 6,
                          height: null,
                          paddingTop: 20,
                          paddingLeft: 20,
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        CustomButton(
                          mq: mq,
                          function: mesasNacionalesService.isLoading
                              ? null
                              : () async {
                                  FocusScope.of(context).unfocus();

                                  if (tareaController.text == '' ||
                                      detalleSolicitudController.text == '') {
                                    CustomShowDialog.alert(
                                        context: context,
                                        title: 'Error',
                                        message:
                                            'Debes de diligenciar los campos obligatorios.');
                                    return false;
                                  }

                                  String strAta = (ata) ? 'SI' : 'NO';

                                  final Map? resp = await mesasNacionalesService
                                      .postContingencia(
                                    tarea: tareaController.text,
                                    observacion:
                                        detalleSolicitudController.text,
                                    accion: 'Cambio_Equipo DTH',
                                    ata: strAta,
                                  );

                                  if (resp!['type'] == 'error') {
                                    CustomShowDialog.alert(
                                        context: context,
                                        title: 'Error',
                                        message: resp['message']);
                                    return false;
                                  } else {
                                    CustomShowDialog.alert(
                                        context: context,
                                        title: 'Excelente',
                                        message: resp['message']);

                                    await Future.delayed(
                                        const Duration(milliseconds: 500));

                                    uiProvider.selectedMenuOpt = 99;
                                    uiProvider.selectedMenuName = 'Soporte ETP';

                                    await Future.delayed(
                                        const Duration(seconds: 1));

                                    uiProvider.selectedMenuOpt = 20;
                                    uiProvider.selectedMenuName = 'Soporte ETP';
                                  }
                                },
                          color: mesasNacionalesService.isLoading
                              ? greyColor
                              : blueColor,
                          colorText: whiteColor,
                          text: mesasNacionalesService.isLoading
                              ? 'Cargando...'
                              : 'Enviar Solicitud',
                          height: 0.05,
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        )
                      ],
                      if (soporte == 5) ...[
                        FutureBuilder(
                          future: mesasNacionalesService.getAccion2(),
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
                                value: accion1,
                                function: (value) async {
                                  accion1 = value!;
                                  uiProvider.notifyListeners();
                                },
                                functionOnTap: () {
                                  accion1 = '';
                                  uiProvider.notifyListeners();
                                },
                                hintText: 'Accion*',
                                icon: Icons.wifi_find_sharp);
                          },
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        CustomField(
                          controller: detalleSolicitudController,
                          hintText: 'Detalle de solicitud bsc*',
                          icon: null,
                          minLines: 6,
                          maxLines: 6,
                          height: null,
                          paddingTop: 20,
                          paddingLeft: 20,
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: ata,
                                  onChanged: (newValue) {
                                    setState(() {
                                      ata = newValue!;
                                    });
                                  },
                                ),
                                const Text('Es activacion de ATA?'),
                              ],
                            ),
                          ],
                        ),
                        CustomButton(
                          mq: mq,
                          function: mesasNacionalesService.isLoading
                              ? null
                              : () async {
                                  FocusScope.of(context).unfocus();

                                  if (tareaController.text == '' ||
                                      detalleSolicitudController.text == '' ||
                                      accion1 == '') {
                                    CustomShowDialog.alert(
                                        context: context,
                                        title: 'Error',
                                        message:
                                            'Debes de diligenciar los campos obligatorios.');
                                    return false;
                                  }

                                  String strAta = (ata) ? 'SI' : 'NO';

                                  final Map? resp = await mesasNacionalesService
                                      .postContingencia(
                                          tarea: tareaController.text,
                                          observacion:
                                              detalleSolicitudController.text,
                                          accion: accion1,
                                          ata: strAta);

                                  if (resp!['type'] == 'error') {
                                    CustomShowDialog.alert(
                                        context: context,
                                        title: 'Error',
                                        message: resp['message']);
                                    return false;
                                  } else {
                                    CustomShowDialog.alert(
                                        context: context,
                                        title: 'Excelente',
                                        message: resp['message']);

                                    await Future.delayed(
                                        const Duration(milliseconds: 500));

                                    uiProvider.selectedMenuOpt = 99;
                                    uiProvider.selectedMenuName = 'Soporte ETP';

                                    await Future.delayed(
                                        const Duration(seconds: 1));

                                    uiProvider.selectedMenuOpt = 20;
                                    uiProvider.selectedMenuName = 'Soporte ETP';
                                  }
                                },
                          color: mesasNacionalesService.isLoading
                              ? greyColor
                              : blueColor,
                          colorText: whiteColor,
                          text: mesasNacionalesService.isLoading
                              ? 'Cargando...'
                              : 'Enviar Solicitud',
                          height: 0.05,
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        )
                      ],
                    ]),
                  )
                ]),
              )
            ]),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomButtom(
            icon: Icons.refresh_rounded,
            onPressed: () {
              setState(() {
                tareaController.text = '';
                detalleSolicitudController.text = '';
                soporte = 0;
              });
            },
            heroTag: 'Limpiar',
          ),
          CustomButtom(
            icon: Icons.list_rounded,
            onPressed: () {
              setState(() {
                uiProvider.selectedMenuOpt = 21;
                uiProvider.selectedMenuName = 'Lista Soporte Mesas Nacionales';
              });
            },
            heroTag: 'listCon',
          ),
        ],
      ),
    );
  }
}
