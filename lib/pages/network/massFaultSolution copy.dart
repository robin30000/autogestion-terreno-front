import 'package:autogestion_tecnico/pages/network/list_massFault.dart';
import 'package:autogestion_tecnico/providers/ui_provider.dart';
import 'package:autogestion_tecnico/services/services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:autogestion_tecnico/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:autogestion_tecnico/global/custom_show_dialog.dart';
import 'package:autogestion_tecnico/global/globals.dart';

const kGoogleApiKey =
    'AIzaSyCAvtJpUmHTh9mAnTxl7ueCrietdNERAro'; // Reemplaza con tu API Key

class MassFaultSolutionPage extends StatefulWidget {
  const MassFaultSolutionPage({super.key});

  @override
  _MassFaultSolutionPageState createState() => _MassFaultSolutionPageState();
}

class _MassFaultSolutionPageState extends State<MassFaultSolutionPage> {
  final TextEditingController _caseNumberController = TextEditingController();
  final TextEditingController _ubicacionController = TextEditingController();
  final TextEditingController _observationsController = TextEditingController();

  //google_maps.LatLng? _selectedLocation;
  String _selectedRegion = '';
  String _selectedTechnology = '';
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final uiProvider = Provider.of<UiProvider>(context);
    final networkservice = Provider.of<NetworkService>(context);

    final authServices = Provider.of<AuthService>(context, listen: false);
    authServices.getMenuApp();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Cierre Masivo de Tickets'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),
                CustomField(
                  controller: _caseNumberController,
                  hintText: 'Número de ticket',
                  icon: Icons.document_scanner_outlined,
                  width: 50.0,
                ),
                SizedBox(
                  height: mq.height * 0.02,
                ),
                FutureBuilder(
                  future: networkservice.getTecnology(),
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
                        value: _selectedTechnology,
                        function: (value) async {
                          _selectedTechnology = value!;
                          uiProvider.notifyListeners();
                        },
                        functionOnTap: () {
                          _selectedTechnology = '';
                          uiProvider.notifyListeners();
                        },
                        hintText: 'Tecnología*',
                        icon: Icons.devices_outlined);
                  },
                ),
                SizedBox(
                  height: mq.height * 0.02,
                ),
                FutureBuilder(
                  future: networkservice.getRegion(),
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
                        value: _selectedRegion,
                        function: (value) async {
                          _selectedRegion = value!;
                          uiProvider.notifyListeners();
                        },
                        functionOnTap: () {
                          _selectedRegion = '';
                          uiProvider.notifyListeners();
                        },
                        hintText: 'Region*',
                        icon: Icons.devices_outlined);
                  },
                ),
                SizedBox(
                  height: mq.height * 0.02,
                ),
                const SizedBox(height: 16.0),
                _buildRegionField(context),
                const SizedBox(height: 16.0),
                CustomField(
                  controller: _observationsController,
                  hintText: 'Observaciones*',
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
                const SizedBox(height: 32.0),
                Center(
                  child: CustomButton(
                    mq: mq,
                    function: networkservice.isLoading
                        ? null
                        : () async {
                            final authService = Provider.of<AuthService>(
                                context,
                                listen: false);

                            FocusScope.of(context).unfocus();

                            if (_caseNumberController.text.isEmpty ||
                                _selectedTechnology.isEmpty ||
                                _ubicacionController.text.isEmpty ||
                                _observationsController.text.isEmpty ||
                                _selectedRegion.isEmpty) {
                              CustomShowDialog.alert(
                                  context: context,
                                  title: 'Error',
                                  message:
                                      'Debes de diligenciar los campos obligatorios.');
                              return;
                            }

                            String _clasificador = 'cierre_masivo';

                            final Map? resp = await networkservice.postNetwork(
                                numero_ticket: _caseNumberController.text,
                                tecnologia: _selectedTechnology,
                                direccion: _ubicacionController.text,
                                observacion: _observationsController.text,
                                region: _selectedRegion,
                                clasificador: _clasificador);

                            if (resp!['type'] == 'errorAuth') {
                              final String resp = await authService.logout();

                              if (resp == 'OK') {
                                uiProvider.selectedMenuOpt = 0;
                                uiProvider.selectedMenuName =
                                    'Autogestión Terreno';
                                Navigator.pushReplacementNamed(
                                    context, 'login');
                              }

                              return;
                            }

                            if (resp['type'] == 'error') {
                              CustomShowDialog.alert(
                                  context: context,
                                  title: 'Error',
                                  message: resp['message']);
                            } else {
                              CustomShowDialog.alert(
                                  context: context,
                                  title: 'Excelente',
                                  message: resp['message']);

                              await Future.delayed(
                                  const Duration(milliseconds: 500));

                              uiProvider.selectedMenuOpt = 99;
                              uiProvider.selectedMenuName = 'Contingencias';

                              await Future.delayed(const Duration(seconds: 1));

                              uiProvider.selectedMenuOpt = 1;
                              uiProvider.selectedMenuName = 'Contingencias';
                            }
                          },
                    color: networkservice.isLoading ? greyColor : blueColor,
                    colorText: whiteColor,
                    text: networkservice.isLoading
                        ? 'Cargando...'
                        : 'Enviar Solicitud',
                    height: 0.05,
                  ),
                ),
              ],
            ),
          ),
        ),
        // floatingActionButton: Column(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     CustomButtom(
        //       icon: Icons.list_rounded,
        //       onPressed: () {
        //         print('robin');
        //         setState(() {
        //           uiProvider.selectedMenuOpt = 25;
        //           uiProvider.selectedMenuName = 'Lista fallas masivas';
        //         });
        //       },
        //       heroTag: 'listCon',
        //     ),
        //   ],
        // ));
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomButtom(
              icon: Icons.list_rounded,
              onPressed: () {
                print('robin');
                setState(() {
                  uiProvider.selectedMenuOpt = 25;
                  uiProvider.selectedMenuName = 'Lista fallas masivas';
                });
                // Navegar usando la ruta nombrada
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => ListMassFaultPage()),
                // );
              },
              heroTag: 'listCon',
            ),
          ],
        ));
  }

  // Widget _buildTextField({
  //   required TextEditingController controller,
  //   required String label,
  //   int maxLines = 1,
  // }) {
  //   return TextField(
  //     controller: controller,
  //     maxLines: maxLines,
  //     decoration: InputDecoration(
  //       border: OutlineInputBorder(),
  //       labelText: label,
  //     ),
  //   );
  // }

  Widget _buildRegionField(BuildContext context) {
    return Column(
      children: [
        LocationServiceWidget(
          onLocationSelected: (String location) {
            setState(() {
              _ubicacionController.text = location;
            });
          },
        ),
        //const SizedBox(height: 8),
        CustomField(
          controller: _ubicacionController,
          hintText: 'Ubicación (dirección)',
          icon: Icons.document_scanner_outlined,
          width: 50.0,
        ),
        // TextField(
        //   controller: _ubicacionController,
        //   readOnly: true,
        //   decoration: const InputDecoration(
        //     border: OutlineInputBorder(),
        //     labelText: 'Ubicación (dirección)',
        //   ),
        // ),
      ],
    );
  }
}
