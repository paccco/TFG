import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../constantes.dart';

class BotonContenido extends StatelessWidget{

  final String texto;
  final Function() func;

  const BotonContenido({super.key,required this.texto, required this.func});

  @override
  Widget build(BuildContext context){
    return Container(
      height: 12.h,
      color: Colores.naranja,
      padding: EdgeInsets.all(20),
      alignment: Alignment.centerLeft,
      child: TextButton(
          onPressed: func,
          child: Text(texto,style: TextStyle(color: Colores.blanco, fontSize: 20.sp))
      ),
    );
  }

}