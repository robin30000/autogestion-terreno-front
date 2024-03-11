// To parse this JSON data, do
//
//     final newReponseBb8 = newReponseBb8FromJson(jsonString);

import 'dart:convert';

NewReponseBb8 newReponseBb8FromJson(String str) =>
    NewReponseBb8.fromJson(json.decode(str));

String newReponseBb8ToJson(NewReponseBb8 data) => json.encode(data.toJson());

class NewReponseBb8 {
  NewReponseBb8({
    required this.type,
    required this.bb8,
  });

  String type;
  List<BB8> bb8;

  factory NewReponseBb8.fromJson(Map<String, dynamic> json) => NewReponseBb8(
        type: json["type"],
        bb8: List<BB8>.from(json["message"].map((x) => BB8.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "message": List<dynamic>.from(bb8.map((x) => x.toJson())),
      };
}

class BB8 {
  BB8({
    required this.cedula,
    required this.cliente,
    required this.direccion,
    required this.gis,
    this.internet,
    this.telefonia,
    this.television,
    required this.serial,
    required this.mac,
    required this.marca,
    required this.velocidad,
    required this.linea,
    required this.paquetes,
  });

  String cedula;
  String cliente;
  String direccion;
  String gis;
  String? internet;
  String? telefonia;
  String? television;

  String? serial;
  String? mac;
  String? marca;
  String? velocidad;
  String? linea;
  String? paquetes;

  factory BB8.fromJson(Map<String, dynamic> json) => BB8(
        cedula: json["CEDULA"] ?? '',
        cliente: json["CLIENTE"] ?? '',
        direccion: json["DIRECCION"] ?? '',
        gis: json["GIS"] ?? '',
        internet: json["INTERNET"],
        telefonia: json["TELEFONIA"],
        television: json["TELEVISION"],
        serial: json["SERIAL"] ?? '',
        mac: json["MAC"] ?? '',
        marca: json["MARCA"] ?? '',
        velocidad: json["VELOCIDAD"] ?? '',
        linea: json["LINEA"] ?? '',
        paquetes: json["PAQUETE"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "cedula": cedula,
        "cliente": cliente,
        "direccion": direccion,
        "gis": gis,
        "internet": internet,
        "telefonia": telefonia,
        "television": television,
        "serial": serial,
        "mac": mac,
        "marca": marca,
        "velocidad": velocidad,
        "linea": linea,
        "paquetes": paquetes,
      };
}
