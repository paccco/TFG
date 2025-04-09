import 'package:flutter/material.dart';
import '../constantes.dart';

class BarraTexto extends StatelessWidget{

  final TextEditingController controller;
  final int maxLineas;
  final String textoHint;

  const BarraTexto({super.key, this.textoHint="", required this.controller,this.maxLineas=1});

  @override
  Widget build(BuildContext context){
    return TextField(
      maxLines: maxLineas,
      style: TextStyle(color: Colores.blanco),
      controller: controller,
      decoration: InputDecoration(
        hintText: textoHint,
        hintStyle: TextStyle(color: Colores.blanco),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colores.azul
      )
    );
  }
}