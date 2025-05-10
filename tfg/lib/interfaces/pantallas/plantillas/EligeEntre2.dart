import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloConSalida.dart';

class EligeEntre2 extends StatelessWidget{

  final String titulo;
  final String pregunta;
  final String opcion1, opcion2;
  final Function() func1, func2;

  const EligeEntre2({super.key, required this.titulo, required this.pregunta, required this.opcion1, required this.opcion2, required this.func1, required this.func2});

  Widget _creaBoton(String texto, Function() func, Color color){
    return InkWell(
        onTap: func,
        child: Container(
          padding: EdgeInsets.all(2.h),
          color: color,
          alignment:  Alignment.center,
          child: Text(texto, style: TextStyle(fontSize: 25.sp, color: Colores.blanco)),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colores.grisClaro,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH),
          child: TituloConSalida(titulo: titulo)
      ),
      body: Center(
        child: Container(
          height: 60.h,
          margin: EdgeInsets.all(5.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                  child: Text(pregunta,style: TextStyle(fontSize: 30.sp,color: Colores.negro),)
              ),
              Spacer(),
              _creaBoton(opcion1, func1, Colores.azul),
              Spacer(),
              _creaBoton(opcion2, func2, Colores.naranja)
            ],
          ),
        ),
      )
    );
  }
}