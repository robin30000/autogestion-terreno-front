import 'dart:convert';

import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/models/consulta_tarea_supervisor_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ConsultaTareaSuperService extends ChangeNotifier {
  final String _baseUrl = baseUrl;
  final storage = const FlutterSecureStorage();

  List<TAREASUPER> tareas = [];
  bool isLoading = false;

  Future<List?> getTareaSuper({
    required String tarea,
  }) async {
    try {
      tareas = [];
      //isLoading = true;
      notifyListeners();

      final String? token = await storage.read(key: 'token');

      final url = Uri.https(_baseUrl, '/autogestionterreno/tareasupervisor', {
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

      if (decodeResp['type'] == 'error') {
        List<Map<String, String>> resp = [
          {'type': decodeResp['type'], 'message': decodeResp['message']}
        ];
        tareas = [];
        isLoading = false;
        notifyListeners();
        return resp;
      }

      if (decodeResp['type'] == 'success') {
        final newResponse = newReponseConsultaTareaSuperFromJson(resp.body);
        tareas.addAll(newResponse.tareas);
      }

      isLoading = false;
      notifyListeners();

      return null;
    } catch (e) {
      print(e);
      //NotificactionService.showSnackBar(e.toString());
    }
    return null;
  }
}
