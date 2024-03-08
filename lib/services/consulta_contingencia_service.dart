import 'dart:convert';

import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/models/consulta_gpon_model.dart';
import 'package:autogestion_tecnico/services/services.dart';
import 'package:flutter/foundation.dart';
//import 'package:autogestion_tecnico/services/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ConsultaGponService extends ChangeNotifier {
  final String _baseUrl = baseUrl;
  final String _ruta =
      '/autogestion-terreno-api-dev/controllers/ContingenciaCtrl.php';
  final storage = const FlutterSecureStorage();

  List<GPON> gpon = [];
  bool isLoading = false;

  Future<List?> consultaContingencia({
    required String tarea,
  }) async {
    try {
      gpon = [];
      isLoading = true;
      notifyListeners();

      final String? token = await storage.read(key: 'token');

      final Map<String, dynamic> data = {
        "method": "consultaContingencia",
        "data": {"tarea": tarea}
      };

      final url = Uri.https(_baseUrl, _ruta, {
        'tarea': tarea,
      });

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
        gpon = [];
        isLoading = false;
        notifyListeners();
        return resp;
      }

      if (decodeResp['type'] == 'success') {
        final newResponse = newReponseConsultaGponFromJson(resp.body);
        gpon.addAll(newResponse.gpon);
      }

      /*List<Map<String, String>> respbody = [
        {'type': decodeResp['type'], 'message': decodeResp['message']}
      ];*/
      isLoading = false;
      notifyListeners();

      return null;
    } catch (e) {
      NotificactionService.showSnackBar(e.toString());
    }
    return null;
  }
}
