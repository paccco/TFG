import 'package:flutter/material.dart';
import 'package:tfg/constantes.dart';
import '../../widgetsPersonalizados/TituloSimple.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RealizandoEjercicio extends StatelessWidget{

  final String ejercicio;

  const RealizandoEjercicio({super.key, required this.ejercicio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colores.grisClaro,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH),
          child: TituloSimple(titulo: ejercicio)
      ),
      body: Container(
        margin: EdgeInsets.all(2.h),
        alignment: Alignment.center,
        child: Text("Vamos!!!", style: TextStyle(color: Colores.negro, fontSize: 30.sp)),
      ),
      bottomNavigationBar: InkWell(
        onTap: ()=>Navigator.pop(context),
        child: Container(
          height: 15.h,
          alignment: Alignment.center,
          padding: EdgeInsets.all(2.h),
          color: Colores.azul,
          child: Text("Fin de serie", style: TextStyle(color: Colores.blanco, fontSize: 27.5.sp))
        ),
      ),
    );
  }
}