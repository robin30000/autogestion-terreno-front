import 'package:autogestion_tecnico/pages/network/list_massFault.dart';
import 'package:autogestion_tecnico/providers/ui_provider.dart';
import 'package:autogestion_tecnico/services/services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:autogestion_tecnico/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:autogestion_tecnico/global/custom_show_dialog.dart';
import 'package:autogestion_tecnico/global/globals.dart';

const kGoogleApiKey = 'TU_API_KEY_GOOGLE'; // Reemplaza con tu API Key

class MassFaultSolutionPage extends StatefulWidget {
  const MassFaultSolutionPage({super.key});

  @override
  _MassFaultSolutionPageState createState() => _MassFaultSolutionPageState();
}

class _MassFaultSolutionPageState extends State<MassFaultSolutionPage> {
  final TextEditingController _caseNumberController = TextEditingController();
  final TextEditingController _ubicacionController = TextEditingController();
  final TextEditingController _observationsController = TextEditingController();

  String _selectedRegion = '';
  String _selectedTechnology = '';

  @override
  void dispose() {
    _caseNumberController.dispose();
    _ubicacionController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final uiProvider = Provider.of<UiProvider>(context);
    final networkService = Provider.of<NetworkService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.getMenuApp();

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
              _buildCaseNumberField(),
              SizedBox(height: mq.height * 0.02),
              _buildTechnologyDropdown(networkService, mq, uiProvider),
              SizedBox(height: mq.height * 0.02),
              _buildRegionDropdown(networkService, mq, uiProvider),
              SizedBox(height: mq.height * 0.02),
              const SizedBox(height: 16.0),
              _buildLocationField(context),
              const SizedBox(height: 16.0),
              _buildObservationsField(),
              SizedBox(height: mq.height * 0.02),
              const SizedBox(height: 32.0),
              _buildSubmitButton(networkService, uiProvider, mq),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(uiProvider),
    );
  }

  Widget _buildCaseNumberField() {
    return CustomField(
      controller: _caseNumberController,
      hintText: 'Número de ticket',
      icon: Icons.document_scanner_outlined,
      width: 50.0,
    );
  }

  Widget _buildTechnologyDropdown(
      NetworkService networkService, Size mq, UiProvider uiProvider) {
    return FutureBuilder(
      future: networkService.getTecnology(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return _buildLoadingIndicator();
        }

        return CustomDropdown(
          mq: mq,
          options: snapshot.data,
          value: _selectedTechnology,
          function: (value) {
            setState(() {
              _selectedTechnology = value!;
            });
          },
          functionOnTap: () {
            setState(() {
              _selectedTechnology = '';
            });
          },
          hintText: 'Tecnología*',
          icon: Icons.devices_outlined,
        );
      },
    );
  }

  Widget _buildRegionDropdown(
      NetworkService networkService, Size mq, UiProvider uiProvider) {
    return FutureBuilder(
      future: networkService.getRegion(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return _buildLoadingIndicator();
        }

        return CustomDropdown(
          mq: mq,
          options: snapshot.data,
          value: _selectedRegion,
          function: (value) {
            setState(() {
              _selectedRegion = value!;
            });
          },
          functionOnTap: () {
            setState(() {
              _selectedRegion = '';
            });
          },
          hintText: 'Región*',
          icon: Icons.location_on_outlined,
        );
      },
    );
  }

  Widget _buildLocationField(BuildContext context) {
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
        CustomField(
          controller: _ubicacionController,
          hintText: 'Ubicación (dirección)',
          icon: Icons.location_on_outlined,
          width: 50.0,
        ),
      ],
    );
  }

  Widget _buildObservationsField() {
    return CustomField(
      controller: _observationsController,
      hintText: 'Observaciones*',
      icon: null,
      minLines: 6,
      maxLines: 6,
      paddingTop: 20,
      paddingLeft: 20,
    );
  }

  Widget _buildSubmitButton(
      NetworkService networkService, UiProvider uiProvider, Size mq) {
    return Center(
      child: CustomButton(
        mq: mq,
        function: networkService.isLoading
            ? null
            : () => _submitForm(networkService, uiProvider),
        color: networkService.isLoading ? greyColor : blueColor,
        colorText: whiteColor,
        text: networkService.isLoading ? 'Cargando...' : 'Enviar Solicitud',
        height: 0.05,
      ),
    );
  }

  Future<void> _submitForm(
      NetworkService networkService, UiProvider uiProvider) async {
    final authService = Provider.of<AuthService>(context, listen: false);

    FocusScope.of(context).unfocus();

    if (_caseNumberController.text.isEmpty ||
        _selectedTechnology.isEmpty ||
        _ubicacionController.text.isEmpty ||
        _observationsController.text.isEmpty ||
        _selectedRegion.isEmpty) {
      CustomShowDialog.alert(
        context: context,
        title: 'Error',
        message: 'Debes diligenciar los campos obligatorios.',
      );
      return;
    }

    String clasificador = 'cierre_masivo';

    final Map? resp = await networkService.postNetwork(
      numero_ticket: _caseNumberController.text,
      tecnologia: _selectedTechnology,
      direccion: _ubicacionController.text,
      observacion: _observationsController.text,
      region: _selectedRegion,
      clasificador: clasificador,
    );

    if (resp!['type'] == 'errorAuth') {
      final String logoutResp = await authService.logout();

      if (logoutResp == 'OK') {
        uiProvider.selectedMenuOpt = 0;
        uiProvider.selectedMenuName = 'Autogestión Terreno';
        Navigator.pushReplacementNamed(context, 'login');
      }

      return;
    }

    if (resp['type'] == 'error') {
      CustomShowDialog.alert(
        context: context,
        title: 'Error',
        message: resp['message'],
      );
    } else {
      CustomShowDialog.alert(
        context: context,
        title: 'Excelente',
        message: resp['message'],
      );

      await Future.delayed(const Duration(milliseconds: 500));

      uiProvider.selectedMenuOpt = 99;
      uiProvider.selectedMenuName = 'Network';

      await Future.delayed(const Duration(seconds: 1));

      uiProvider.selectedMenuOpt = 24;
      uiProvider.selectedMenuName = 'Network';
    }
  }

  Widget _buildFloatingActionButton(UiProvider uiProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomButtom(
          icon: Icons.list_rounded,
          onPressed: () {
            // setState(() {
            //   uiProvider.selectedMenuOpt = 24;
            //   uiProvider.selectedMenuName = 'Network';
            // });
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListMassFaultPage()),
            );
          },
          heroTag: 'listCon',
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
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
}
