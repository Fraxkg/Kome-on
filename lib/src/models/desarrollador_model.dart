// To parse this JSON data, do
//
//     final desarrolladorModel = desarrolladorModelFromJson(jsonString);

import 'dart:convert';

DesarrolladorModel desarrolladorModelFromJson(String str) => DesarrolladorModel.fromJson(json.decode(str));

String desarrolladorModelToJson(DesarrolladorModel data) => json.encode(data.toJson());

class DesarrolladorModel {
    DesarrolladorModel({
        this.id,
        this.nombre="",
        this.apePaterno="",
        this.apeMaterno="",
        this.correo="",
        this.perfilUrl="",
        this.userId="",
    });

    String id;
    String nombre;
    String apePaterno;
    String apeMaterno;
    String correo;
    String perfilUrl;
    String userId;

    factory DesarrolladorModel.fromJson(Map<String, dynamic> json) => DesarrolladorModel(
        id: json["id"],
        nombre: json["nombre"],
        apePaterno: json["apePaterno"],
        apeMaterno: json["apeMaterno"],
        correo: json["correo"],
        perfilUrl: json["perfilUrl"],
        userId: json["userId"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "apePaterno": apePaterno,
        "apeMaterno": apeMaterno,
        "correo": correo,
        "perfilUrl": perfilUrl,
        "userId": userId,
    };
}
