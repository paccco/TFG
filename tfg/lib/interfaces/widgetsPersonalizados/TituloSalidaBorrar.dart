import 'package:flutter/material.dart';
import '../../constantes.dart';
import '../../ConexionBDLocal.dart';
import '../pantallas/Confirmacion.dart';

class TituloConSalidaBorrar extends StatelessWidget{

  final String titulo;

  const TituloConSalidaBorrar({super.key, required this.titulo});

  void _borrar(bool value, BuildContext context){
    BDLocal.instance.borrarEjer(titulo);
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
                onPressed: ()async{
                  final aux = await Navigator.push(context, MaterialPageRoute(builder: (context)=>Confirmacion()));
                  _borrar(aux, context);
                },
                icon: Image.asset('assets/images/papelera.png')
            )
        )
      ],
    );
  }

}