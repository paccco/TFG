import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../constantes.dart';

class Confirmacion extends AlertDialog{

  final ValueChanged<bool> decision;

  const Confirmacion({super.key, required this.decision});

  Widget construyeBoton(String texto, Color color, BuildContext context){

    final TextStyle estilo=TextStyle(color: Colores.blanco, fontSize: 29.sp);

    return Container(
      width: 44.sp,
      color: color,
      alignment: Alignment.center,
      child: TextButton(
          onPressed: (){
            decision('SI'==texto);
            Navigator.pop(context,texto);
          },
          child: Text(texto,style: estilo)
      ),
    );
  }

  @override
  Widget build(BuildContext context){

    final TextStyle estilo=TextStyle(color: Colores.blanco, fontSize: 29.sp);

    return AlertDialog(
      backgroundColor: Colores.azulOscuro,
      title: Center(child: Text("¿Seguro?",style: estilo)),
      content:SizedBox(
        height: 15.h,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            construyeBoton("SI",Colores.azul,context),
            Spacer(),
            construyeBoton("NO",Colores.naranja,context)
          ],
        ),
      )
    );
  }
}