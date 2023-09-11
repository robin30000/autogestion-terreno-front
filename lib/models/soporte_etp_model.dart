// To parse this JSON data, do
//
//     final newReponseSoporteGpon = newReponseSoporteGponFromJson(jsonString);

import 'dart:convert';

NewReponseSoporteEtp newReponseSoporteEtpFromJson(String str) =>
    NewReponseSoporteEtp.fromJson(json.decode(str));

String newReponseSoporteEtpToJson(NewReponseSoporteEtp data) =>
    json.encode(data.toJson());

class NewReponseSoporteEtp {
  NewReponseSoporteEtp({
    required this.type,
    required this.soporteetp,
  });

  String type;
  List<SoporteEtp> soporteetp;

  factory NewReponseSoporteEtp.fromJson(Map<String, dynamic> json) =>
      NewReponseSoporteEtp(
        type: json["type"],
        soporteetp: List<SoporteEtp>.from(
            json["message"].map((x) => SoporteEtp.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "message": List<dynamic>.from(soporteetp.map((x) => x.toJson())),
      };
}

class SoporteEtp {
  SoporteEtp({
    required this.idSoporte,
    required this.tarea,
    required this.unepedido,
    required this.tasktypecategory,
    required this.statusSoporte,
    required this.fechaSolicitudFirebase,
    this.respuestaSoporte,
    this.observacion,
    this.fechaRespuesta,
    required this.observacionTerreno,
  });

  String idSoporte;
  String tarea;
  String unepedido;
  String tasktypecategory;
  String statusSoporte;
  DateTime fechaSolicitudFirebase;
  String? respuestaSoporte;
  String? observacion;
  dynamic fechaRespuesta;
  String observacionTerreno;

  factory SoporteEtp.fromJson(Map<String, dynamic> json) => SoporteEtp(
        idSoporte: json["id_soporte"],
        tarea: json["tarea"],
        unepedido: json["unepedido"],
        tasktypecategory: json["tasktypecategory"],
        statusSoporte: json["status_soporte"],
        fechaSolicitudFirebase: DateTime.parse(json["fecha_crea"]),
        respuestaSoporte: json["tipificaciones2"],
        observacion: json["observacion"],
        fechaRespuesta: json["fecha_gestion"] == null
            ? ''
            : DateTime.parse(json["fecha_gestion"]),
        observacionTerreno: json["observacion_terreno"],
      );

  Map<String, dynamic> toJson() => {
        "id_soporte": idSoporte,
        "tarea": tarea,
        "unepedido": unepedido,
        "tasktypecategory": tasktypecategory,
        "status_soporte": statusSoporte,
        "fecha_solicitud_firebase": fechaSolicitudFirebase.toIso8601String(),
        //"respuesta_soporte": respuestaSoporte,
        "observacion": observacion,
        "fecha_respuesta": fechaRespuesta,
        "observacion_terreno": observacionTerreno,
      };
}
