import 'dart:convert';

import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ContingenciaService extends ChangeNotifier {
  final String _baseUrl = baseUrl;
  final String _ruta =
      '/autogestion-terreno-api-dev/controllers/ContingenciaCtrl.php';
  final storage = const FlutterSecureStorage();

  List<Registros> contingencias = [];
  bool isLoading = false;

  List<Map<String, dynamic>> tipoproducto = [];
  List<Map<String, dynamic>> listTipoContingencia = [];

  ContingenciaService() {
    getContingenciasByUser();
  }

  getContingenciasByUser() async {
    try {
      contingencias = [];

      isLoading = true;
      notifyListeners();

      final String? token = await storage.read(key: 'token');

      final Map<String, dynamic> data = {"method": "getContingenciaByUser"};

      final url = Uri.https(_baseUrl, _ruta);

      final resp = await http.post(url,
          headers: {'Content-Type': 'application/json', 'x-token': token!},
          body: jsonEncode(data));

      final Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (decodeResp['type'] == 'errorAuth') {
        List<Map<String, String>> resp = [
          {'type': decodeResp['type'], 'message': decodeResp['message']}
        ];
        return resp;
      }

      if (decodeResp['type'] == 'success') {
        final newResponse = newReponseContingenciaFromJson(resp.body);
        contingencias.addAll(newResponse.contingencia);
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<Map?> postContingencia(
      {required String pedido,
      required String observacion,
      required String tipoproducto,
      required String tipocontingencia,
      required String macentra,
      required String macsale}) async {
    try {
      isLoading = true;
      notifyListeners();

      final String? token = await storage.read(key: 'token');
      final Map<String, dynamic> data = {
        "method": "postContingencia",
        "data": {
          "pedido": pedido,
          "observacion": observacion,
          "tipoproducto": tipoproducto,
          "tipocontingencia": tipocontingencia,
          "macentra": macentra,
          "macsale": macsale,
        }
      };

      final url = Uri.https(_baseUrl, _ruta);

      final resp = await http.post(url,
          headers: {'Content-Type': 'application/json', 'x-token': token!},
          body: json.encode(data));

      final Map<String, dynamic> decodeResp = json.decode(resp.body);

      isLoading = false;
      notifyListeners();

      return decodeResp;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getTipoProducto() async {
    tipoproducto = [
      {'name': 'Tipo de producto*', 'value': '', 'state': true},
      {'name': 'TV', 'value': 'TV', 'state': true},
      {'name': 'Internet', 'value': 'Internet', 'state': true},
      {'name': 'ToIP', 'value': 'ToIP', 'state': true},
      {'name': 'Internet+Toip', 'value': 'Internet+Toip', 'state': true},
    ];
    return tipoproducto;
  }

  Future<List<Map<String, dynamic>>> getTipoContingencia(
      {String tipoProducto = ''}) async {
    switch (tipoProducto) {
      case 'ToIP':
        //listTipoContingencia = ['Reenvio de registros','Cambio de Equipo'];
        listTipoContingencia = [
          {'name': 'Tipo de contingencia*', 'value': '', 'state': true},
          {'name': 'Contingencia', 'value': 'Contingencia', 'state': false},
          {
            'name': 'Reenvio de registros',
            'value': 'Reenvio de registros',
            'state': true
          },
          {'name': 'Refresh', 'value': 'Refresh', 'state': false},
          {
            'name': 'Cambio de Equipo',
            'value': 'Cambio de Equipo',
            'state': true
          },
          {
            'name': 'Cambio Domicilio',
            'value': 'Cambio Domicilio',
            'state': true
          }
        ];
        break;

      case 'Internet':
        //listTipoContingencia = ['Contingencia','Cambio de Equipo'];
        listTipoContingencia = [
          {'name': 'Tipo de contingencia*', 'value': '', 'state': true},
          {'name': 'Contingencia', 'value': 'Contingencia', 'state': true},
          {
            'name': 'Forzar Cable Modem',
            'value': 'Forzar Cable Modem',
            'state': true
          },
          {
            'name': 'Reenvio de registros',
            'value': 'Reenvio de registros',
            'state': false
          },
          {'name': 'Refresh', 'value': 'Refresh', 'state': false},
          {
            'name': 'Cambio de Equipo',
            'value': 'Cambio de Equipo',
            'state': true
          },
          {
            'name': 'Cambio Domicilio',
            'value': 'Cambio Domicilio',
            'state': true
          }
        ];
        break;

      case 'TV':
        //listTipoContingencia = ['Contingencia','Refresh','Cambio de Equipo'];
        listTipoContingencia = [
          {'name': 'Tipo de contingencia*', 'value': '', 'state': true},
          {'name': 'Contingencia', 'value': 'Contingencia', 'state': true},
          {
            'name': 'Reenvio de registros',
            'value': 'Reenvio de registros',
            'state': false
          },
          {'name': 'Refresh', 'value': 'Refresh', 'state': true},
          {
            'name': 'Cambio de Equipo',
            'value': 'Cambio de Equipo',
            'state': true
          },
          {
            'name': 'Cambio Domicilio',
            'value': 'Cambio Domicilio',
            'state': true
          }
        ];
        break;

      case 'Internet+Toip':
        //listTipoContingencia = ['Contingencia','Reenvio de registros','Cambio de Equipo'];
        listTipoContingencia = [
          {'name': 'Tipo de contingencia*', 'value': '', 'state': true},
          {'name': 'Contingencia', 'value': 'Contingencia', 'state': true},
          {
            'name': 'Forzar Cable Modem',
            'value': 'Forzar Cable Modem',
            'state': true
          },
          {
            'name': 'Reenvio de registros',
            'value': 'Reenvio de registros',
            'state': true
          },
          {'name': 'Refresh', 'value': 'Refresh', 'state': false},
          {
            'name': 'Cambio de Equipo',
            'value': 'Cambio de Equipo',
            'state': true
          },
          {
            'name': 'Cambio Domicilio',
            'value': 'Cambio Domicilio',
            'state': true
          }
        ];
        break;

      default:
        //listTipoContingencia = ['Contingencia','Refresh','Cambio de Equipo'];
        listTipoContingencia = [
          {'name': 'Tipo de contingencia*', 'value': '', 'state': true},
          {'name': 'Contingencia', 'value': 'Contingencia', 'state': true},
          {
            'name': 'Reenvio de registros',
            'value': 'Reenvio de registros',
            'state': true
          },
          {'name': 'Refresh', 'value': 'Refresh', 'state': true},
          {
            'name': 'Cambio de Equipo',
            'value': 'Cambio de Equipo',
            'state': true
          },
          {
            'name': 'Cambio Domicilio',
            'value': 'Cambio Domicilio',
            'state': true
          }
        ];
        break;
    }

    return listTipoContingencia;
  }
}
