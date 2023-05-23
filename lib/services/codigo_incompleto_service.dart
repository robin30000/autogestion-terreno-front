import 'dart:convert';

import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class CodigoIncompletoService extends ChangeNotifier {
  final String _baseUrl = baseUrl;
  final storage = const FlutterSecureStorage();

  bool isLoading = false;

  Future<List?> getCodigoIncompleto({
    required String tarea,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final String? token = await storage.read(key: 'token');

      final url =
          Uri.http(_baseUrl, '/autogestionterreno/getcodigoincompleto', {
        'tarea': tarea,
      });

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
}
