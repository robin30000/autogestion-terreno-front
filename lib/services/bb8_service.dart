import 'dart:convert';

import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class BB8Service extends ChangeNotifier {
  final String _baseUrl = baseUrl;
  final String _ruta = '/autogestion-terreno-api-dev/controllers/Bb8Ctrl.php';
  final storage = const FlutterSecureStorage();

  List<Map<String, dynamic>> categoria = [];

  List<BB8> bb8 = [];
  bool isLoading = false;

  BB8Service() {
    limpiar();
  }

  Future<List?> getBB8({
    required String ciudad,
    required String direccion,
  }) async {
    try {
      bb8 = [];

      isLoading = true;
      notifyListeners();

      final String? token = await storage.read(key: 'token');

      final Map<String, dynamic> data = {
        "data": {'direccion': direccion, 'ciudad': ciudad},
        "method": "consultaBb8"
      };

      final url = Uri.https(
        _baseUrl,
        _ruta,
      );

      final resp = await http.post(url,
          headers: {'Content-Type': 'application/json', 'x-token': token!},
          body: jsonEncode(data));

      final Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (decodeResp['type'] == 'errorAuth') {
        List<Map<String, String>> resp = [
          {'type': decodeResp['type'], 'message': decodeResp['message']}
        ];
        isLoading = false;
        notifyListeners();
        return resp;
      }

      if (decodeResp['type'] == 'error') {
        List<Map<String, String>> resp = [
          {'type': decodeResp['type'], 'message': decodeResp['message']}
        ];
        bb8 = [];
        isLoading = false;
        notifyListeners();
        return resp;
      }

      if (decodeResp['type'] == 'success') {
        final newResponse = newReponseBb8FromJson(resp.body);
        bb8.addAll(newResponse.bb8);
      }

      isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List?> getBB8Equipos({
    required String pedido,
  }) async {
    try {
      bb8 = [];
      isLoading = true;
      notifyListeners();

      final String? token = await storage.read(key: 'token');

      final Map<String, dynamic> data = {
        "data": {'pedido': pedido},
        "method": "getBB8Equipos"
      };

      final url = Uri.https(_baseUrl, _ruta);

      final resp = await http.post(url,
          headers: {'Content-Type': 'application/json', 'x-token': token!},
          body: jsonEncode(data));

      final Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (decodeResp['type'] == 'errorAuth') {
        List<Map<String, String>> resp = [
          {'type': decodeResp['type'], 'message': decodeResp['message']}
        ];
        isLoading = false;
        notifyListeners();
        return resp;
      }

      if (decodeResp['type'] == 'error') {
        List<Map<String, String>> resp = [
          {'type': decodeResp['type'], 'message': decodeResp['message']}
        ];
        bb8 = [];
        isLoading = false;
        notifyListeners();
        return resp;
      }

      if (decodeResp['type'] == 'success') {
        final newResponse = newReponseBb8FromJson(resp.body);
        bb8.addAll(newResponse.bb8);
      }

      isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getCategoriaBb8() async {
    categoria = [
      {'name': 'Seleccione*', 'value': '', 'state': true},
      {'name': 'Consultar dirección', 'value': 'direccion', 'state': true},
      {'name': 'Consulta datos técnicos', 'value': 'equipos', 'state': true},
    ];
    return categoria;
  }

  limpiar() async {
    bb8.clear();
  }
}
