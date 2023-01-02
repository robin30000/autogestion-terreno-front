import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:autogestion_tecnico/pages/pages.dart';
import 'package:autogestion_tecnico/providers/providers.dart';

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
        
      default:
        return const LoaderPage();
    }
  }
}