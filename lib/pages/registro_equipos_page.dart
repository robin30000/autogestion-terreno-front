import 'package:autogestion_tecnico/global/custom_show_dialog.dart';
import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/providers/providers.dart';
import 'package:autogestion_tecnico/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:textfield_tags/textfield_tags.dart';

import '../services/auth_service.dart';
import '../services/registro_equipos_services.dart';

class RegistroEquipos extends StatefulWidget {
  const RegistroEquipos({super.key});

  @override
  State<RegistroEquipos> createState() => _RegistroEquiposState();
}

class _RegistroEquiposState extends State<RegistroEquipos> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController inputFieldController = TextEditingController();

  TextEditingController pedidoController = TextEditingController();
  TextEditingController detalleSolicitudController = TextEditingController();
  TextfieldTagsController macEntraController = TextfieldTagsController();

  @override
  void dispose() {
    pedidoController.dispose();
    detalleSolicitudController.dispose();

    if (_formKey.currentState != null) _formKey.currentState!.dispose();
    super.dispose();
  }

  @override
  Future<void> didUpdateWidget(covariant RegistroEquipos oldWidget) async {
    super.didUpdateWidget(oldWidget);
    final clipboard = await Clipboard.getData(Clipboard.kTextPlain);
    String clipboardText = clipboard?.text ?? '';
    print('$clipboardText RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR');
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final uiProvider = Provider.of<UiProvider>(context);
    final contingenciasService = Provider.of<RegistroEquiposService>(context);
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
                  'Formulario registro de equipos',
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
                          controller: pedidoController,
                          hintText: 'Pedido*',
                          icon: Icons.document_scanner_outlined,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () async {
                            try {
                              var response = await contingenciasService
                                  .validaPedido(pedido: pedidoController.text);
                              if (response!['type'] == 'error') {
                                CustomShowDialog.alert(
                                    context: context,
                                    title: 'Error',
                                    message: response['message']);
                              } else {
                                CustomShowDialog.alert(
                                    context: context,
                                    title: 'Bien',
                                    message: response['message']);
                              }
                            } catch (error) {
                              // Handle the error response
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  CustomTag(
                      mq: mq,
                      //controller: macEntraController,
                      controller: macEntraController,
                      hintText: 'equipos',
                      colorTag: blueColor),

                  SizedBox(
                    height: mq.height * 0.02,
                  ),

                  // Detalle de solicitud
                  CustomField(
                    controller: detalleSolicitudController,
                    hintText: 'Observaciones',
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
                                detalleSolicitudController.text == '') {
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

                            pedidoController.text;
                            detalleSolicitudController.text;
                            String macEntraFormat =
                                macEntraController.getTags!.join('-');
                            //String macSaleFormat = macSaleController.getTags!.join('-');
                            String macSaleFormat = '';

                            final Map? resp =
                                await contingenciasService.postContingencia(
                              pedido: pedidoController.text,
                              observacion: detalleSolicitudController.text,
                              macentra: macEntraFormat,
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
                              uiProvider.selectedMenuName = 'Registro equipos';

                              await Future.delayed(const Duration(seconds: 1));

                              uiProvider.selectedMenuOpt = 11;
                              uiProvider.selectedMenuName = 'Registro equipos';
                            }
                          },
                    color:
                        contingenciasService.isLoading ? greyColor : blueColor,
                    colorText: whiteColor,
                    text: contingenciasService.isLoading
                        ? 'Cargando...'
                        : 'Enviar',
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
                builder: (context) => const QRScanner(),
              ));
            },
            heroTag:
                'qrScanner', // Agrega un tag único para el botón de escaneo QR
          ),
          CustomButtom(
            icon: Icons.list_rounded,
            onPressed: () {
              setState(() {
                uiProvider.selectedMenuOpt = 12;
                uiProvider.selectedMenuName = 'Lista registro equipos';
              });
            },
            heroTag:
                'listEquipos', // Agrega un tag único para el botón de lista de equipos
          ),
        ],
      ),
    );
  }
}
