import 'dart:convert';
import 'package:autogestion_tecnico/global/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = baseUrl;
  final String _ruta =
      '/autogestion-terreno-api-dev/controllers/AutenticacionCtrl.php';

  final storage = const FlutterSecureStorage();

  bool isLoading = false;

/*   AuthService() {
    getEncuesta();
  } */

  Future<Map?> login(
      {required String usuario, required String password}) async {
    try {
      isLoading = true;
      final url = Uri.https(_baseUrl, _ruta);

      final Map<String, dynamic> data = {
        "data": {"user": usuario, "password": password, "version": 23},
        "method": "login"
      };

      final resp = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(data));

      final Map<String, dynamic> decodeResp = json.decode(resp.body);

      if (decodeResp['type'] == 'error') {
        return decodeResp;
      } else {
        await storage.write(
            key: 'nombre', value: decodeResp['message']['nombre']);
        await storage.write(
            key: 'alert', value: decodeResp['message']['alert']);
        await storage.write(
            key: 'login_click', value: decodeResp['message']['login_click']);
        await storage.write(
            key: 'identificacion',
            value: decodeResp['message']['identificacion']);
        await storage.write(key: 'token', value: decodeResp['token']);
        await storage.write(
            key: 'menu', value: json.encode(decodeResp['message']['menu']));

        decodeResp['type'] = 'success';
        decodeResp['msg'] = 'OK';
        isLoading = false;
        return decodeResp;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String> logout() async {
    //await storage.deleteAll();
    await storage.delete(key: 'nombre');
    await storage.delete(key: 'login_click');
    await storage.delete(key: 'identificacion');
    await storage.delete(key: 'token');
    await storage.delete(key: 'menu');
    await storage.delete(key: 'alert');

    return 'OK';
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }

  Future<String> readMenu() async {
    return await storage.read(key: 'menu') ?? '';
  }

  Future<Map<String, String>> readAllData() async {
    return await storage.readAll();
  }

  Future getMenuApp() async {
    try {
      final String? token = await storage.read(key: 'token');

      final Map<String, dynamic> data = {"method": "menuApp"};

      final url = Uri.https(_baseUrl, _ruta);
      final resp = await http.post(url,
          headers: {'Content-Type': 'application/json', 'x-token': token!},
          body: jsonEncode(data));

      final Map<String, dynamic> decodeResp = json.decode(resp.body);
      await storage.write(
          key: 'menu', value: json.encode(decodeResp['message']));

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>?> validaEncuesta() async {
    try {
      final String? token = await storage.read(key: 'token');

      final Map<String, dynamic> data = {"method": "validaEncuesta"};

      final url = Uri.https(_baseUrl, _ruta);

      final resp = await http.post(url,
          headers: {'Content-Type': 'application/json', 'x-token': token!},
          body: jsonEncode(data));

      final Map<String, dynamic> decodeResp = json.decode(resp.body);

      await storage.delete(key: 'alert');
      await storage.write(key: 'alert', value: decodeResp['alert']);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future getEncuesta() async {
    try {
      final String? token = await storage.read(key: 'token');

      final Map<String, dynamic> data = {"method": "validaEncuesta"};

      final url = Uri.https(_baseUrl, _ruta);

      final resp = await http.post(url,
          headers: {'Content-Type': 'application/json', 'x-token': token!},
          body: jsonEncode(data));

      final Map<String, dynamic> decodeResp = json.decode(resp.body);

      await storage.delete(key: 'alert');
      await storage.write(key: 'alert', value: decodeResp['alert']);
    } catch (e) {
      print(e);
    }
    return null;
  }
}
