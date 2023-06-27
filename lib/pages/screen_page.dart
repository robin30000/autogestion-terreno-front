import 'package:autogestion_tecnico/pages/pages.dart';
import 'package:autogestion_tecnico/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenPage extends StatelessWidget {
  const ScreenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UiProvider>(context);

    final screenIndex = uiProvider.selectedMenuOpt;

    switch (screenIndex) {
      case 0:
        return const HomePage();

      case 1:
        return const ContingenciaPage();

      case 2:
        return const SoporteGponPage();

      case 3:
        return const ListContingenciaPage();

      case 4:
        return const ListSoporteGponPage();

      case 5:
        return const Bb8Page();

      case 6:
        return const CodigoIncompletoPage();

      case 7:
        return const ConsultaGponPage();

      case 8:
        return const ConsultaQuejasPage();

      case 9:
        return const TipsPage();

      case 10:
        return const ListQuejasGoPage();

      case 11:
        return const RegistroEquipos();

      case 12:
        return const ListEquipoPage();

      default:
        return const LoaderPage();
    }
  }
}
