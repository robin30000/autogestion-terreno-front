// To parse this JSON datnewReponseSoporteEtpFromJsona, do
//
//     final newReponseSoporteGpon = newReponseSoporteGponFromJson(jsonString);

import 'dart:convert';

NewResponseMesasNacionales newReponseMesasNacionalesFromJson(String str) =>
    NewResponseMesasNacionales.fromJson(json.decode(str));

String newReponseMesasNacionalesToJson(NewResponseMesasNacionales data) =>
    json.encode(data.toJson());

class NewResponseMesasNacionales {
  NewResponseMesasNacionales({
    required this.type,
    required this.soporteMn,
  });

  String type;
  List<MesasNacionales> soporteMn;

  factory NewResponseMesasNacionales.fromJson(Map<String, dynamic> json) =>
      NewResponseMesasNacionales(
        type: json["type"],
        soporteMn: List<MesasNacionales>.from(
            json["message"].map((x) => MesasNacionales.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "message": List<dynamic>.from(soporteMn.map((x) => x.toJson())),
      };
}

class MesasNacionales {
  MesasNacionales({
    required this.tarea,
    required this.pedido,
    required this.tasktypecategory,
    required this.estado,
    required this.hora_ingreso,
    this.tipificacion,
    this.tipificacion_2,
    this.observacion_gestion,
    this.hora_gestion,
    required this.observacion_tecnico,
  });

  String tarea;
  String pedido;
  String tasktypecategory;
  String estado;
  DateTime hora_ingreso;
  String? tipificacion;
  String? tipificacion_2;
  String? observacion_gestion;
  dynamic hora_gestion;
  String observacion_tecnico;

  factory MesasNacionales.fromJson(Map<String, dynamic> json) =>
      MesasNacionales(
        tarea: json["tarea"],
        pedido: json["pedido"],
        tasktypecategory: json["tasktypecategory"],
        estado: json["estado"],
        hora_ingreso: DateTime.parse(json["hora_ingreso"]),
        tipificacion: json["tipificacion"],
        tipificacion_2: json["tipificacion_2"],
        observacion_gestion: json["observacion_gestion"],
        hora_gestion: json["hora_gestion"] == null
            ? ''
            : DateTime.parse(json["hora_gestion"]),
        observacion_tecnico: json["observacion_tecnico"],
      );

  Map<String, dynamic> toJson() => {
        "tarea": tarea,
        "pedido": pedido,
        "tasktypecategory": tasktypecategory,
        "estado": estado,
        "hora_ingreso": hora_ingreso.toIso8601String(),
        "tipificacion": tipificacion,
        "tipificacion_2": tipificacion_2,
        "observacion_gestion": observacion_gestion,
        "hora_gestion": hora_gestion,
        "observacion_tecnico": observacion_tecnico,
      };
}
