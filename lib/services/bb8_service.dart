import 'dart:convert';

import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class BB8Service extends ChangeNotifier {
  final String _baseUrl = baseUrl;
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

      //isLoading = true;
      notifyListeners();

      final String? token = await storage.read(key: 'token');

      final url = Uri.https(_baseUrl, '/autogestionterreno/getbb8',
          {'direccion': direccion, 'ciudad': ciudad});

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
      //isLoading = true;
      notifyListeners();

      final String? token = await storage.read(key: 'token');

      final url =
          Uri.https(_baseUrl, '/autogestionterreno/getbb8', {'pedido': pedido});

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
        print('ACA ${bb8}');
      }

      isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List?> getBB8Puertos({
    required String olt,
    required String arpon,
    required String nap,
  }) async {
    try {
      bb8 = [];
      //isLoading = true;
      notifyListeners();

      final String? token = await storage.read(key: 'token');

      final url = Uri.https(_baseUrl, '/autogestionterreno/getbb8Puertos',
          {'olt': olt, 'arpon': arpon, 'nap': nap});

      final resp = await http.get(url,
          headers: {'Content-Type': 'application/json', 'x-token': token!});

      final Map<String, dynamic> decodeResp = json.decode(resp.body);

      print(decodeResp);

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
        print('ACA ${bb8}');
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
      {'name': 'Consultar Dirección', 'value': 'direccion', 'state': true},
      {'name': 'Consulta Datos Técnicos', 'value': 'equipos', 'state': true},
      {'name': 'Consulta Ocupación Naps', 'value': 'puertos', 'state': true},
    ];
    return categoria;
  }

  limpiar() async {
    bb8.clear();
  }
}
