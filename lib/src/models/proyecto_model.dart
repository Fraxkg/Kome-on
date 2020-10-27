// To parse this JSON data, do
//
//     final proyectoModel = proyectoModelFromJson(jsonString);

import 'dart:convert';

ProyectoModel proyectoModelFromJson(String str) => ProyectoModel.fromJson(json.decode(str));

String proyectoModelToJson(ProyectoModel data) => json.encode(data.toJson());

class ProyectoModel {
    ProyectoModel({
        this.id,
        this.nombre='',
        this.responsable="",
        this.descripcion="",
        this.fechaInicio="",
        this.fechaFin="",
    });

    String id;
    String nombre;
    String responsable;
    String descripcion;
    String fechaInicio;
    String fechaFin;

    factory ProyectoModel.fromJson(Map<String, dynamic> json) => ProyectoModel(
        id            : json["id"],
        nombre        : json["nombre"],
        responsable   : json["responsable"],
        descripcion   : json["descripcion"],
        fechaInicio   : json["fechaInicio"],
        fechaFin      : json["fechaFin"],
    );

    Map<String, dynamic> toJson() => {
        "id"            : id,
        "nombre"        : nombre,
        "responsable"   : responsable,
        "descripcion"   : descripcion,
        "fechaInicio"   : fechaInicio,
        "fechaFin"      : fechaFin,
    };
}