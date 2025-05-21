import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/constantes.dart';
import '../plantillas/PantallasEntrenamiento.dart';

class FinEntrenamiento extends StatelessWidget{
  const FinEntrenamiento({super.key});

  @override
  Widget build(BuildContext context) {
    return PantallasEntrenamiento(
        titulo: "",
        hijos: [
          Text("¡Enhorabuena!", style: TextStyle(fontSize: 30.sp)),
          Text("Has completado tu entrenamiento", style: TextStyle(fontSize: 20.sp)),
          Icon(Icons.check_circle, size: 50.sp, color: Colores.verde)
        ],
        boton: true,
        textoBoton: "Finalizar",
    );
  }
}