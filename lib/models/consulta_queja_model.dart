// To parse this JSON data, do
//
//     final newReponseCodigoIncompleto = newReponseCodigoIncompletoFromJson(jsonString);

// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

NewReponseConsultaqueja newReponseConsultaquejaFromJson(String str) =>
    NewReponseConsultaqueja.fromJson(json.decode(str));

String newReponseConsultaquejaToJson(NewReponseConsultaqueja data) =>
    json.encode(data.toJson());

class NewReponseConsultaqueja {
  NewReponseConsultaqueja({
    required this.type,
    //required this.codinc,
    required this.quejas,
  });

  String type;

  //String codinc;
  List<QUEJAS> quejas;

  factory NewReponseConsultaqueja.fromJson(Map<String, dynamic> json) =>
      NewReponseConsultaqueja(
        type: json["type"],
        quejas:
            List<QUEJAS>.from(json["message"].map((x) => QUEJAS.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "messgae": List<dynamic>.from(quejas.map((x) => x.toJson())),
      };
}

class QUEJAS {
  QUEJAS(
      {required this.SS,
      required this.NOMBRE_CUENTA,
      required this.IDENTIFICACION,
      required this.CELULAR,
      required this.FIJO,
      required this.NUMERO_CUN,
      required this.EMAIL,
      required this.DESCRIPCION,
      required this.DIRECCION});

  String SS;
  String NOMBRE_CUENTA;
  String IDENTIFICACION;
  String CELULAR;
  String FIJO;
  String NUMERO_CUN;
  String EMAIL;
  String DESCRIPCION;
  String DIRECCION;

  factory QUEJAS.fromJson(Map<String, dynamic> json) => QUEJAS(
        SS: json["SS"],
        NOMBRE_CUENTA: json["NOMBRE_CUENTA"],
        IDENTIFICACION: json["IDENTIFICACION"],
        CELULAR: json["CELULAR"],
        FIJO: json["FIJO"],
        NUMERO_CUN: json["NUMERO_CUN"],
        EMAIL: json["EMAIL"],
        DESCRIPCION: json["DESCRIPCION"],
        DIRECCION: json["DIRECCION"],
      );

  Map<String, dynamic> toJson() => {
        "SS": SS,
        "NOMBRE_CUENTA": NOMBRE_CUENTA,
        "IDENTIFICACION": IDENTIFICACION,
        "CELULAR": CELULAR,
        "FIJO": FIJO,
        "NUMERO_CUN": NUMERO_CUN,
        "EMAIL": EMAIL,
        "DESCRIPCION": DESCRIPCION,
        "DIRECCION": DIRECCION,
      };
}
