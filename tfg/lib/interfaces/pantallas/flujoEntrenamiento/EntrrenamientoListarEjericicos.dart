import 'package:flutter/material.dart';
import 'package:tfg/constantes.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../widgetsPersonalizados/TituloSimple.dart';

class EntrenamientoListarEjericicos extends StatelessWidget{
  
  final List<String> ejercicios;
  final String descanso;

  const EntrenamientoListarEjericicos({super.key, required this.ejercicios, required this.descanso});

  List<Widget> _hijosColumna(){
    List<Widget> out=[];
    final TextStyle estilo=TextStyle(color: Colores.negro, fontSize: 23.sp);

    for(int i=0; i<ejercicios.length; i++){
      out.add(Text("${i+1}. ${ejercicios[i]}", style: estilo));
    }

    out.add(Text("Descanso: $descanso",style: estilo,));

    return out;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colores.grisClaro,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH),
          child: TituloSimple(titulo: "Ejercicios")
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(2.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 2.h,
          children: _hijosColumna(),
        ),
      ),
        bottomNavigationBar: InkWell(
          onTap: ()=>Navigator.pop(context),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(2.h),
          color: Colores.naranja,
          height: 15.h,
          child: Text("Empezar",style: TextStyle(color: Colores.blanco, fontSize: 30.sp),),
        ),
      ),
    );
  }
}