import 'package:autogestion_tecnico/global/custom_show_dialog.dart';
import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/providers/providers.dart';
import 'package:autogestion_tecnico/services/services.dart';
import 'package:autogestion_tecnico/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:textfield_tags/textfield_tags.dart';

import '../widgets/qr.dart';

class ContingenciaPage extends StatefulWidget {
  const ContingenciaPage({super.key});

  @override
  State<ContingenciaPage> createState() => _ContingenciaPageState();
}

class _ContingenciaPageState extends State<ContingenciaPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController inputFieldController = TextEditingController();

  TextEditingController pedidoController = TextEditingController();
  TextEditingController detalleSolicitudController = TextEditingController();

  String tipoProducto = '';
  String tipoContingencia = '';

  TextfieldTagsController macEntraController = TextfieldTagsController();
  //TextfieldTagsController macSaleController = TextfieldTagsController();

  String data = '';
  final TextEditingController _controller =
      TextEditingController(); // controlador para TextFormField

  @override
  void dispose() {
    pedidoController.dispose();
    detalleSolicitudController.dispose();
    _controller.text = data; // inicializa el controlador con el valor de data

    if (_formKey.currentState != null) _formKey.currentState!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final uiProvider = Provider.of<UiProvider>(context);
    final contingenciasService = Provider.of<ContingenciaService>(context);

    final authServices = Provider.of<AuthService>(context, listen: false);
    authServices.getMenuApp();

    return Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      top: mq.height * 0.01,
                      bottom: 0,
                      left: mq.width * 0.10,
                      right: mq.width * 0.10),
                  child: Text(
                    'Formulario de solicitud de contingencias',
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
                    // Pedido
                    CustomField(
                      controller: pedidoController,
                      hintText: 'Pedido*',
                      icon: Icons.document_scanner_outlined,
                      width: 50.0,
                    ),

                    SizedBox(
                      height: mq.height * 0.02,
                    ),

                    // Tipo Producto
                    FutureBuilder(
                      future: contingenciasService.getTipoProducto(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                            value: tipoProducto,
                            function: (value) async {
                              tipoProducto = value!;
                              uiProvider.notifyListeners();
                            },
                            functionOnTap: () {
                              tipoProducto = '';
                              tipoContingencia = '';
                              uiProvider.notifyListeners();
                            },
                            hintText: 'Tipo de producto*',
                            icon: Icons.devices_outlined);
                      },
                    ),

                    SizedBox(
                      height: mq.height * 0.02,
                    ),

                    // Tipo Contingencia
                    tipoProducto == ''
                        ? CustomDropdown(
                            mq: mq,
                            options: const [
                              {
                                'name': 'Tipo de contingencia*',
                                'value': '',
                                'state': true
                              }
                            ],
                            value: '',
                            function: (value) async {},
                            hintText: 'Tipo de contingencia*',
                            icon: Icons.fire_truck_outlined)
                        : FutureBuilder(
                            future: contingenciasService.getTipoContingencia(
                                tipoProducto: tipoProducto),
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
                                  value: '',
                                  function: (value) {
                                    tipoContingencia = value!;
                                  },
                                  hintText: 'Tipo de contingencia*',
                                  icon: Icons.fire_truck_outlined);
                            },
                          ),

                    SizedBox(
                      height: mq.height * 0.02,
                    ),

                    // Detalle de solicitud
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

                    // MAC Entra
                    CustomTag(
                        mq: const Size(double.infinity, 900.0),
                        controller: macEntraController,
                        hintText: 'MAC Entra...*',
                        colorTag: blueColor),

                    //SizedBox(height: mq.height * 0.02,),

                    //CustomTag(mq: mq, controller: macSaleController, hintText: 'MAC Sale...', colorTag: blueColor),

                    SizedBox(
                      height: mq.height * 0.02,
                    ),

                    // Boton Enviar Solicitud
                    CustomButton(
                      mq: mq,
                      function: contingenciasService.isLoading
                          ? null
                          : () async {
                              final authService = Provider.of<AuthService>(
                                  context,
                                  listen: false);

                              FocusScope.of(context).unfocus();

                              if (pedidoController.text == '' ||
                                  detalleSolicitudController.text == '' ||
                                  tipoProducto == '' ||
                                  tipoProducto.isEmpty ||
                                  tipoContingencia == '' ||
                                  tipoContingencia.isEmpty) {
                                CustomShowDialog.alert(
                                    context: context,
                                    title: 'Error',
                                    message:
                                        'Debes de diligenciar los campos obligatorios.');
                                return false;
                              }

                              if (macEntraController.getTags!.isEmpty) {
                                CustomShowDialog.alert(
                                    context: context,
                                    title: 'Error',
                                    message: 'Mac entra es obligatorio.');
                                return false;
                              }

                              /* if (macSaleController.getTags!.isEmpty && tipoContingencia == 'Cambio de Equipo') {
                            CustomShowDialog.alert(context: context, title: 'Error', message: 'Mac sale es obligatorio.');
                            return false;
                          } */

                              pedidoController.text;
                              detalleSolicitudController.text;
                              tipoProducto;
                              tipoContingencia;
                              String macEntraFormat =
                                  macEntraController.getTags!.join('-');
                              //String macSaleFormat = macSaleController.getTags!.join('-');
                              String macSaleFormat = '';

                              final Map? resp =
                                  await contingenciasService.postContingencia(
                                pedido: pedidoController.text,
                                observacion: detalleSolicitudController.text,
                                tipoproducto: tipoProducto,
                                tipocontingencia: tipoContingencia,
                                macentra: macEntraFormat,
                                macsale: macSaleFormat,
                              );

                              if (resp!['type'] == 'errorAuth') {
                                final String resp = await authService.logout();

                                if (resp == 'OK') {
                                  uiProvider.selectedMenuOpt = 0;
                                  uiProvider.selectedMenuName =
                                      'Autogestión Terreno';
                                  Navigator.pushReplacementNamed(
                                      context, 'login');
                                }

                                return false;
                              }

                              if (resp['type'] == 'error') {
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
                                uiProvider.selectedMenuName = 'Contingencias';

                                await Future.delayed(
                                    const Duration(seconds: 1));

                                uiProvider.selectedMenuOpt = 1;
                                uiProvider.selectedMenuName = 'Contingencias';

                                /* pedidoController.clear();
                            pedidoController.text = '';
                            detalleSolicitudController.clear();
                            detalleSolicitudController.text = '';
                            tipoProducto = '';
                            tipoContingencia = '';
                            macEntraController.clearTags();
                            macSaleController.clearTags();

                            _formKey.currentState!.reset(); */

                              }
                            },
                      color: contingenciasService.isLoading
                          ? greyColor
                          : blueColor,
                      colorText: whiteColor,
                      text: contingenciasService.isLoading
                          ? 'Cargando...'
                          : 'Enviar Solicitud',
                      height: 0.05,
                    ),

                    SizedBox(
                      height: mq.height * 0.02,
                    ),
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
              icon: Icons.qr_code_scanner_outlined,
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => QRScanner(),
                ));
              },
              heroTag: 'scan',
            ),
            CustomButtom(
              icon: Icons.list_rounded,
              onPressed: () {
                setState(() {
                  uiProvider.selectedMenuOpt = 3;
                  uiProvider.selectedMenuName = 'Lista contingencias';
                });
              },
              heroTag: 'listCon',
            ),
          ],
        ));
  }
}
