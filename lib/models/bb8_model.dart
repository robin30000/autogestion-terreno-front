// To parse this JSON data, do
//
//     final newReponseBb8 = newReponseBb8FromJson(jsonString);

import 'dart:convert';

NewReponseBb8 newReponseBb8FromJson(String str) => NewReponseBb8.fromJson(json.decode(str));

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
    });

    String cedula;
    String cliente;
    String direccion;
    String gis;
    String? internet;
    String? telefonia;
    String? television;

    factory BB8.fromJson(Map<String, dynamic> json) => BB8(
        cedula: json["CEDULA"],
        cliente: json["CLIENTE"],
        direccion: json["DIRECCION"],
        gis: json["GIS"],
        internet: json["INTERNET"] == null ? null : json["INTERNET"],
        telefonia: json["TELEFONIA"] == null ? null : json["TELEFONIA"],
        television: json["TELEVISION"] == null ? null : json["TELEVISION"],
    );

    Map<String, dynamic> toJson() => {
        "cedula": cedula,
        "cliente": cliente,
        "direccion": direccion,
        "gis": gis,
        "internet": internet == null ? null : internet,
        "telefonia": telefonia == null ? null : telefonia,
        "television": television == null ? null : television,
    };
}
