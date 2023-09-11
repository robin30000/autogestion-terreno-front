import 'dart:convert';

import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/models/models.dart';
import 'package:autogestion_tecnico/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class BB8Service extends ChangeNotifier {
  final String _baseUrl = baseUrl;
  final storage = const FlutterSecureStorage();

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
      NotificactionService.showSnackBar(e.toString());
    }
    return null;
  }

  limpiar() async {
    bb8.clear();
  }
}
