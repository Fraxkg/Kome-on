// To parse this JSON data, do
//
//     final equipoModel = equipoModelFromJson(jsonString);

import 'dart:convert';

EquipoModel equipoModelFromJson(String str) => EquipoModel.fromJson(json.decode(str));

String equipoModelToJson(EquipoModel data) => json.encode(data.toJson());

class EquipoModel {
    EquipoModel({
        this.id,
        this.idProyecto,
    });

    String id;
    String idProyecto;

    factory EquipoModel.fromJson(Map<String, dynamic> json) => EquipoModel(
        id: json["id"],
        idProyecto: json["idProyecto"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idProyecto": idProyecto,
    };
}
