import 'package:flutter/material.dart';
import 'package:tfg/interfaces/pantallas/plantillas/EligeEntre2.dart';

class Confirmacion extends StatelessWidget{
  const Confirmacion({super.key});

  @override
  Widget build(BuildContext context) {
    return EligeEntre2(
        titulo: "Confirmacion",
        pregunta: "¿Seguro?",
        opcion1: "SI",
        opcion2: "NO",
        func1: (){Navigator.pop(context,true);},
        func2: (){Navigator.pop(context,false);}
    );
  }
}