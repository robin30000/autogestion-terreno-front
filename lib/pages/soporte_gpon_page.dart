import 'package:autogestion_tecnico/global/custom_show_dialog.dart';
import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/providers/providers.dart';
import 'package:autogestion_tecnico/services/services.dart';
import 'package:autogestion_tecnico/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SoporteGponPage extends StatefulWidget {
  const SoporteGponPage({super.key});

  @override
  State<SoporteGponPage> createState() => _SoporteGponPageState();
}

class _SoporteGponPageState extends State<SoporteGponPage> {
  final GlobalKey<FormState> _formKeySoporteGpon = GlobalKey<FormState>();

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

  @override
  void dispose() {
    tareaController.dispose();
    arponController.dispose();
    napController.dispose();
    hiloController.dispose();
    contactoController.dispose();
    nombreContactoController.dispose();
    detalleSolicitudController.dispose();
    if (_formKeySoporteGpon.currentState != null)
      _formKeySoporteGpon.currentState!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final uiProvider = Provider.of<UiProvider>(context);
    final soportegponService = Provider.of<SoporteGponService>(context);

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
                  'Formulario de solicitud soporte GPON',
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
                  CustomField(
                      controller: tareaController,
                      hintText: 'Tarea*',
                      icon: Icons.description_outlined),
                  SizedBox(
                    height: mq.height * 0.02,
                  ),
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
                  CustomButton(
                    mq: mq,
                    function: soportegponService.isLoading
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

                            final Map? resp =
                                await soportegponService.postContingencia(
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
                              uiProvider.selectedMenuName = 'Soporte GPON';

                              await Future.delayed(const Duration(seconds: 1));

                              uiProvider.selectedMenuOpt = 2;
                              uiProvider.selectedMenuName = 'Soporte GPON';

                              /* tareaController.clear();
                            tareaController.text = '';
                            arponController.clear();
                            arponController.text = '';
                            napController.clear();
                            napController.text = '';
                            hiloController.clear();
                            hiloController.text = '';

                            detalleSolicitudController.clear();
                            detalleSolicitudController.text = '';

                            _formKeySoporteGpon.currentState!.reset(); */
                            }
                          },
                    color: soportegponService.isLoading ? greyColor : blueColor,
                    colorText: whiteColor,
                    text: soportegponService.isLoading
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
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          uiProvider.selectedMenuOpt = 4;
          uiProvider.selectedMenuName = 'Lista Soporte GPON';
        },
        backgroundColor: cyanColor,
        child: const Icon(Icons.list_rounded),
      ),
    );
  }
}
