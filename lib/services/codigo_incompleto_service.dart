import 'dart:convert';

import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class CodigoIncompletoService extends ChangeNotifier {
  final String _baseUrl = baseUrl;
  final storage = const FlutterSecureStorage();
  List<Map<String, dynamic>> tipoCodigo = [];
  List<Map<String, dynamic>> catCodigo = [];
  bool isLoading = false;

  Future<List?> getCodigoIncompleto(
      {required String tarea,
      required String tipoCodigo,
      required String catCodigo}) async {
    try {
      isLoading = true;
      notifyListeners();

      final String? token = await storage.read(key: 'token');

      final Map<String, dynamic> codigoData = {
        "codigo": tarea,
        "tipo": tipoCodigo,
        "categoria": catCodigo
      };

      final url =
          Uri.https(_baseUrl, '/autogestionterreno/getcodigoincompleto');

      final resp = await http.post(url,
          headers: {'Content-Type': 'application/json', 'x-token': token!},
          body: json.encode(codigoData));

      final Map<String, dynamic> decodeResp = json.decode(resp.body);

      //final Map<String, dynamic> decodeResp = json.decode(resp.body);

      // final url =
      //     Uri.https(_baseUrl, '/autogestionterreno/getcodigoincompleto', {
      //   'tarea': tarea,
      // });

      // final resp = await http.post(url,
      //     headers: {'Content-Type': 'application/json', 'x-token': token!});

      // final Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (decodeResp['type'] == 'errorAuth') {
        List<Map<String, String>> resp = [
          {'type': decodeResp['type'], 'message': decodeResp['message']}
        ];
        isLoading = false;
        notifyListeners();
        return resp;
      }

      List<Map<String, String>> respbody = [
        {'type': decodeResp['type'], 'message': decodeResp['message']}
      ];
      isLoading = false;
      notifyListeners();

      return respbody;
    } catch (e) {
      NotificactionService.showSnackBar(e.toString());
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getCategoriaCodigo() async {
    catCodigo = [
      {'name': 'Tipo código*', 'value': '', 'state': true},
      {'name': 'Salesforce', 'value': 'Salesforce', 'state': true},
      {'name': 'Incompleto click', 'value': 'click', 'state': true},
    ];
    return catCodigo;
  }

  Future<List<Map<String, dynamic>>> getTipoCodigo() async {
    tipoCodigo = [
      {'name': 'Seleccione código*', 'value': '', 'state': true},
      {'name': 'Completo', 'value': 'completo', 'state': true},
      {'name': 'Incompleto', 'value': 'incompleto', 'state': true},
    ];
    return tipoCodigo;
  }
}
