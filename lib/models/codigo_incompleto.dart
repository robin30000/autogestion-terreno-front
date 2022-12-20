// To parse this JSON data, do
//
//     final newReponseCodigoIncompleto = newReponseCodigoIncompletoFromJson(jsonString);

import 'dart:convert';

NewReponseCodigoIncompleto newReponseCodigoIncompletoFromJson(String str) => NewReponseCodigoIncompleto.fromJson(json.decode(str));

String newReponseCodigoIncompletoToJson(NewReponseCodigoIncompleto data) => json.encode(data.toJson());

class NewReponseCodigoIncompleto {
    NewReponseCodigoIncompleto({
        required this.type,
        required this.codinc,
    });

    String type;
    String codinc;

    factory NewReponseCodigoIncompleto.fromJson(Map<String, dynamic> json) => NewReponseCodigoIncompleto(
        type: json["type"],
        codinc: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "codinc": codinc,
    };
}
