// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

NewReponseConsultaqueja newReponseConsultaquejaFromJson(String str) =>
    NewReponseConsultaqueja.fromJson(json.decode(str));

String newReponseConsultaquejaToJson(NewReponseConsultaqueja data) =>
    json.encode(data.toJson());

class NewReponseConsultaqueja {
  NewReponseConsultaqueja({
    required this.type,
    required this.quejas,
  });

  String type;
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
  QUEJAS({
    required this.SS,
    required this.NOMBRE_CUENTA,
    required this.IDENTIFICACION,
    required this.CELULAR,
    required this.FIJO,
    required this.NUMERO_CUN,
    required this.EMAIL,
    required this.DESCRIPCION,
    required this.DIRECCION,
  });

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
        SS: json["SS"] ?? '',
        NOMBRE_CUENTA: json["NOMBRE_CUENTA"] ?? '',
        IDENTIFICACION: json["IDENTIFICACION"] ?? '',
        CELULAR: json["CELULAR"] ?? '',
        FIJO: json["FIJO"] ?? '',
        NUMERO_CUN: json["NUMERO_CUN"] ?? '',
        EMAIL: json["EMAIL"] ?? '',
        DESCRIPCION: json["DESCRIPCION"] ?? '',
        DIRECCION: json["DIRECCION"] ?? '',
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

NewReponseMisQuejas newReponseMisQuejasFromJson(String str) =>
    NewReponseMisQuejas.fromJson(json.decode(str));

String newReponseMisQuejasToJson(NewReponseMisQuejas data) =>
    json.encode(data.toJson());

class NewReponseMisQuejas {
  NewReponseMisQuejas({
    required this.type,
    required this.quejaslist,
  });

  String type;

  List<QUEJASLIST> quejaslist;

  factory NewReponseMisQuejas.fromJson(Map<String, dynamic> json) =>
      NewReponseMisQuejas(
        type: json["type"],
        quejaslist: List<QUEJASLIST>.from(
            json["message"].map((x) => QUEJASLIST.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "messgae": List<dynamic>.from(quejaslist.map((x) => x.toJson())),
      };
}

class QUEJASLIST {
  QUEJASLIST({
    required this.en_gestion,
    required this.gestion_asesor,
    required this.accion,
    required this.observacion_gestion,
    required this.pedido,
    this.fecha_gestion,
    required this.id,
    required this.fecha,
    required this.asesor,
  });

  String en_gestion;
  String gestion_asesor;
  String accion;
  String observacion_gestion;
  String pedido;
  dynamic fecha_gestion;
  String id;
  DateTime fecha;
  String asesor;

  factory QUEJASLIST.fromJson(Map<String, dynamic> json) => QUEJASLIST(
      en_gestion: json["en_gestion"],
      gestion_asesor: json["gestion_asesor"] ?? '',
      accion: json["accion"] ?? '',
      observacion_gestion: json["observacion_gestion"] ?? '',
      pedido: json["pedido"],
      fecha_gestion: json["fecha_gestion"] == null
          ? ''
          : DateTime.parse(json["fecha_gestion"]),
      id: json["id"] ?? '',
      fecha: DateTime.parse(json["fecha"]),
      asesor: json["asesor"]);

  Map<String, dynamic> toJson() => {
        "en_gestion": en_gestion,
        "gestion_asesor": gestion_asesor,
        "accion": accion,
        "observacion_gestion": observacion_gestion,
        "pedido": pedido,
        "fecha_gestion": fecha_gestion,
        "id": id,
        "fecha": fecha,
        "asesor": asesor
      };
}
