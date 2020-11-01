// To parse this JSON data, do
//
//     final miembroModel = miembroModelFromJson(jsonString);

import 'dart:convert';

MiembroModel miembroModelFromJson(String str) => MiembroModel.fromJson(json.decode(str));

String miembroModelToJson(MiembroModel data) => json.encode(data.toJson());

class MiembroModel {
    MiembroModel({
        this.id,
        this.userId,
        this.email,
        this.equipoId,
    });

    String id;
    String userId;
    String email;
    String equipoId;

    factory MiembroModel.fromJson(Map<String, dynamic> json) => MiembroModel(
        id: json["id"],
        userId: json["userId"],
        email: json["email"],
        equipoId: json["equipoId"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "email": email,
        "equipoId":equipoId,
    };
}