import 'package:flutter/material.dart';
import '../PopUps/Confirmacion.dart';
import '../constantes.dart';

class TituloConSalidaBorrar extends StatelessWidget{

  final String titulo;

  const TituloConSalidaBorrar({super.key, required this.titulo});

  void borrar(bool value, BuildContext context){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context){
    return AppBar(
      backgroundColor: Colores.azulOscuro,
      title: FittedBox(
        fit: BoxFit.cover,
        child: Center(child: Text(titulo, style: TextStyle(color: Colores.blanco, fontSize: Tamanios.fuenteTitulo))),
      ),
      leading: Container(
        width: Tamanios.appBarExitW,
        height: Tamanios.appBarH,
        color: Colores.naranja,
        child: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Image.asset('assets/images/exit.png')),
      ),
      actions: [
        Container(
          color: Colores.rojo,
            child: IconButton(
                onPressed: (){
                  showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return Confirmacion(decision: (value)=>borrar(value, context));
                      }
                  );
                },
                icon: Image.asset('assets/images/papelera.png')
            )
        )
      ],
    );
  }

}