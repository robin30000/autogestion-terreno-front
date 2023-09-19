import 'package:autogestion_tecnico/global/custom_show_dialog.dart';
import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/models/models.dart';
import 'package:autogestion_tecnico/providers/providers.dart';
import 'package:autogestion_tecnico/services/services.dart';
import 'package:autogestion_tecnico/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Bb8Page extends StatefulWidget {
  const Bb8Page({super.key});

  @override
  State<Bb8Page> createState() => _Bb8PageState();
}

class _Bb8PageState extends State<Bb8Page> {
  final GlobalKey<FormState> _formKeyBb8 = GlobalKey<FormState>();

  TextEditingController ciudadController = TextEditingController();
  TextEditingController direccionController = TextEditingController();

  List<BB8> data = [];
  String bb8Res = '';

  @override
  void dispose() {
    ciudadController.dispose();
    direccionController.dispose();
    if (_formKeyBb8.currentState != null) _formKeyBb8.currentState!.dispose();
    data = [];
    bb8Res = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final uiProvider = Provider.of<UiProvider>(context);
    final bb8Service = Provider.of<BB8Service>(context);

    final authServices = Provider.of<AuthService>(context, listen: false);
    authServices.getMenuApp();

    return Scaffold(
      body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Form(
              key: _formKeyBb8,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          top: mq.height * 0.01,
                          bottom: 0,
                          left: mq.width * 0.10,
                          right: mq.width * 0.10),
                      child: Text(
                        'Consultar dirección',
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
                        padding: EdgeInsets.only(
                            left: mq.width * 0.05,
                            right: mq.width * 0.05,
                            top: mq.height * 0.02),
                        child: Column(children: [
                          CustomField(
                              controller: ciudadController,
                              hintText: 'Ciudad*',
                              icon: Icons.location_city_outlined),
                          SizedBox(
                            height: mq.height * 0.02,
                          ),
                          CustomField(
                              controller: direccionController,
                              hintText: 'Dirección*',
                              icon: Icons.signpost_outlined),
                          SizedBox(
                            height: mq.height * 0.02,
                          ),
                          CustomButton(
                            mq: mq,
                            function: bb8Service.isLoading
                                ? null
                                : () async {
                                    FocusScope.of(context).unfocus();

                                    final authService =
                                        Provider.of<AuthService>(context,
                                            listen: false);

                                    if (ciudadController.text == '' ||
                                        direccionController.text == '') {
                                      CustomShowDialog.alert(
                                          context: context,
                                          title: 'Error',
                                          message:
                                              'Debes de diligenciar los campos obligatorios.');
                                      return false;
                                    }

                                    final resp = await bb8Service.getBB8(
                                        ciudad: ciudadController.text,
                                        direccion: direccionController.text);

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
                                          bb8Res = resp[0]['message'];
                                        });
                                      }
                                    }

                                    data = bb8Service.bb8;
                                  },
                            color: bb8Service.isLoading ? greyColor : blueColor,
                            colorText: whiteColor,
                            text:
                                bb8Service.isLoading ? 'Buscando...' : 'Buscar',
                            height: 0.05,
                          )
                        ])),
                    data.isEmpty
                        ? bb8Res == ''
                            ? Container()
                            : Center(
                                child: Text(bb8Res),
                              )
                        : SizedBox(
                            width: mq.width * 0.95,
                            height: mq.height * 0.60,
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
                                  height: mq.height * 0.12,
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
                                  child: Row(
                                    children: [
                                      Container(
                                        width: mq.width * 0.60,
                                        padding: EdgeInsets.only(
                                            left: mq.width * 0.03),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FittedBox(
                                                child:
                                                    Text(data[index].cliente)),
                                            FittedBox(
                                                child: Text(
                                                    data[index].direccion)),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: mq.width * 0.30,
                                        padding: EdgeInsets.only(
                                            left: mq.width * 0.03),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              data[index].television == null
                                                  ? const SizedBox()
                                                  : Icon(
                                                      Icons.tv_rounded,
                                                      color: data[index]
                                                                  .television!
                                                                  .split(
                                                                      '|')[1] ==
                                                              'Activo'
                                                          ? greenColor
                                                          : greyColor,
                                                    ),
                                              data[index].internet == null
                                                  ? const SizedBox()
                                                  : Icon(
                                                      Icons.wifi,
                                                      color: data[index]
                                                                  .internet!
                                                                  .split(
                                                                      '|')[1] ==
                                                              'Activo'
                                                          ? greenColor
                                                          : greyColor,
                                                    ),
                                              data[index].telefonia == null
                                                  ? const SizedBox()
                                                  : Icon(
                                                      Icons.phone,
                                                      color: data[index]
                                                                  .telefonia!
                                                                  .split(
                                                                      '|')[1] ==
                                                              'Activo'
                                                          ? greenColor
                                                          : greyColor,
                                                    ),
                                            ]),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                  ],
                ),
              ))),
    );
  }
}
