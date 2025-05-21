import 'package:flutter/material.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/interfaces/pantallas/plantillas/PantallasEntrenamiento.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RealizandoEjercicio extends StatelessWidget{

  final String ejercicio;

  const RealizandoEjercicio({super.key, required this.ejercicio});

  @override
  Widget build(BuildContext context) {
    return PantallasEntrenamiento(
        titulo: ejercicio,
        hijos: [
          Text("Vamos!!!", style: TextStyle(color: Colores.negro, fontSize: 30.sp))
        ],
        boton: true,
        textoBoton: "Fin de serie",
    );
  }
}