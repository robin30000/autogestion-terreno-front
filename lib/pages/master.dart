import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/pages/pages.dart';
import 'package:autogestion_tecnico/providers/ui_provider.dart';
import 'package:autogestion_tecnico/services/services.dart';

class MasterPage extends StatefulWidget {
  const MasterPage({super.key});

  @override
  State<MasterPage> createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UiProvider>(context);
    final authServices = Provider.of<AuthService>(context);
    final mq = MediaQuery.of(context).size;

    return AdvancedDrawer(
      backdropColor: blueBlackColor,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        // NOTICE: Uncomment if you want to add shadow behind the page.
        // Keep in mind that it may cause animation jerks.
        // boxShadow: <BoxShadow>[
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 0.0,
        //   ),
        // ],
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: SafeArea(
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 128.0,
                height: 128.0,
                margin: const EdgeInsets.only(
                  top: 24.0,
                  bottom: 64.0,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/img/logo-white.png',
                ),
              ),
              FutureBuilder(
                future: authServices.readMenu(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.data == '') {
                    return Container();
                  }

                  dynamic menus = jsonDecode(snapshot.data);

                  return Column(
                    children: [
                      for (int i = 0; i < menus.length; i++)
                        if (menus[i]['estado'])
                          ListTile(
                            onTap: () {
                              _advancedDrawerController.hideDrawer();
                              uiProvider.selectedMenuOpt = menus[i]['menuOpt'];
                              uiProvider.selectedMenuName =
                                  menus[i]['pageName'];
                            },
                            leading: Icon(
                              IconData(menus[i]['menuIcon'],
                                  fontFamily: 'MaterialIcons'),
                              size: mq.width * 0.08,
                            ),
                            title: Text(
                              menus[i]['menuName'],
                              style: TextStyle(fontSize: mq.width * 0.05),
                            ),
                          )
                    ],
                  );
                },
              ),
              const Spacer(),
              DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: const Text('Version 1.2.2'),
                ),
              ),
            ],
          ),
        ),
      ),

      child: Scaffold(
        appBar: AppBar(
          title: Text(uiProvider.selectedMenuName),
          actions: [
            (uiProvider.connectionStatusProvider == ConnectivityResult.wifi)
                ? Icon(
                    Icons.wifi,
                    color: uiProvider.isDeviceConnectedProvider
                        ? greenColor
                        : redColor,
                  )
                : (uiProvider.connectionStatusProvider ==
                        ConnectivityResult.mobile)
                    ? Icon(
                        Icons.cell_tower,
                        color: uiProvider.isDeviceConnectedProvider
                            ? greenColor
                            : redColor,
                      )
                    : const Icon(Icons.public_off),
            IconButton(
              icon: const Icon(Icons.exit_to_app_rounded),
              tooltip: 'Cerrar sesión',
              onPressed: () async {
                /* ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cerrando sesion'))
                ); */

                final authService =
                    Provider.of<AuthService>(context, listen: false);

                final String resp = await authService.logout();

                if (resp == 'OK') {
                  uiProvider.selectedMenuOpt = 0;
                  uiProvider.selectedMenuName = 'Autogestión Terreno';
                  Navigator.pushReplacementNamed(context, 'login');
                }
              },
            ),
          ],
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
        ),
        body: const ScreenPage(),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
