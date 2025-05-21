import 'package:flutter/material.dart';
import 'package:tfg/constantes.dart';
import '../../widgetsPersonalizados/TituloSimple.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PantallasEntrenamiento extends StatefulWidget{

  final bool boton;
  final String titulo, textoBoton;
  final List<Widget> hijos;

  const PantallasEntrenamiento({super.key,required this.titulo, required this.hijos, this.textoBoton="", this.boton=false});

  @override
  _PantallasEntrenamientoState createState() => _PantallasEntrenamientoState();
}

class _PantallasEntrenamientoState extends State<PantallasEntrenamiento>{
  @override
  Widget build(BuildContext context) {
    if(widget.boton){
      return PopScope(
        canPop: false,
          child: Scaffold(
            backgroundColor: Colores.grisClaro,
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(Tamanios.appBarH),
                child: TituloSimple(titulo: widget.titulo)
            ),
            body: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(2.h),
              child: Column(
                spacing: 2.h,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.hijos,
              ),
            ),
            bottomNavigationBar: InkWell(
              onTap: ()=>Navigator.pop(context),
              child: Container(
                alignment: Alignment.center,
                color: Colores.azul,
                padding: EdgeInsets.all(2.h),
                height: 15.h,
                child: Text(widget.textoBoton, style: TextStyle(fontSize: 30.sp, color: Colores.blanco)),
              ),
            ),
          )
      );
    }else{
      return PopScope(
        canPop: false,
          child: Scaffold(
            backgroundColor: Colores.grisClaro,
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(Tamanios.appBarH),
                child: TituloSimple(titulo: widget.titulo)
            ),
            body: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(2.h),
              child: Column(
                spacing: 2.h,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.hijos,
              ),
            ),
          )
      );
    }
  }
}