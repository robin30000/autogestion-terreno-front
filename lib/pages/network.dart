import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/pages/pages.dart';
import 'package:autogestion_tecnico/services/services.dart';
import 'package:autogestion_tecnico/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart'; // Importa Cupertino

import '../services/auth_service.dart';

class NetworkPage extends StatelessWidget {
  const NetworkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthService>(context, listen: false);
    final mq = MediaQuery.of(context).size;
    authServices.getMenuApp();

    return Scaffold(
      backgroundColor: Colors.grey[200], // Fondo suave para la página
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: mq.height * 0.05), // Espacio superior
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 6.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
                child: Text(
                  'Network',
                  style: TextStyle(
                    color: blueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: mq.width * 0.08,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // SizedBox(height: 20.0), // Espacio entre el título y los botones
              // CustomDivider(mq: mq, colors: [
              //   whiteColor,
              //   blueColor,
              //   whiteColor,
              // ]),
              const SizedBox(height: 20.0),
              _buildMenuButton(
                context,
                'Cierre Masivo de Tiquetes',
                const MassFaultSolutionPage(),
                CupertinoIcons.ticket, // Icono representativo de Cupertino
              ),
              _buildMenuButton(
                context,
                'Cierre de Fallas Individuales',
                const IndividualFaultClosurePage(),
                CupertinoIcons
                    .exclamationmark_circle, // Icono representativo de Cupertino
              ),
              _buildMenuButton(
                context,
                'Avances y Hora Esperada',
                const AdvanceMassTicketPage(),
                CupertinoIcons.time, // Icono representativo de Cupertino
              ),
              _buildMenuButton(
                context,
                'Reporte Filtrado Bocas de Tap',
                const MassFaultSolutionPage(),
                CupertinoIcons.list_bullet, // Icono representativo de Cupertino
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
      BuildContext context, String title, Widget page, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(9, 25, 62, 1),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 5.0,
          shadowColor: Colors.black45,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 24,
              color: Colors.white,
            ),
            SizedBox(width: 10), // Espacio entre el icono y el texto
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                //fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
