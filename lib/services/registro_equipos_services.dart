import 'dart:convert';

import 'package:autogestion_tecnico/global/globals.dart';
/* import 'package:autogestion_tecnico/models/models.dart'; */
/* import 'package:autogestion_tecnico/services/services.dart'; */
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/registro_equipos_model.dart';
import 'notification_service.dart';

class RegistroEquiposService extends ChangeNotifier {
  final String _baseUrl = baseUrl;
  final storage = const FlutterSecureStorage();

  List<RegistrosEq> equipos = [];
  List<ValidaPedido> response = [];
  bool isLoading = false;

  RegistroEquiposService() {
    getRegistroEquiposByUser();
  }

  Future<Map<String, dynamic>?> validaPedido({
    required String pedido,
  }) async {
    try {
      response = [];

      //isLoading = true;
      //notifyListeners();

      final String? token = await storage.read(key: 'token');

      final url =
          Uri.http(_baseUrl, '/autogestionterreno-dev/getregistropedido', {
        'pedido': pedido,
      });

      final resp = await http.get(url,
          headers: {'Content-Type': 'application/json', 'x-token': token!});

      //final Map<String, dynamic> decodeResp = json.decode(resp.body);
      final Map<String, dynamic> decodeResp = json.decode(resp.body);

      return decodeResp;
      /*  if (decodeResp['type'] == 'success') {
        final newResponse = NewReponseRegistroEquiposPedidoFromJson(resp.body);
        response.addAll(newResponse.pedido);
      } */

      //isLoading = true;
      //notifyListeners();
    } catch (e) {
      NotificactionService.showSnackBar(e.toString());
    }
    return null;
  }

  getRegistroEquiposByUser() async {
    try {
      equipos = [];

      isLoading = true;
      notifyListeners();

      final String? token = await storage.read(key: 'token');

      final url = Uri.http(
          _baseUrl, '/autogestionterreno-dev/getregistroequiposbyuser');

      final resp = await http.get(url,
          headers: {'Content-Type': 'application/json', 'x-token': token!});

      final Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (decodeResp['type'] == 'errorAuth') {
        List<Map<String, String>> resp = [
          {'type': decodeResp['type'], 'message': decodeResp['message']}
        ];
        return resp;
      }

      if (decodeResp['type'] == 'success') {
        final newResponse = NewReponseRegistroEquiposFromJson(resp.body);
        equipos.addAll(newResponse.equipos);
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      NotificactionService.showSnackBar(e.toString());
    }
  }

  Future<Map?> postContingencia({
    required String pedido,
    required String observacion,
    required String macentra,
  }) async {
    try {
      //isLoading = true;
      notifyListeners();

      final String? token = await storage.read(key: 'token');

      final Map<String, dynamic> contingenciaData = {
        "pedido": pedido,
        "observacion": observacion,
        "macentra": macentra,
      };

      final url =
          Uri.http(_baseUrl, '/autogestionterreno-dev/postregistroequipos');

      final resp = await http.post(url,
          headers: {'Content-Type': 'application/json', 'x-token': token!},
          body: json.encode(contingenciaData));

      final Map<String, dynamic> decodeResp = json.decode(resp.body);

      //isLoading = false;
      notifyListeners();

      return decodeResp;
    } catch (e) {
      NotificactionService.showSnackBar(e.toString());
    }
    return null;
  }
}
