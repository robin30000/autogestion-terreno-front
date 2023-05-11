import 'dart:convert';
import 'package:autogestion_tecnico/models/consulta_queja_model.dart';
import 'package:autogestion_tecnico/services/services.dart';
import 'package:flutter/foundation.dart';

//import 'package:autogestion_tecnico/services/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:autogestion_tecnico/global/globals.dart';

class ConsultaQuejasService extends ChangeNotifier {
  final String _baseUrl = baseUrl;
  final storage = const FlutterSecureStorage();

  List<QUEJAS> quejas = [];
  bool isLoading = false;

  Future<List?> getQueja({
    required String pedido,
  }) async {
    try {
      quejas = [];
      isLoading = true;
      notifyListeners();

      final String? token = await storage.read(key: 'token');

      final url = Uri.http(_baseUrl, '/autogestionterreno/getQuejas', {
        'pedido': pedido,
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
        quejas = [];
        isLoading = false;
        notifyListeners();
        return resp;
      }

      if (decodeResp['type'] == 'success') {
        final newResponse = newReponseConsultaquejaFromJson(resp.body);
        quejas.addAll(newResponse.quejas);
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
