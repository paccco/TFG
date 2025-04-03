import 'package:flutter/material.dart';
import '../constantes.dart';

class CajaEjercicios extends StatelessWidget{

  final String texto;

  const CajaEjercicios({super.key,required this.texto});

  @override
  Widget build(BuildContext context){
    return Container(
      color: Colores.naranja,
      padding: EdgeInsets.all(20),
      alignment: Alignment.centerLeft,
      child: Text(texto,style: TextStyle(color: Colores.blanco, fontSize: Tamanios.fuenteCajas)),
    );
  }

}