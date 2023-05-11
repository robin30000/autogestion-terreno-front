import 'dart:convert';

import 'package:autogestion_tecnico/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/models/models.dart';

class SoporteGponService extends ChangeNotifier {
  final String _baseUrl = baseUrl;
  final storage = const FlutterSecureStorage();

  List<SoporteGpon> soportegpon = [];
  bool isLoading = false;

  SoporteGponService() {
    getSoporteGponByUser();
  }

  getSoporteGponByUser() async {
    try {
      soportegpon = [];

      isLoading = true;
      notifyListeners();

      final String? token = await storage.read(key: 'token');

      final url =
          Uri.http(_baseUrl, '/autogestionterreno/getsoportegponbyuser');

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
        final newResponse = newReponseSoporteGponFromJson(resp.body);
        soportegpon.addAll(newResponse.soportegpon);
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      NotificactionService.showSnackBar(e.toString());
    }
  }

  Future<Map?> postContingencia({
    required String tarea,
    required String arpon,
    required String nap,
    required String hilo,
    required String internetPort1,
    required String internetPort2,
    required String internetPort3,
    required String internetPort4,
    required String tvPort1,
    required String tvPort2,
    required String tvPort3,
    required String tvPort4,
    required String numeroContacto,
    required String nombreContacto,
    required String observacion,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final String? token = await storage.read(key: 'token');

      final Map<String, dynamic> soportegponData = {
        "tarea": tarea,
        "arpon": arpon,
        "nap": nap,
        "hilo": hilo,
        "internet_port1": internetPort1,
        "internet_port2": internetPort2,
        "internet_port3": internetPort3,
        "internet_port4": internetPort4,
        "tv_port1": tvPort1,
        "tv_port2": tvPort2,
        "tv_port3": tvPort3,
        "tv_port4": tvPort4,
        "numero_contacto": numeroContacto,
        "nombre_contacto": nombreContacto,
        "observacion": observacion,
      };

      final url = Uri.http(_baseUrl, '/autogestionterreno/postsoportegpon');

      final resp = await http.post(url,
          headers: {'Content-Type': 'application/json', 'x-token': token!},
          body: json.encode(soportegponData));

      final Map<String, dynamic> decodeResp = json.decode(resp.body);

      isLoading = false;
      notifyListeners();

      return decodeResp;
    } catch (e) {
      NotificactionService.showSnackBar(e.toString());
    }
  }
}
