import 'dart:convert';

import 'package:autogestion_tecnico/global/globals.dart';
import 'package:autogestion_tecnico/models/models.dart';
import 'package:autogestion_tecnico/services/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class NetworkService extends ChangeNotifier {
  final String _baseUrl = baseUrl;
  final storage = const FlutterSecureStorage();

  List<RegistrosNetwork> networks = [];
  bool isLoading = false;

  List<Map<String, dynamic>> region = [];
  List<Map<String, dynamic>> tecnologia = [];

  Future<Map?> postNetwork({
    required String numero_ticket,
    required String tecnologia,
    required String region,
    required String direccion,
    required String observacion,
    required String clasificador,
  }) async {
    try {
      //isLoading = true;
      notifyListeners();

      final String? token = await storage.read(key: 'token');

      final Map<String, dynamic> contingenciaData = {
        "numero_ticket": numero_ticket,
        "tecnologia": tecnologia,
        "direccion": direccion,
        "observacion": observacion,
        "region": region,
        "clasificador": clasificador,
      };

      final url = Uri.https(_baseUrl, '/autogestionterreno-dev/postNetwork');

      final resp = await http.post(url,
          headers: {'Content-Type': 'application/json', 'x-token': token!},
          body: json.encode(contingenciaData));

      final Map<String, dynamic> decodeResp = json.decode(resp.body);

      print(decodeResp);

      isLoading = false;
      notifyListeners();

      return decodeResp;
    } catch (e) {
      print(e);
    }
    return null;
  }

  getNetworkByUserMass() async {
    try {
      networks = [];

      isLoading = true;
      notifyListeners();

      final String? token = await storage.read(key: 'token');

      final url =
          Uri.https(_baseUrl, '/autogestionterreno-dev/getNetworkByUserMass');

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

      if (decodeResp['type'] == 'success') {
        final newResponse = NewReponseNetworkFromJson(resp.body);
        networks.addAll(newResponse.network);
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      NotificactionService.showSnackBar(e.toString());
    }
  }

  getNetworkByUserIndividual() async {
    try {
      networks = [];

      isLoading = true;
      notifyListeners();

      final String? token = await storage.read(key: 'token');

      final url = Uri.https(
          _baseUrl, '/autogestionterreno-dev/getNetworkByUserIndividual');

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

      if (decodeResp['type'] == 'success') {
        final newResponse = NewReponseNetworkFromJson(resp.body);
        networks.addAll(newResponse.network);
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      NotificactionService.showSnackBar(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getRegion() async {
    region = [
      {'name': 'Region*', 'value': '', 'state': true},
      {
        'name': 'CO-Antioquia Centro',
        'value': 'CO-Antioquia Centro',
        'state': true
      },
      {
        'name': 'CO-Antioquia Municipios',
        'value': 'CO-Antioquia Municipios',
        'state': true
      },
      {
        'name': 'CO-Antioquia Norte',
        'value': 'CO-Antioquia Norte',
        'state': true
      },
      {
        'name': 'CO-Antioquia Oriente',
        'value': 'CO-Antioquia Oriente',
        'state': true
      },
      {'name': 'CO-Antioquia Sur', 'value': 'CO-Antioquia Sur', 'state': true},
      {
        'name': 'CO-Antioquia_Edatel',
        'value': 'CO-Antioquia_Edatel',
        'state': true
      },
      {'name': 'CO-Atlantico', 'value': 'CO-Atlantico', 'state': true},
      {'name': 'CO-Bolivar', 'value': 'CO-Bolivar', 'state': true},
      {
        'name': 'CO-Bolivar_Edatel',
        'value': 'CO-Bolivar_Edatel',
        'state': true
      },
      {'name': 'CO-Boyaca', 'value': 'CO-Boyaca', 'state': true},
      {'name': 'CO-Boyaca_Edatel', 'value': 'CO-Boyaca_Edatel', 'state': true},
      {'name': 'CO-Caldas', 'value': 'CO-Caldas', 'state': true},
      {'name': 'CO-Caldas_Edatel', 'value': 'CO-Caldas_Edatel', 'state': true},
      {'name': 'CO-Casanare', 'value': 'CO-Casanare', 'state': true},
      {'name': 'CO-Cauca', 'value': 'CO-Cauca', 'state': true},
      {'name': 'CO-Cesar', 'value': 'CO-Cesar', 'state': true},
      {'name': 'CO-Cesar_Edatel', 'value': 'CO-Cesar_Edatel', 'state': true},
      {'name': 'CO-Cordoba', 'value': 'CO-Cordoba', 'state': true},
      {
        'name': 'CO-Cordoba_Edatel',
        'value': 'CO-Cordoba_Edatel',
        'state': true
      },
      {
        'name': 'CO-Cundinamarca Municipios',
        'value': 'CO-Cundinamarca Municipios',
        'state': true
      },
      {
        'name': 'CO-Cundinamarca Norte',
        'value': 'CO-Cundinamarca Norte',
        'state': true
      },
      {
        'name': 'CO-Cundinamarca Sur',
        'value': 'CO-Cundinamarca Sur',
        'state': true
      },
      {'name': 'CO-Guajira', 'value': 'CO-Guajira', 'state': true},
      {'name': 'CO-Huila', 'value': 'CO-Huila', 'state': true},
      {'name': 'CO-Magdalena', 'value': 'CO-Magdalena', 'state': true},
      {'name': 'CO-Meta', 'value': 'CO-Meta', 'state': true},
      {'name': 'CO-Nariño', 'value': 'CO-Nariño', 'state': true},
      {
        'name': 'CO-Norte de Santander',
        'value': 'CO-Norte de Santander',
        'state': true
      },
      {
        'name': 'CO-Otros_Municipios_Centro',
        'value': 'CO-Otros_Municipios_Centro',
        'state': true
      },
      {
        'name': 'CO-Otros_Municipios_Eje cafetero',
        'value': 'CO-Otros_Municipios_Eje cafetero',
        'state': true
      },
      {
        'name': 'CO-Otros_Municipios_Noroccidente',
        'value': 'CO-Otros_Municipios_Noroccidente',
        'state': true
      },
      {
        'name': 'CO-Otros_Municipios_Norte',
        'value': 'CO-Otros_Municipios_Norte',
        'state': true
      },
      {
        'name': 'CO-Otros_Municipios_Oriente',
        'value': 'CO-Otros_Municipios_Oriente',
        'state': true
      },
      {
        'name': 'CO-Otros_Municipios_Sur',
        'value': 'CO-Otros_Municipios_Sur',
        'state': true
      },
      {'name': 'CO-Quindio', 'value': 'CO-Quindio', 'state': true},
      {'name': 'CO-Risaralda', 'value': 'CO-Risaralda', 'state': true},
      {'name': 'CO-Santander', 'value': 'CO-Santander', 'state': true},
      {
        'name': 'CO-Santander_Edatel',
        'value': 'CO-Santander_Edatel',
        'state': true
      },
      {'name': 'CO-Sucre', 'value': 'CO-Sucre', 'state': true},
      {'name': 'CO-Sucre_Edatel', 'value': 'CO-Sucre_Edatel', 'state': true},
      {'name': 'CO-Tolima', 'value': 'CO-Tolima', 'state': true},
      {'name': 'CO-Valle', 'value': 'CO-Valle', 'state': true},
      {'name': 'CO-Valle Quindío', 'value': 'CO-Valle Quindío', 'state': true}
    ];

    return region;
  }

  Future<List<Map<String, dynamic>>> getTecnology() async {
    tecnologia = [
      {'name': 'Tecnología*', 'value': '', 'state': true},
      {'name': 'HFC', 'value': 'HFC', 'state': true},
      {'name': 'Cobre', 'value': 'Cobre', 'state': true},
      {'name': 'GPON', 'value': 'GPON', 'state': true},
      {'name': 'Fibra', 'value': 'Fibra', 'state': true},
      {'name': 'Móvil', 'value': 'Móvil', 'state': true},
    ];
    return tecnologia;
  }
}
