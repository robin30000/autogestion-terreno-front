import 'dart:convert';

import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class MesasNacionalesService extends ChangeNotifier {
  final String _baseUrl = baseUrl;
  final String _ruta =
      '/autogestion-terreno-api-dev/controllers/MesasNacionalesCtrl.php';
  final storage = const FlutterSecureStorage();

  List<MesasNacionales> soporteMn = [];
  List<Map<String, dynamic>> accion1 = [];
  List<Map<String, dynamic>> accion2 = [];

  List<ValidaPedido> response = [];
  bool isLoading = false;

  MesasNacionalesService() {
    getSoporteMesasNacionalesByUser();
  }

  getSoporteMesasNacionalesByUser() async {
    try {
      soporteMn = [];

      isLoading = true;
      notifyListeners();

      final String? token = await storage.read(key: 'token');

      final url = Uri.https(_baseUrl, _ruta);

      final Map<String, dynamic> data = {
        "method": "getSoporteMesasNacionalesByUser"
      };

      final resp = await http.post(url,
          headers: {'Content-Type': 'application/json', 'x-token': token!},
          body: jsonEncode(data));

      final Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (decodeResp['type'] == 'errorAuth') {
        List<Map<String, String>> resp = [
          {'type': decodeResp['type'], 'message': decodeResp['message']}
        ];
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
      final Map<String, dynamic> data = {
        "method": "validaPedidoMn",
        "data": {'tarea': pedido}
      };

      final url = Uri.https(_baseUrl, _ruta);

      final resp = await http.post(url,
          headers: {'Content-Type': 'application/json', 'x-token': token!},
          body: jsonEncode(data));

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

  Future<Map?> postContingencia({
    required String tarea,
    required String observacion,
    required String accion,
    required String ata,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final String? token = await storage.read(key: 'token');

      final Map<String, dynamic> data = {
        "data": {
          "tarea": tarea,
          "observacion": observacion,
          "accion": accion,
          "ata": ata
        },
        "method": "postPedidoMn"
      };

      final url = Uri.https(_baseUrl, _ruta);

      final resp = await http.post(url,
          headers: {'Content-Type': 'application/json', 'x-token': token!},
          body: json.encode(data));

      final Map<String, dynamic> decodeResp = json.decode(resp.body);

      print(decodeResp.toString());

      isLoading = false;
      notifyListeners();

      return decodeResp;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
