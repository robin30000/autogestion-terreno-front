import 'package:autogestion_tecnico/providers/ui_provider.dart';
import 'package:autogestion_tecnico/services/services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:autogestion_tecnico/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:autogestion_tecnico/global/custom_show_dialog.dart';
import 'package:autogestion_tecnico/global/globals.dart';

// const kGoogleApiKey =
//     'AIzaSyCAvtJpUmHTh9mAnTxl7ueCrietdNERAro'; // Reemplaza con tu API Key

class AdvanceMassTicketPage extends StatefulWidget {
  const AdvanceMassTicketPage({super.key});

  @override
  _AdvanceMassTicketPageState createState() => _AdvanceMassTicketPageState();
}

class _AdvanceMassTicketPageState extends State<AdvanceMassTicketPage> {
  final TextEditingController _caseNumberController = TextEditingController();
  final TextEditingController _ubicacionController = TextEditingController();
  final TextEditingController _observationsController = TextEditingController();

  //google_maps.LatLng? _selectedLocation;
  String _selectedRegion = 'Seleccione'; // Valor inicial del área seleccionada
  String _selectedTechnology =
      'Seleccione'; // Valor inicial de la tecnología seleccionada

  final List<String> _areas = [
    'Seleccione',
    'Antioquia Sur',
    'Antioquia Centro',
    'Caldas',
    'Quindio',
    'Antioquia Municipios',
    'Bolivar',
    'Tolima',
    'Valle',
    'Risaralda',
    'Sucre',
    'Cesar',
    'Cordoba',
    'Cundinamarca Sur',
    'Cundinamarca Norte',
    'Cauca',
    'Meta',
    'Antioquia Default',
    'Boyaca',
    'Huila',
    'Casanare',
    'Nariño',
    'Cundinamarca Municipios'
  ];

  final List<String> _technologies = [
    'Seleccione',
    'HFC',
    'Cobre',
    'GPON',
    'Fibra',
    'Móvil',
  ];

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final uiProvider = Provider.of<UiProvider>(context);
    final networkservice = Provider.of<NetworkService>(context);

    final authServices = Provider.of<AuthService>(context, listen: false);
    authServices.getMenuApp();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Avances y Hora Esperada'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _caseNumberController,
                label: 'Número de ticket',
              ),
              const SizedBox(height: 16.0),
              _buildTechnologyDropdown(),
              const SizedBox(height: 16.0),
              _buildAreaDropdown(),
              const SizedBox(height: 16.0),
              _buildRegionField(context),
              const SizedBox(height: 16.0),
              _buildTextField(
                controller: _observationsController,
                label: 'Observaciones',
                maxLines: 4,
              ),
              const SizedBox(height: 32.0),
              Center(
                child: CustomButton(
                  mq: mq,
                  function: networkservice.isLoading
                      ? null
                      : () async {
                          final authService =
                              Provider.of<AuthService>(context, listen: false);

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
                              Navigator.pushReplacementNamed(context, 'login');
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
      ),
    );
  }

  Widget _buildTechnologyDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedTechnology,
      onChanged: (newValue) {
        setState(() {
          _selectedTechnology = newValue!;
        });
      },
      items: _technologies.map((technology) {
        return DropdownMenuItem(
          value: technology,
          child: Text(technology),
        );
      }).toList(),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Tecnología',
      ),
    );
  }

  Widget _buildAreaDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedRegion,
      onChanged: (newValue) {
        setState(() {
          _selectedRegion = newValue!;
        });
      },
      items: _areas.map((area) {
        return DropdownMenuItem(
          value: area,
          child: Text(area),
        );
      }).toList(),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Region',
      ),
    );
  }

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
        const SizedBox(height: 8),
        TextField(
          controller: _ubicacionController,
          readOnly: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Ubicación (dirección)',
          ),
        ),
      ],
    );
  }
}
