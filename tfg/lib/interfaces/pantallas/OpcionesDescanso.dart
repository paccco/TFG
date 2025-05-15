import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tfg/ConexionBDLocal.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/interfaces/pantallas/OpcionesHoyFuturo.dart';
import 'package:tfg/interfaces/pantallas/SeleccionarRutina.dart';
import 'package:tfg/interfaces/pantallas/plantillas/OpcionesDia.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OpcionesDescanso extends StatelessWidget{

  final DateTime fecha;

  const OpcionesDescanso({super.key, required this.fecha});

  @override
  Widget build(BuildContext context) {
    return OpcionesDia(
        hijosSuperior: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Descanso", style: TextStyle(fontSize: 25.sp, color: Colores.negro),)
          ],
        ),
        hijosInferior: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async{
                final res=await Navigator.push(context, MaterialPageRoute(builder: (context)=>SeleccionarRutina()));

                if(res!="" && res!=null){
                  await BDLocal.instance.insertEntrenamiento(fecha, res);
                  Navigator.pop(context);
                }
              },
              child: Container(
                height: 12.h,
                alignment: Alignment.center,
                color: Colores.naranja,
                child: Text("Cambiar rutina",style: TextStyle(fontSize: 22.5.sp,color: Colores.blanco)),
              ),
            )
          ],
        ),
        fechaTitulo: fecha
    );
  }
}