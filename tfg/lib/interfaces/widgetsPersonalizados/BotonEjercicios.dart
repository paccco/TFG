import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/interfaces/pantallas/DatosEjercicios.dart';
import '../constantes.dart';

class Botonejercicios extends StatelessWidget{

  final String texto;
  final void Function() actualizar;

  const Botonejercicios({super.key,required this.texto,required this.actualizar});

  @override
  Widget build(BuildContext context){
    return Container(
      height: 12.h,
      color: Colores.naranja,
      padding: EdgeInsets.all(20),
      alignment: Alignment.centerLeft,
      child: TextButton(
          onPressed: () async{
            final res = await Navigator.push(context, MaterialPageRoute(builder: (constext)=>DatosEjercicios(titulo: texto)));

            print(res);

            if(res=='SI'){
              actualizar;
            }
          }, 
          child: Text(texto,style: TextStyle(color: Colores.blanco, fontSize: 20.sp))
      ),
    );
  }

}