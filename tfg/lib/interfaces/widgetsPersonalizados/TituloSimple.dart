import 'package:flutter/material.dart';
import '../../constantes.dart';

class TituloSimple extends StatelessWidget{

  final String titulo;

  const TituloSimple({super.key, required this.titulo});

  @override
  Widget build(BuildContext context){
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colores.azulOscuro,
      title: Center(
        child: Text(titulo, style: TextStyle(color: Colores.blanco, fontSize: Tamanios.fuenteTitulo)),
      ),
    );
  }
}