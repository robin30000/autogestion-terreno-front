// To parse this JSON data, do
//
//     final newReponseContingencia = newReponseContingenciaFromJson(jsonString);

import 'dart:convert';

NewReponseRegistroEquipos NewReponseRegistroEquiposFromJson(String str) =>
    NewReponseRegistroEquipos.fromJson(json.decode(str));

String NewReponseRegistroEquiposToJson(NewReponseRegistroEquipos data) =>
    json.encode(data.toJson());

class NewReponseRegistroEquipos {
  NewReponseRegistroEquipos({
    required this.type,
    required this.equipos,
  });

  String type;
  List<RegistrosEq> equipos;

  factory NewReponseRegistroEquipos.fromJson(Map<String, dynamic> json) =>
      NewReponseRegistroEquipos(
        type: json["type"],
        equipos: List<RegistrosEq>.from(
            json["message"].map((x) => RegistrosEq.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "registros": List<dynamic>.from(equipos.map((x) => x.toJson())),
      };
}

class RegistrosEq {
  RegistrosEq({
    required this.id,
    required this.macEntra,
    required this.observacion,
    required this.pedido,
    required this.fecha_ingreso,
  });

  String id;
  String macEntra;
  String observacion;
  String pedido;
  DateTime fecha_ingreso;

  factory RegistrosEq.fromJson(Map<String, dynamic> json) => RegistrosEq(
        id: json["id"],
        macEntra: json["mac_entra"],
        observacion: json["observacion"],
        pedido: json["pedido"],
        fecha_ingreso: DateTime.parse(json["fecha_ingreso"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "macEntra": macEntra,
        "observacion": observacion,
        "pedido": pedido,
        "fecha_ingreso": fecha_ingreso.toIso8601String(),
      };
}
