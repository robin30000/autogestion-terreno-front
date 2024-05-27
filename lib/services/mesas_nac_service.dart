import 'dart:convert';

import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/models/models.dart';
import 'package:autogestion_tecnico/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class MesasNacionalesService extends ChangeNotifier {
  final String _baseUrl = baseUrl;
  final storage = const FlutterSecureStorage();

  List<MesasNacionales> soporteMn = [];
  List<Map<String, dynamic>> accion1 = [];
  List<Map<String, dynamic>> accion2 = [];

  List<ValidaPedido> response = [];
  bool isLoading = false;

  MesasNacionalesService() {
    getsoporteetpbyuser();
  }

  getsoporteetpbyuser() async {
    try {
      soporteMn = [];

      isLoading = true;
      notifyListeners();

      final String? token = await storage.read(key: 'token');

      final url = Uri.https(_baseUrl, '/autogestionterreno/getsoporteMnbyuser');

      final resp = await http.get(url,
          headers: {'Content-Type': 'application/json', 'x-token': token!});

      final Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (decodeResp['type'] == 'errorAuth') {
        List<Map<String, String>> resp = [
          {'type': decodeResp['type'], 'message': decodeResp['message']}
        ];
        isLoading = false;
        notifyListeners();
        return resp;
      }

      if (decodeResp['type'] == 'success') {
        final newResponse = newReponseMesasNacionalesFromJson(resp.body);
        soporteMn.addAll(newResponse.soporteMn);
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>?> validaPedido({
    required String pedido,
  }) async {
    try {
      response = [];

      isLoading = true;
      notifyListeners();

      final String? token = await storage.read(key: 'token');

      final url = Uri.https(
          _baseUrl, '/autogestionterreno/validaPedidoMn', {'tarea': pedido});

      final resp = await http.get(url,
          headers: {'Content-Type': 'application/json', 'x-token': token!});

      final Map<String, dynamic> decodeResp = json.decode(resp.body);

      isLoading = false;
      notifyListeners();
      return decodeResp;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAccion1() async {
    accion1 = [
      {'name': 'Acción*', 'value': '', 'state': true},
      {'name': 'Línea básica', 'value': 'Línea básica', 'state': true},
      {'name': 'Cambio de puerto', 'value': 'Cambio de puerto', 'state': true},
      {'name': 'Soporte general', 'value': 'Soporte general', 'state': true},
      {
        'name': 'Código de incompleto',
        'value': 'Código de incompleto',
        'state': true
      },
    ];
    return accion1;
  }

  Future<List<Map<String, dynamic>>> getAccion2() async {
    accion2 = [
      {'name': 'Acción*', 'value': '', 'state': true},
      {
        'name': 'Código de completo',
        'value': 'Código de completo',
        'state': true
      },
      {
        'name': 'Código de incompleto',
        'value': 'Código de incompleto',
        'state': true
      },
      {
        'name': 'Validación de parámetros',
        'value': 'Validación de parámetros',
        'state': true
      },
      {'name': 'Soporte general', 'value': 'Soporte general', 'state': true}
    ];
    return accion2;
  }

  Future<List<Map<String, dynamic>>> accionGecoLight() async {
    accion2 = [
      {'name': 'Acción*', 'value': '', 'state': true},
      {
        'name': 'Actividad requiere escalera',
        'value': 'Actividad requiere escalera',
        'state': true
      },
      {
        'name': 'Actividad requiere herramientas',
        'value': 'Actividad requiere herramientas',
        'state': true
      },
      {
        'name': 'Actividad requiere Materiales',
        'value': 'Actividad requiere Materiales',
        'state': true
      },
      {
        'name': 'No corresponde a cambio de equipo',
        'value': 'No corresponde a cambio de equipo',
        'state': true
      },
      {'name': 'Ubicar Usuario', 'value': 'Ubicar Usuario', 'state': true},
      {
        'name': 'Nivelar ruta lejana',
        'value': 'Nivelar ruta lejana',
        'state': true
      },
      {
        'name': 'Cambio de distrito',
        'value': 'Cambio de distrito',
        'state': true
      },
      {
        'name': 'Código de completo',
        'value': 'Código de completo',
        'state': true
      },
      {
        'name': 'Código de incompleto',
        'value': 'Código de incompleto',
        'state': true
      },
      {
        'name': 'Validación de parámetros',
        'value': 'Validación de parámetros',
        'state': true
      },
      {'name': 'Soporte general', 'value': 'Soporte general', 'state': true}
    ];
    return accion2;
  }

  Future<List<Map<String, dynamic>>> accionGecoMedio() async {
    accion2 = [
      {'name': 'Acción*', 'value': '', 'state': true},
      {
        'name': 'Requiere escalera (Realizar acometida)',
        'value': 'Requiere escalera (Realizar acometida)',
        'state': true
      },
      {
        'name': 'No corresp. a precableado o extensión',
        'value': 'No corresp. a precableado o extensión',
        'state': true
      },
      {'name': 'Ubicar Usuario', 'value': 'Ubicar Usuario', 'state': true},
      {
        'name': 'Nivelar ruta lejana',
        'value': 'Nivelar ruta lejana',
        'state': true
      },
      {
        'name': 'Cambio de distrito',
        'value': 'Cambio de distrito',
        'state': true
      },
      {
        'name': 'Código de completo',
        'value': 'Código de completo',
        'state': true
      },
      {
        'name': 'Código de incompleto',
        'value': 'Código de incompleto',
        'state': true
      },
      {
        'name': 'Validación de parámetros',
        'value': 'Validación de parámetros',
        'state': true
      },
      {'name': 'Soporte general', 'value': 'Soporte general', 'state': true}
    ];
    return accion2;
  }

  Future<Map?> postContingencia({
    required String tarea,
    required String observacion,
    required String accion,
    required String ata,
    required String macSale,
    required String macEntra,
    required String tipoSolicitud,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final String? token = await storage.read(key: 'token');

      final Map<String, dynamic> soporteMnData = {
        "tarea": tarea,
        "observacion": observacion,
        "accion": accion,
        "macSale": macSale,
        "macEntra": macEntra,
        "ata": ata,
        "tipoSolicitud": tipoSolicitud
      };

      final url = Uri.https(_baseUrl, '/autogestionterreno/postPedidoMn');

      final resp = await http.post(url,
          headers: {'Content-Type': 'application/json', 'x-token': token!},
          body: json.encode(soporteMnData));

      final Map<String, dynamic> decodeResp = json.decode(resp.body);

      isLoading = false;
      notifyListeners();

      return decodeResp;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
