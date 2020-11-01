// To parse this JSON data, do
//
//     final equipoModel = equipoModelFromJson(jsonString);

import 'dart:convert';

EquipoModel equipoModelFromJson(String str) => EquipoModel.fromJson(json.decode(str));

String equipoModelToJson(EquipoModel data) => json.encode(data.toJson());

class EquipoModel {
    EquipoModel({
        this.id,
        this.userId,
        this.email,
    });

    String id;
    String userId;
    String email;

    factory EquipoModel.fromJson(Map<String, dynamic> json) => EquipoModel(
        id: json["id"],
        userId: json["userId"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "email": email,
    };
}
