import 'dart:async';

import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/pages/pages.dart';
import 'package:autogestion_tecnico/providers/providers.dart';
import 'package:autogestion_tecnico/routes/routes.dart';
import 'package:autogestion_tecnico/services/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppInit());
}

class AppInit extends StatefulWidget {
  const AppInit({super.key});

  @override
  State<AppInit> createState() => _AppInitState();
}

class _AppInitState extends State<AppInit> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => UiProvider()),
        ChangeNotifierProvider(create: (_) => ContingenciaService()),
        ChangeNotifierProvider(create: (_) => SoporteGponService()),
        ChangeNotifierProvider(create: (_) => SoporteEtpService()),
        ChangeNotifierProvider(create: (_) => BB8Service()),
        ChangeNotifierProvider(create: (_) => CodigoIncompletoService()),
        ChangeNotifierProvider(create: (_) => ConsultaGponService()),
        ChangeNotifierProvider(create: (_) => ConsultaQuejasService()),
        ChangeNotifierProvider(create: (_) => RegistroEquiposService()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDeviceConnected = false;

  ConnectivityResult connectionStatus = ConnectivityResult.none;
  final Connectivity connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    connectivitySubscription =
        connectivity.onConnectivityChanged.listen(updateConnectionStatus);
  }

  @override
  void dispose() {
    print('ACTIVO DISPOSE DE MASTER');
    connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Autogestión Técnico',
        initialRoute: 'splash',
        routes: getApplicationRoutes(),
        theme: ThemeData(
          fontFamily: 'Rubik',
          primarySwatch: blueColorMt,
        ),
        scaffoldMessengerKey: NotificactionService.messagerKey,
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => const Splash());
        });
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;

    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e);
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return updateConnectionStatus(result);
  }

  Future<void> updateConnectionStatus(ConnectivityResult result) async {
    final uiProvider = Provider.of<UiProvider>(context, listen: false);

    if (result != connectionStatus) {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      connectionStatus = result;

      uiProvider.connectionStatusProvider = result;
      uiProvider.isDeviceConnectedProvider = isDeviceConnected;
    }
  }
}
