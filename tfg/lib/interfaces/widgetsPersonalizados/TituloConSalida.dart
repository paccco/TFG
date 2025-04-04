import 'package:flutter/material.dart';
import '../constantes.dart';

class TituloConSalida extends StatelessWidget{

  final String titulo;

  const TituloConSalida({super.key, required this.titulo});

  @override
  Widget build(BuildContext context){
    return AppBar(
        backgroundColor: Colores.azulOscuro,
        title: Text("Mis ejercicios", style: TextStyle(color: Colores.blanco, fontSize: Tamanios.fuenteTitulo)),
        leading: Container(
          width: Tamanios.appBarExitW,
          height: Tamanios.appBarH,
          decoration: BoxDecoration(
              color: Colores.naranja
          ),
          child: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Image.asset('assets/images/exit.png')),
        ),
      );
  }

}