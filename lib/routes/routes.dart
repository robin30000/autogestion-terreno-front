import 'package:flutter/material.dart';

import 'package:autogestion_tecnico/pages/pages.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder> {
    "splash": (BuildContext context) => const Splash(),
    'home' : (BuildContext context) => const MasterPage(),
    
    /* 'signup' : (BuildContext context) => const SignupPage(),
    "login": (BuildContext context) => const Login(),
    "recovery": (BuildContext context) => const RecoveryPage(),
    
    'onBoarding' : (BuildContext context) => const Onboarding(),
    
    'perfil' : (BuildContext context) => Perfil(),
    
    'listar_chats' : (BuildContext context) => const ListarChats(),
    'crear_aviso' : (BuildContext context) => const CrearAviso(), */
  };
}
