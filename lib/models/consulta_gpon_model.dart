// To parse this JSON data, do
//
//     final newReponseCodigoIncompleto = newReponseCodigoIncompletoFromJson(jsonString);

import 'dart:convert';

NewReponseConsultaGpon newReponseConsultaGponFromJson(String str) =>
    NewReponseConsultaGpon.fromJson(json.decode(str));

String newReponseConsultaGponToJson(NewReponseConsultaGpon data) =>
    json.encode(data.toJson());

class NewReponseConsultaGpon {
  NewReponseConsultaGpon({
    required this.type,
    //required this.codinc,
    required this.gpon,
  });

  String type;

  //String codinc;
  List<GPON> gpon;

  factory NewReponseConsultaGpon.fromJson(Map<String, dynamic> json) =>
      NewReponseConsultaGpon(
        type: json["type"],
        gpon: List<GPON>.from(json["message"].map((x) => GPON.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "messgae": List<dynamic>.from(gpon.map((x) => x.toJson())),
      };
}

class GPON {
  GPON(
      {required this.pedido,
      required this.horagestion,
      required this.horacontingencia,
      required this.finalizado,
      required this.observacion});

  String pedido;
  String horagestion;
  String horacontingencia;
  String finalizado;
  String observacion;

  factory GPON.fromJson(Map<String, dynamic> json) => GPON(
        pedido: json["tarea"],
        horagestion: json["horagestion"],
        horacontingencia: json["horacontingencia"],
        finalizado: json["finalizado"],
        observacion: json["observacion"],
      );

  Map<String, dynamic> toJson() => {
        "pedido": pedido,
        "horagestion": horagestion,
        "horacontingencia": horacontingencia,
        "finalizado": finalizado,
        "observacion": observacion
      };
}
