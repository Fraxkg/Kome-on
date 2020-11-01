// To parse this JSON data, do
//
//     final tareaModel = tareaModelFromJson(jsonString);

import 'dart:convert';

TareaModel tareaModelFromJson(String str) => TareaModel.fromJson(json.decode(str));

String tareaModelToJson(TareaModel data) => json.encode(data.toJson());

class TareaModel {
    TareaModel({
        this.id,
        this.proyectoId="",
        this.responsable="",
        this.nombre="",
        this.fechaInicio="",
        this.fechaFin="",
        this.estadoTarea="To-do",
        this.tipoTarea="análisis",
        this.esfuerzo="",
        this.urgencia="No",
        this.descTarea="",
        this.requisito='',
    });

    String id;
    String proyectoId;
    String responsable;
    String nombre;
    String fechaInicio;
    String fechaFin;
    String estadoTarea;
    String tipoTarea;
    String esfuerzo;
    String urgencia;
    String descTarea;
    String requisito;

    factory TareaModel.fromJson(Map<String, dynamic> json) => TareaModel(
        id            : json["id"],
        proyectoId     : json["proyectoId"],
        responsable   : json["responsable"],
        nombre        : json["nombre"],
        fechaInicio   : json["fechaInicio"],
        fechaFin      : json["fechaFin"],
        estadoTarea   : json["estadoTarea"],
        tipoTarea     : json["tipoTarea"],
        esfuerzo      : json["esfuerzo"],
        urgencia      : json["urgencia"],
        descTarea     : json["descTarea"],
        requisito     : json["requisito"]
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "proyectoId": proyectoId,
        "responsable": responsable,
        "nombre": nombre,
        "fechaInicio": fechaInicio,
        "fechaFin": fechaFin,
        "estadoTarea": estadoTarea,
        "tipoTarea": tipoTarea,
        "esfuerzo": esfuerzo,
        "urgencia": urgencia,
        "descTarea": descTarea,
        "requisito":requisito,

    };
}