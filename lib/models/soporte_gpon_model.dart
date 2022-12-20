// To parse this JSON data, do
//
//     final newReponseSoporteGpon = newReponseSoporteGponFromJson(jsonString);

import 'dart:convert';

NewReponseSoporteGpon newReponseSoporteGponFromJson(String str) => NewReponseSoporteGpon.fromJson(json.decode(str));

String newReponseSoporteGponToJson(NewReponseSoporteGpon data) => json.encode(data.toJson());

class NewReponseSoporteGpon {
    NewReponseSoporteGpon({
        required this.type,
        required this.soportegpon,
    });

    String type;
    List<SoporteGpon> soportegpon;

    factory NewReponseSoporteGpon.fromJson(Map<String, dynamic> json) => NewReponseSoporteGpon(
        type: json["type"],
        soportegpon: List<SoporteGpon>.from(json["message"].map((x) => SoporteGpon.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "message": List<dynamic>.from(soportegpon.map((x) => x.toJson())),
    };
}

class SoporteGpon {
    SoporteGpon({
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

    factory SoporteGpon.fromJson(Map<String, dynamic> json) => SoporteGpon(
        idSoporte: json["id_soporte"],
        tarea: json["tarea"],
        unepedido: json["unepedido"],
        tasktypecategory: json["tasktypecategory"],
        statusSoporte: json["status_soporte"],
        fechaSolicitudFirebase: DateTime.parse(json["fecha_solicitud_firebase"]),
        respuestaSoporte: json["respuesta_soporte"],
        observacion: json["observacion"],
        fechaRespuesta: json["fecha_respuesta"] == null ? '' : DateTime.parse(json["fecha_respuesta"]),
        observacionTerreno: json["observacion_terreno"],
    );

    Map<String, dynamic> toJson() => {
        "id_soporte": idSoporte,
        "tarea": tarea,
        "unepedido": unepedido,
        "tasktypecategory": tasktypecategory,
        "status_soporte": statusSoporte,
        "fecha_solicitud_firebase": fechaSolicitudFirebase.toIso8601String(),
        "respuesta_soporte": respuestaSoporte,
        "observacion": observacion,
        "fecha_respuesta": fechaRespuesta,
        "observacion_terreno": observacionTerreno,
    };
}
