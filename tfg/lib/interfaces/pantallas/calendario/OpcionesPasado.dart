import 'package:flutter/material.dart';
import '../plantillas/OpcionesDia.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/constantes.dart';
import 'MarcasEntrenamiento.dart';

class OpcionesPasado extends StatelessWidget{

  final DateTime diaSeleccionado;
  final List<Map<String,dynamic>> marcas;
  final String rutina;
  final bool entrenado;

  const OpcionesPasado({super.key, required this.diaSeleccionado, this.entrenado=false, required this.marcas, required this.rutina});

  @override
  Widget build(BuildContext context) {

    List<Widget> hijosSuperior=[], hijosInferior=[];

    if(rutina.isEmpty){
      hijosSuperior.add(Text("Descanso",style: TextStyle(fontSize: 22.sp, color: Colores.negro),));
    }else{
      if(entrenado){
        hijosSuperior.add(Text("Entrenado",style: TextStyle(fontSize: 22.sp, color: Colores.negro),));
        hijosInferior.add(
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (builder)=>MarcasEntrenamiento(fecha: diaSeleccionado, rutina: '', marcas: marcas)));
            },
            child: Container(
              alignment: Alignment.center,
              width: 80.w,
              height: 10.h,
              padding: EdgeInsets.all(2.h),
              color: Colores.naranja,
              child: Text("Ver marcas",style: TextStyle(fontSize: 22.sp, color: Colores.blanco)),
            ),
          )
        );
      }else{
        hijosSuperior.add(Text("Rutina sin entrenar",style: TextStyle(fontSize: 22.sp, color: Colores.negro),));
      }
    }

    return OpcionesDia(
        hijosSuperior: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: hijosSuperior,
        ),
        hijosInferior: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: hijosInferior,
        ),
        fechaTitulo: diaSeleccionado
    );
  }

}