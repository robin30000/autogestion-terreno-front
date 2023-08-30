import 'package:autogestion_tecnico/global/custom_show_dialog.dart';
import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/providers/providers.dart';
import 'package:autogestion_tecnico/services/services.dart';
import 'package:autogestion_tecnico/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SoporteEtpPage extends StatefulWidget {
  const SoporteEtpPage({super.key});

  @override
  State<SoporteEtpPage> createState() => _SoporteEtpPageState();
}

class _SoporteEtpPageState extends State<SoporteEtpPage> {
  final GlobalKey<FormState> _formKeySoporteEtp = GlobalKey<FormState>();

  TextEditingController tareaController = TextEditingController();
  TextEditingController arponController = TextEditingController();
  TextEditingController napController = TextEditingController();
  TextEditingController hiloController = TextEditingController();
  TextEditingController contactoController = TextEditingController();
  TextEditingController nombreContactoController = TextEditingController();
  TextEditingController detalleSolicitudController = TextEditingController();

  bool internetPort1 = true;
  bool internetPort2 = false;
  bool internetPort3 = false;
  bool internetPort4 = false;

  bool tvPort1 = false;
  bool tvPort2 = false;
  bool tvPort3 = true;
  bool tvPort4 = true;

  bool replanteo = false;

  int? soporte;
  void _updateSoporte(int value) {
    setState(() {
      soporte = value;
      print(soporte);
    });
  }

  @override
  void dispose() {
    tareaController.dispose();
    arponController.dispose();
    napController.dispose();
    hiloController.dispose();
    contactoController.dispose();
    nombreContactoController.dispose();
    detalleSolicitudController.dispose();
    if (_formKeySoporteEtp.currentState != null) {
      _formKeySoporteEtp.currentState!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final uiProvider = Provider.of<UiProvider>(context);
    final soporteEtpService = Provider.of<SoporteEtpService>(context);

    final authServices = Provider.of<AuthService>(context, listen: false);
    authServices.getMenuApp();

    //Future<int>? soporte;
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SingleChildScrollView(
          child: Form(
            key: _formKeySoporteEtp,
            child: Column(children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                    top: mq.height * 0.01,
                    bottom: 0,
                    left: mq.width * 0.10,
                    right: mq.width * 0.10),
                child: Text(
                  'Formulario de solicitud soporte ETP',
                  style: TextStyle(
                    color: blueColor,
                    fontWeight: FontWeight.w500,
                    fontSize: mq.width * 0.06,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
/*               const SizedBox(
                  height: 10), // Añadir espacio entre el título y el Text
              Text(
                'Valor de soporte: ${soporte ?? "Ninguno"}', // Mostrar el valor de soporte
                style: TextStyle(
                  color: Colors.black, // Cambiar el color según tus necesidades
                  fontWeight: FontWeight.normal,
                  fontSize: mq.width * 0.04,
                ),
              ), */
              CustomDivider(mq: mq, colors: [
                whiteColor,
                blueColor,
                whiteColor,
              ]),
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: mq.width *
                              0.05), // Ajusta el valor según tus necesidades
                      child: CustomField(
                        controller: tareaController,
                        hintText: 'Tarea*',
                        icon: Icons.document_scanner_outlined,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () async {
                        try {
                          var response = await soporteEtpService.validaPedido(
                              pedido: tareaController.text);
                          print(response);
                          if (response!['type'] == 'error') {
                            CustomShowDialog.alert(
                                context: context,
                                title: 'Error',
                                message: response['message']);
                          } else {
                            if (response['message'] == 'GPON') {
                              _updateSoporte(1);
                            } else if (response['message'] == 'OTRO') {
                              _updateSoporte(2);
                            }
                          }
                        } catch (error) {
                          print(error);
                        }
                        //print(soporte);
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05),
                child: Column(children: [
                  if (soporte == 1) ...[
                    CustomField(
                        controller: arponController,
                        hintText: 'Apon*',
                        icon: Icons.device_hub_outlined,
                        maxlength: 6,
                        keyboardType: TextInputType.number),
                    SizedBox(
                      height: mq.height * 0.02,
                    ),
                    CustomField(
                        controller: napController,
                        hintText: 'NAP*',
                        icon: Icons.lan,
                        maxlength: 2,
                        keyboardType: TextInputType.number),
                    SizedBox(
                      height: mq.height * 0.02,
                    ),
                    CustomField(
                        controller: hiloController,
                        hintText: 'Hilo*',
                        icon: Icons.power_input_outlined,
                        maxlength: 2,
                        keyboardType: TextInputType.number),
                    SizedBox(
                      height: mq.height * 0.02,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Internet'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomCheckBox(
                                isSelected: internetPort1,
                                label: '1',
                                onChanged: (bool? newValue) =>
                                    setState(() => internetPort1 = newValue!)),
                            CustomCheckBox(
                                isSelected: internetPort2,
                                label: '2',
                                onChanged: (bool? newValue) =>
                                    setState(() => internetPort2 = newValue!)),
                            CustomCheckBox(
                                isSelected: internetPort3,
                                label: '3',
                                onChanged: (bool? newValue) =>
                                    setState(() => internetPort3 = newValue!)),
                            CustomCheckBox(
                                isSelected: internetPort4,
                                label: '4',
                                onChanged: (bool? newValue) =>
                                    setState(() => internetPort4 = newValue!)),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Televisión'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomCheckBox(
                                isSelected: tvPort1,
                                label: '1',
                                onChanged: (bool? newValue) =>
                                    setState(() => tvPort1 = newValue!)),
                            CustomCheckBox(
                                isSelected: tvPort2,
                                label: '2',
                                onChanged: (bool? newValue) =>
                                    setState(() => tvPort2 = newValue!)),
                            CustomCheckBox(
                                isSelected: tvPort3,
                                label: '3',
                                onChanged: (bool? newValue) =>
                                    setState(() => tvPort3 = newValue!)),
                            CustomCheckBox(
                                isSelected: tvPort4,
                                label: '4',
                                onChanged: (bool? newValue) =>
                                    setState(() => tvPort4 = newValue!)),
                          ],
                        ),
                      ],
                    ),
                    CustomField(
                        controller: contactoController,
                        hintText: 'Contacto*',
                        icon: Icons.phone,
                        keyboardType: TextInputType.number),
                    SizedBox(
                      height: mq.height * 0.02,
                    ),
                    CustomField(
                        controller: nombreContactoController,
                        hintText: 'Nombre Contacto*',
                        icon: Icons.person),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: replanteo,
                              onChanged: (newValue) {
                                setState(() {
                                  replanteo = newValue!;
                                });
                              },
                            ),
                            const Text('Es replanteo?'),
                          ],
                        ),
                      ],
                    ),
                    CustomButton(
                      mq: mq,
                      function: soporteEtpService.isLoading
                          ? null
                          : () async {
                              FocusScope.of(context).unfocus();

                              if (tareaController.text == '' ||
                                  arponController.text == '' ||
                                  napController.text == '' ||
                                  hiloController.text == '' ||
                                  contactoController.text == '' ||
                                  nombreContactoController.text == '' ||
                                  detalleSolicitudController.text == '') {
                                CustomShowDialog.alert(
                                    context: context,
                                    title: 'Error',
                                    message:
                                        'Debes de diligenciar los campos obligatorios.');
                                return false;
                              }

                              String strInternetPort1 =
                                  (internetPort1) ? '1' : '0';
                              String strInternetPort2 =
                                  (internetPort2) ? '1' : '0';
                              String strInternetPort3 =
                                  (internetPort3) ? '1' : '0';
                              String strInternetPort4 =
                                  (internetPort4) ? '1' : '0';
                              String strTvPort1 = (tvPort1) ? '1' : '0';
                              String strTvPort2 = (tvPort2) ? '1' : '0';
                              String strTvPort3 = (tvPort3) ? '1' : '0';
                              String strTvPort4 = (tvPort4) ? '1' : '0';

                              String streplanteo = (replanteo) ? '1' : '0';

                              final Map? resp =
                                  await soporteEtpService.postContingencia(
                                      tarea: tareaController.text,
                                      arpon: arponController.text,
                                      nap: napController.text,
                                      hilo: hiloController.text,
                                      internetPort1: strInternetPort1,
                                      internetPort2: strInternetPort2,
                                      internetPort3: strInternetPort3,
                                      internetPort4: strInternetPort4,
                                      tvPort1: strTvPort1,
                                      tvPort2: strTvPort2,
                                      tvPort3: strTvPort3,
                                      tvPort4: strTvPort4,
                                      numeroContacto: contactoController.text,
                                      nombreContacto:
                                          nombreContactoController.text,
                                      observacion:
                                          detalleSolicitudController.text,
                                      replanteo: streplanteo);

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

                                uiProvider.selectedMenuOpt = 13;
                                uiProvider.selectedMenuName = 'Soporte ETP';
                              }
                            },
                      color:
                          soporteEtpService.isLoading ? greyColor : blueColor,
                      colorText: whiteColor,
                      text: soporteEtpService.isLoading
                          ? 'Cargando...'
                          : 'Enviar Solicitud',
                      height: 0.05,
                    ),
                    SizedBox(
                      height: mq.height * 0.02,
                    )
                  ],
                  if (soporte == 2) ...[
                    CustomField(
                        controller: contactoController,
                        hintText: 'Contacto*',
                        icon: Icons.phone,
                        keyboardType: TextInputType.number),
                    SizedBox(
                      height: mq.height * 0.02,
                    ),
                    CustomField(
                        controller: nombreContactoController,
                        hintText: 'Nombre Contacto*',
                        icon: Icons.person),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: replanteo,
                              onChanged: (newValue) {
                                setState(() {
                                  replanteo = newValue!;
                                });
                              },
                            ),
                            const Text('Es replanteo?'),
                          ],
                        ),
                      ],
                    ),
                    CustomButton(
                      mq: mq,
                      function: soporteEtpService.isLoading
                          ? null
                          : () async {
                              FocusScope.of(context).unfocus();

                              if (tareaController.text == '' ||
                                  contactoController.text == '' ||
                                  nombreContactoController.text == '' ||
                                  detalleSolicitudController.text == '') {
                                CustomShowDialog.alert(
                                    context: context,
                                    title: 'Error',
                                    message:
                                        'Debes de diligenciar los campos obligatorios.');
                                return false;
                              }

                              String strInternetPort1 =
                                  (internetPort1) ? '' : '';
                              String strInternetPort2 =
                                  (internetPort2) ? '' : '';
                              String strInternetPort3 =
                                  (internetPort3) ? '' : '';
                              String strInternetPort4 =
                                  (internetPort4) ? '' : '';
                              String strTvPort1 = (tvPort1) ? '' : '';
                              String strTvPort2 = (tvPort2) ? '' : '';
                              String strTvPort3 = (tvPort3) ? '' : '';
                              String strTvPort4 = (tvPort4) ? '' : '';
                              String streplanteo = (replanteo) ? '1' : '0';

                              final Map? resp =
                                  await soporteEtpService.postContingencia(
                                tarea: tareaController.text,
                                arpon: arponController.text,
                                nap: napController.text,
                                hilo: hiloController.text,
                                internetPort1: strInternetPort1,
                                internetPort2: strInternetPort2,
                                internetPort3: strInternetPort3,
                                internetPort4: strInternetPort4,
                                tvPort1: strTvPort1,
                                tvPort2: strTvPort2,
                                tvPort3: strTvPort3,
                                tvPort4: strTvPort4,
                                numeroContacto: contactoController.text,
                                nombreContacto: nombreContactoController.text,
                                observacion: detalleSolicitudController.text,
                                replanteo: streplanteo,
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

                                uiProvider.selectedMenuOpt = 13;
                                uiProvider.selectedMenuName = 'Soporte ETP';
                              }
                            },
                      color:
                          soporteEtpService.isLoading ? greyColor : blueColor,
                      colorText: whiteColor,
                      text: soporteEtpService.isLoading
                          ? 'Cargando...'
                          : 'Enviar Solicitud',
                      height: 0.05,
                    ),
                    SizedBox(
                      height: mq.height * 0.02,
                    )
                  ]
                ]),
              )
            ]),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          uiProvider.selectedMenuOpt = 4;
          uiProvider.selectedMenuName = 'Lista Soporte ETP';
        },
        backgroundColor: const Color.fromARGB(255, 0, 51, 94),
        child: const Icon(Icons.list_rounded),
      ),
    );
  }
}
