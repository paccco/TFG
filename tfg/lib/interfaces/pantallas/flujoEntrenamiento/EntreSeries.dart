import 'package:flutter/material.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/interfaces/pantallas/flujoEntrenamiento/RealizandoEjercicio.dart';
import 'package:tfg/interfaces/pantallas/plantillas/PantallasEntrenamiento.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloSimple.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EntreSeries extends StatelessWidget{

  final String ejercicio;
  final bool primeraSerie;

  const EntreSeries({super.key, required this.ejercicio, this.primeraSerie=false});
  
  Widget _boton(BuildContext context,String texto, Color color, {bool finEjercicio=false}){
    return InkWell(
      onTap: (){
        Navigator.pop(context,finEjercicio);
      },
      child: Container(
        color: color,
        height: 15.h,
        padding: EdgeInsets.all(2.h),
        alignment: Alignment.center,
        child: Text(texto,style: TextStyle(fontSize: 26.sp,color: Colores.blanco)),
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    
    List<Widget> botones=[_boton(context,"Empezar Serie", Colores.azul)];
    
    if(!primeraSerie){
      botones.add(_boton(context,"Fin del ejercicio", Colores.naranja, finEjercicio: true));
    }

    return PantallasEntrenamiento(
        titulo: ejercicio,
        hijos: botones
    );
  }
}