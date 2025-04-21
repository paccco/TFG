import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../constantes.dart';

class BotonContenidoBorrar extends StatelessWidget{

  final String texto;
  final Function() func;
  final Function() borrar;

  const BotonContenidoBorrar({super.key,required this.texto, required this.func,required this.borrar});

  @override
  Widget build(BuildContext context){
    return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: Container(
                height: 12.h,
                color: Colores.naranja,
                padding: EdgeInsets.all(20),
                alignment: Alignment.centerLeft,
                child: TextButton(
                    onPressed: func,
                    child: Text(texto,style: TextStyle(color: Colores.blanco, fontSize: 20.sp))
                ),
              )
          ),
          Container(
            height: 12.h,
            color: Colores.rojo,
            child: IconButton(
                onPressed: borrar,
                icon: Image.asset('assets/images/papelera.png')
            ),
          )
        ]
    );
  }

}