// To parse this JSON data, do
//
//     final newReponseContingencia = newReponseContingenciaFromJson(jsonString);

import 'dart:convert';

NewReponseContingencia newReponseContingenciaFromJson(String str) =>
    NewReponseContingencia.fromJson(json.decode(str));

String newReponseContingenciaToJson(NewReponseContingencia data) =>
    json.encode(data.toJson());

class NewReponseContingencia {
  NewReponseContingencia({
    required this.type,
    required this.contingencia,
  });

  String type;
  List<Registros> contingencia;

  factory NewReponseContingencia.fromJson(Map<String, dynamic> json) =>
      NewReponseContingencia(
        type: json["type"],
        contingencia: List<Registros>.from(
            json["message"].map((x) => Registros.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "contingencia": List<dynamic>.from(contingencia.map((x) => x.toJson())),
      };
}

class Registros {
  Registros({
    required this.id,
    required this.accion,
    required this.ciudad,
    required this.macEntra,
    this.macSale,
    required this.observacion,
    required this.pedido,
    required this.producto,
    required this.horagestion,
    this.horacontingencia,
    this.observContingencia,
    this.tipificacion,
    this.finalizado,
    required this.engestion,
    this.acepta,
  });

  String id;
  String accion;
  String ciudad;
  String macEntra;
  String? macSale;
  String observacion;
  String pedido;
  String producto;
  DateTime horagestion;
  dynamic horacontingencia;
  String? observContingencia;
  String? tipificacion;
  String? finalizado;
  String engestion;
  String? acepta;

  factory Registros.fromJson(Map<String, dynamic> json) => Registros(
        id: json["id"],
        accion: json["accion"],
        ciudad: json["ciudad"],
        macEntra: json["macEntra"],
        macSale: json["macSale"],
        observacion: json["observacion"],
        pedido: json["pedido"],
        producto: json["producto"],
        horagestion: DateTime.parse(json["horagestion"]),
        horacontingencia: json["horacontingencia"] == null
            ? ''
            : DateTime.parse(json["horacontingencia"]),
        observContingencia: json["observContingencia"],
        tipificacion: json["tipificacion"],
        finalizado: json["finalizado"],
        engestion: json["engestion"],
        acepta: json["acepta"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "accion": accion,
        "ciudad": ciudad,
        "macEntra": macEntra,
        "macSale": macSale,
        "observacion": observacion,
        "pedido": pedido,
        "producto": producto,
        "horagestion": horagestion.toIso8601String(),
        "horacontingencia": horacontingencia,
        "observContingencia": observContingencia,
        "tipificacion": tipificacion,
        "finalizado": finalizado,
        "engestion": engestion,
        "acepta": acepta,
      };
}
