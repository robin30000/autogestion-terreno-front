import 'dart:convert';

import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/models/models.dart';
import 'package:autogestion_tecnico/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class SoporteEtpService extends ChangeNotifier {
  final String _baseUrl = baseUrl;
  final storage = const FlutterSecureStorage();

  List<SoporteEtp> soporteetp = [];
  List<Map<String, dynamic>> tipoAccion = [];
  List<ValidaPedido> response = [];
  bool isLoading = false;

  SoporteEtpService() {
    getsoporteetpbyuser();
  }

  getsoporteetpbyuser() async {
    try {
      soporteetp = [];

      isLoading = true;
      notifyListeners();

      final String? token = await storage.read(key: 'token');

      final url =
          Uri.https(_baseUrl, '/autogestionterreno-dev/getsoporteetpbyuser');

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
        final newResponse = newReponseSoporteEtpFromJson(resp.body);
        soporteetp.addAll(newResponse.soporteetp);
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      NotificactionService.showSnackBar(e.toString());
    }
  }

  Future<Map<String, dynamic>?> validaPedido({
    required String pedido,
  }) async {
    try {
      response = [];

      //isLoading = true;
      //notifyListeners();

      final String? token = await storage.read(key: 'token');

      final url = Uri.https(_baseUrl, '/autogestionterreno-dev/validapedidoetp',
          {'tarea': pedido});

      final resp = await http.get(url,
          headers: {'Content-Type': 'application/json', 'x-token': token!});

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

  Future<List<Map<String, dynamic>>> getTipoAccion() async {
    tipoAccion = [
      {'name': 'Accion*', 'value': '', 'state': true},
      {
        'name': 'Aprovisionamiento Equipos',
        'value': 'Aprovisionamiento Equipos',
        'state': true
      },
      {'name': 'Cambio equipo', 'value': 'Cambio equipo', 'state': true},
      {'name': 'Cambio domicilio', 'value': 'Cambio domicilio', 'state': true},
      {
        'name': 'Entrega de códigos',
        'value': 'Entrega de códigos',
        'state': true
      },
      {'name': 'Replanteo', 'value': 'Replanteo', 'state': true},
    ];
    return tipoAccion;
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
    /* required String numeroContacto,
    required String nombreContacto, */
    required String observacion,
    required String replanteo,
    required String accion,
    required String macSale,
    required String macEntra,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final String? token = await storage.read(key: 'token');

      final Map<String, dynamic> soporteEtpData = {
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
        /* "numero_contacto": numeroContacto,
        "nombre_contacto": nombreContacto, */
        "observacion": observacion,
        "replanteo": replanteo,
        "accion": accion,
        "macSale": macSale,
        "macEntra": macEntra,
      };

      final url = Uri.https(_baseUrl, '/autogestionterreno-dev/postpedidoetp');

      final resp = await http.post(url,
          headers: {'Content-Type': 'application/json', 'x-token': token!},
          body: json.encode(soporteEtpData));

      final Map<String, dynamic> decodeResp = json.decode(resp.body);

      isLoading = false;
      notifyListeners();

      return decodeResp;
    } catch (e) {
      NotificactionService.showSnackBar(e.toString());
    }
    return null;
  }
}
