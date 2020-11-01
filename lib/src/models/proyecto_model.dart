// To parse this JSON data, do
//
//     final proyectoModel = proyectoModelFromJson(jsonString);

import 'dart:convert';

ProyectoModel proyectoModelFromJson(String str) => ProyectoModel.fromJson(json.decode(str));

String proyectoModelToJson(ProyectoModel data) => json.encode(data.toJson());

class ProyectoModel {
    ProyectoModel({
        this.id,
        this.userId='',
        this.nombre='',
        this.responsable="",
        this.descripcion="",
        this.fechaInicio="",
        this.fechaFin="",
        this.wipLimit="",
    });

    String id;
    String userId;
    String nombre;
    String responsable;
    String descripcion;
    String fechaInicio;
    String fechaFin;
    String wipLimit;
    
    factory ProyectoModel.fromJson(Map<String, dynamic> json) => ProyectoModel(
        id            : json["id"],
        userId        : json["userId"],
        nombre        : json["nombre"],
        responsable   : json["responsable"],
        descripcion   : json["descripcion"],
        fechaInicio   : json["fechaInicio"],
        fechaFin      : json["fechaFin"],
        wipLimit      : json["wipLimit"],
    );

    Map<String, dynamic> toJson() => {
        "id"            : id,
        "userId"        : userId,
        "nombre"        : nombre,
        "responsable"   : responsable,
        "descripcion"   : descripcion,
        "fechaInicio"   : fechaInicio,
        "fechaFin"      : fechaFin,
        "wipLimit"      : wipLimit,
    };
}