import 'package:flutter/material.dart';
import 'package:tfg/constantes.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/interfaces/pantallas/plantillas/PantallasEntrenamiento.dart';
import '../../widgetsPersonalizados/TituloSimple.dart';

class EntrenamientoListarEjericicos extends StatelessWidget{
  
  final List<String> ejercicios;
  final String descanso;

  const EntrenamientoListarEjericicos({super.key, required this.ejercicios, required this.descanso});

  List<Widget> _hijosColumna(){
    List<Widget> out=[];
    final TextStyle estilo=TextStyle(color: Colores.negro, fontSize: 23.sp);

    for(int i=0; i<ejercicios.length; i++){
      out.add(Text("${i+1}. ${ejercicios[i]}", style: estilo));
    }

    out.add(Text("Descanso: $descanso",style: estilo,));

    return out;
  }

  @override
  Widget build(BuildContext context) {

    return PantallasEntrenamiento(
        titulo: "Ejercicios",
        hijos: _hijosColumna(),
        textoBoton: "Empezar",
        boton: true
    );
  }
}