// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

NewReponseConsultaTareaSuper newReponseConsultaTareaSuperFromJson(String str) =>
    NewReponseConsultaTareaSuper.fromJson(json.decode(str));

String newReponseConsultaTareaSuperToJson(NewReponseConsultaTareaSuper data) =>
    json.encode(data.toJson());

class NewReponseConsultaTareaSuper {
  NewReponseConsultaTareaSuper({
    required this.type,
    required this.tareas,
  });

  String type;
  List<TAREASUPER> tareas;

  factory NewReponseConsultaTareaSuper.fromJson(Map<String, dynamic> json) =>
      NewReponseConsultaTareaSuper(
        type: json["type"],
        tareas: List<TAREASUPER>.from(
            json["message"].map((x) => TAREASUPER.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "messgae": List<dynamic>.from(tareas.map((x) => x.toJson())),
      };
}

class TAREASUPER {
  TAREASUPER({
    required this.modulo,
    required this.observacion,
    required this.logincontingencia,
    required this.fecha_ingreso,
    required this.fecha_fin,
    required this.observacion_asesor,
    required this.gestion,
  });

  String modulo;
  String observacion;
  String logincontingencia;
  String fecha_ingreso;
  String fecha_fin;
  String observacion_asesor;
  String gestion;

  factory TAREASUPER.fromJson(Map<String, dynamic> json) => TAREASUPER(
        modulo: json["modulo"] ?? '',
        observacion: json["observacion"] ?? '',
        logincontingencia: json["logincontingencia"] ?? '',
        fecha_ingreso: json["fecha_ingreso"] ?? '',
        fecha_fin: json["fecha_fin"] ?? '',
        observacion_asesor: json["observacion_asesor"] ?? '',
        gestion: json["gestion"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "modulo": modulo,
        "observacion": observacion,
        "logincontingencia": logincontingencia,
        "fecha_ingreso": fecha_ingreso,
        "fecha_fin": fecha_fin,
        "observacion_asesor": observacion_asesor,
        "gestion": gestion,
      };
}
