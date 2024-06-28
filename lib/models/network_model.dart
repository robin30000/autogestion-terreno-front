// To parse this JSON data, do
//
//     final NewReponseNetwork = NewReponseNetworkFromJson(jsonString);

import 'dart:convert';

NewReponseNetwork NewReponseNetworkFromJson(String str) =>
    NewReponseNetwork.fromJson(json.decode(str));

String NewReponseNetworkToJson(NewReponseNetwork data) =>
    json.encode(data.toJson());

class NewReponseNetwork {
  NewReponseNetwork({
    required this.type,
    required this.network,
  });

  String type;
  List<RegistrosNetwork> network;

  factory NewReponseNetwork.fromJson(Map<String, dynamic> json) =>
      NewReponseNetwork(
        type: json["type"],
        network: List<RegistrosNetwork>.from(
            json["message"].map((x) => RegistrosNetwork.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "network": List<dynamic>.from(network.map((x) => x.toJson())),
      };
}

class RegistrosNetwork {
  RegistrosNetwork({
    required this.numero_caso,
    required this.tecnologia,
    required this.direccion,
    required this.observacion,
  });

  String numero_caso;
  String tecnologia;
  String direccion;
  String observacion;

  factory RegistrosNetwork.fromJson(Map<String, dynamic> json) =>
      RegistrosNetwork(
        numero_caso: json["numero_caso"] ?? '',
        tecnologia: json["tecnologia"] ?? '',
        direccion: json["direccion"] ?? '',
        observacion: json["observacion"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "numero_caso": numero_caso,
        "tecnologia": tecnologia,
        "direccion": direccion,
        "observacion": observacion,
      };
}
