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
  TextEditingController pedidoController = TextEditingController();
  String categoria = '';

  List<BB8> data = [];
  String bb8Res = '';
  String primeraSesionMostrada = 'y';

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
                    right: mq.width * 0.10,
                  ),
                  child: Text(
                    'Consultas BB8',
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
                  future: bb8Service.getCategoriaBb8(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(),
                          ),
                        ],
                      );
                    }

                    return CustomDropdown(
                      mq: mq * 0.9,
                      options: snapshot.data,
                      value: categoria,
                      function: (value) async {
                        categoria = value!;
                        uiProvider.notifyListeners();
                      },
                      functionOnTap: () {
                        categoria = '';
                        data = [];
                        uiProvider.notifyListeners();
                      },
                      hintText: 'Tipo código*',
                      icon: Icons.devices_outlined,
                    );
                  },
                ),
                if (categoria == 'direccion')
                  ..._buildDireccionSection(mq, bb8Service),
                if (categoria == 'equipos')
                  ..._buildEquiposSection(mq, bb8Service),
              ],
            ),
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
                categoria = '';
                pedidoController.text = '';
                ciudadController.text = '';
                direccionController.text = '';
              });
            },
            heroTag: 'Limpiar',
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDireccionSection(Size mq, BB8Service bb8Service) {
    return [
      Padding(
        padding: EdgeInsets.only(
          left: mq.width * 0.05,
          right: mq.width * 0.05,
          top: mq.height * 0.02,
        ),
        child: Column(
          children: [
            CustomField(
              controller: ciudadController,
              hintText: 'Ciudad*',
              icon: Icons.location_city_outlined,
            ),
            SizedBox(height: mq.height * 0.02),
            CustomField(
              controller: direccionController,
              hintText: 'Dirección*',
              icon: Icons.signpost_outlined,
            ),
            SizedBox(height: mq.height * 0.02),
            CustomButton(
              mq: mq,
              function: bb8Service.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();

                      final authService =
                          Provider.of<AuthService>(context, listen: false);

                      if (ciudadController.text == '' ||
                          direccionController.text == '') {
                        CustomShowDialog.alert(
                          context: context,
                          title: 'Error',
                          message: 'Debes diligenciar los campos obligatorios.',
                        );
                        return false;
                      }
                      final resp = await bb8Service.getBB8(
                        ciudad: ciudadController.text,
                        direccion: direccionController.text,
                      );

                      if (resp != null) {
                        if (resp[0]['type'] == 'errorAuth') {
                          final String resp = await authService.logout();

                          if (resp == 'OK') {
                            Navigator.pushReplacementNamed(context, 'login');
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
              text: bb8Service.isLoading ? 'Buscando...' : 'Buscar',
              height: 0.05,
            ),
            SizedBox(
              height: mq.height * 0.02,
            ),
          ],
        ),
      ),
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
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: mq.height * 0.03,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: mq.width,
                    height: mq.height * 0.12,
                    margin: EdgeInsets.symmetric(horizontal: mq.width * 0.01),
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
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: mq.width * 0.60,
                          padding: EdgeInsets.only(left: mq.width * 0.03),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(child: Text(data[index].cliente)),
                              FittedBox(child: Text(data[index].direccion)),
                            ],
                          ),
                        ),
                        Container(
                          width: mq.width * 0.30,
                          padding: EdgeInsets.only(left: mq.width * 0.03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              data[index].television == null
                                  ? const SizedBox()
                                  : Icon(
                                      Icons.tv_rounded,
                                      color: data[index]
                                                  .television!
                                                  .split('|')[1] ==
                                              'Activo'
                                          ? greenColor
                                          : greyColor,
                                    ),
                              data[index].internet == null
                                  ? const SizedBox()
                                  : Icon(
                                      Icons.wifi,
                                      color:
                                          data[index].internet!.split('|')[1] ==
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
                                                  .split('|')[1] ==
                                              'Activo'
                                          ? greenColor
                                          : greyColor,
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    ];
  }

  List<Widget> _buildEquiposSection(Size mq, BB8Service bb8Service) {
    bool mostrarTitulo =
        true; // Variable para controlar la visibilidad del título

    return [
      Padding(
        padding: EdgeInsets.only(
          left: mq.width * 0.05,
          right: mq.width * 0.05,
          top: mq.height * 0.02,
        ),
        child: Column(
          children: [
            CustomField(
              controller: pedidoController,
              hintText: 'Pedido*',
              icon: Icons.location_city_outlined,
            ),
            SizedBox(height: mq.height * 0.02),
            CustomButton(
              mq: mq,
              function: bb8Service.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();

                      final authService =
                          Provider.of<AuthService>(context, listen: false);

                      if (pedidoController.text == '') {
                        CustomShowDialog.alert(
                          context: context,
                          title: 'Error',
                          message: 'Debes diligenciar los campos obligatorios.',
                        );
                        return false;
                      }

                      data = [];
                      final resp = await bb8Service.getBB8Equipos(
                        pedido: pedidoController.text,
                      );

                      if (resp != null) {
                        if (resp[0]['type'] == 'errorAuth') {
                          final String resp = await authService.logout();

                          if (resp == 'OK') {
                            Navigator.pushReplacementNamed(context, 'login');
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
              text: bb8Service.isLoading ? 'Buscando...' : 'Buscar',
              height: 0.05,
            ),
            SizedBox(
              height: mq.height * 0.02,
            ),
          ],
        ),
      ),
      data.isEmpty
          ? bb8Res == ''
              ? Container()
              : Center(
                  child: Text(bb8Res),
                )
          : SizedBox(
              width: mq.width * 0.94,
              height: mq.height * 0.60,
              child: ListView.separated(
                itemCount: data.length,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: mq.height * 0.01,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  Widget tituloWidget = SizedBox.shrink();
                  if (mostrarTitulo) {
                    tituloWidget = Row(
                      children: [
                        Container(
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
                            //borderRadius: BorderRadius.circular(10.0),
                          ),
                          width: mq.width * 0.93,
                          padding: EdgeInsets.only(
                              left: mq.width * 0.04,
                              top: mq.height * 0.01,
                              bottom: mq.height * 0.01),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                child: Text(
                                  'Velocidad: ${data[index].velocidad}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ),
                              FittedBox(
                                child: Text(
                                  'linea: ${data[index].linea}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ),
                              FittedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Paquetes:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                    Container(
                                      constraints: BoxConstraints(
                                        maxHeight: mq.height *
                                            0.15, // Establece una altura máxima
                                      ),
                                      child: Text(
                                        data[index].paquetes != null
                                            ? ' ${data[index].paquetes!.split(' - ').join('\n')}'
                                            : '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                    mostrarTitulo = false;
                  }

                  return Column(
                    children: [
                      tituloWidget,
                      Container(
                        width: mq.width,
                        height: mq.height * 0.10,
                        margin:
                            EdgeInsets.symmetric(horizontal: mq.width * 0.0),
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
                          //borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: mq.width * 0.45,
                              padding: EdgeInsets.only(left: mq.width * 0.03),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FittedBox(
                                      child: Text(
                                          'Serial: ${data[index].serial}')),
                                  FittedBox(
                                      child: Text('Mac: ${data[index].mac}')),
                                  FittedBox(
                                      child:
                                          Text('Marca: ${data[index].marca}')),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
    ];
  }
}

//   List<Widget> _buildEquiposSection(Size mq, BB8Service bb8Service) {
//     return [
//       Padding(
//         padding: EdgeInsets.only(
//           left: mq.width * 0.05,
//           right: mq.width * 0.05,
//           top: mq.height * 0.02,
//         ),
//         child: Column(
//           children: [
//             CustomField(
//               controller: pedidoController,
//               hintText: 'Pedido*',
//               icon: Icons.location_city_outlined,
//             ),
//             SizedBox(height: mq.height * 0.02),
//             CustomButton(
//               mq: mq,
//               function: bb8Service.isLoading
//                   ? null
//                   : () async {
//                       FocusScope.of(context).unfocus();

//                       final authService =
//                           Provider.of<AuthService>(context, listen: false);

//                       if (pedidoController.text == '') {
//                         CustomShowDialog.alert(
//                           context: context,
//                           title: 'Error',
//                           message: 'Debes diligenciar los campos obligatorios.',
//                         );
//                         return false;
//                       }

//                       data = [];
//                       final resp = await bb8Service.getBB8Equipos(
//                         pedido: pedidoController.text,
//                       );

//                       if (resp != null) {
//                         if (resp[0]['type'] == 'errorAuth') {
//                           final String resp = await authService.logout();

//                           if (resp == 'OK') {
//                             Navigator.pushReplacementNamed(context, 'login');
//                           }

//                           return false;
//                         }

//                         if (resp[0]['type'] == 'error') {
//                           setState(() {
//                             bb8Res = resp[0]['message'];
//                           });
//                         }
//                       }

//                       data = bb8Service.bb8;
//                     },
//               color: bb8Service.isLoading ? greyColor : blueColor,
//               colorText: whiteColor,
//               text: bb8Service.isLoading ? 'Buscando...' : 'Buscar',
//               height: 0.05,
//             ),
//             SizedBox(
//               height: mq.height * 0.02,
//             ),
//           ],
//         ),
//       ),
//       data.isEmpty
//           ? bb8Res == ''
//               ? Container()
//               : Center(
//                   child: Text(bb8Res),
//                 )
//           : SizedBox(
//               width: mq.width * 0.95,
//               height: mq.height * 0.60,
//               child: ListView.separated(
//                 itemCount: data.length,
//                 separatorBuilder: (BuildContext context, int index) {
//                   return SizedBox(
//                     height: mq.height * 0.01,
//                   );
//                 },
//                 itemBuilder: (BuildContext context, int index) {
//                   return Container(
//                     width: mq.width,
//                     height: mq.height * 0.10,
//                     margin: EdgeInsets.symmetric(horizontal: mq.width * 0.01),
//                     decoration: BoxDecoration(
//                       color: whiteColor,
//                       boxShadow: const [
//                         BoxShadow(
//                           color: Colors.black26,
//                           blurRadius: 15,
//                           offset: Offset(3, 2),
//                           spreadRadius: -5,
//                         ),
//                       ],
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           width: mq.width * 0.45,
//                           padding: EdgeInsets.only(left: mq.width * 0.03),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               FittedBox(
//                                 child: Text(
//                                     'Tipo: ${data[0].tipo} - Velocidad: ${data[0].velocidad}'),
//                               ),
//                               SizedBox(
//                                 height: mq.height * 0.02,
//                               ),
//                               FittedBox(
//                                   child: Text('Serial: ${data[index].serial}')),
//                               FittedBox(child: Text('Mac: ${data[index].mac}')),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//     ];
//   }
// }
