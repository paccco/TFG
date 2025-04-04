import 'package:flutter/material.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloSalidaBorrar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../constantes.dart';

class DatosEjercicios extends StatelessWidget{

  final String titulo;

  const DatosEjercicios ({super.key, required this.titulo});

  Widget hacerBoton(String texto){

    final TextStyle estiloBotones=TextStyle(color: Colores.blanco,fontSize: 20.sp);

    return Container(
        width: 50.w,
        color: Colores.naranja,
        child: TextButton(
            onPressed: (){},
            child: Text(texto,style: estiloBotones)
        )
    );
  }

  @override
  Widget build(BuildContext context){

    TextStyle estiloTexto=TextStyle(color: Colores.negro, fontSize: 20.sp);

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH),
          child: TituloConSalidaBorrar(titulo: titulo, )
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colores.grisClaro,
        child: Padding(
          padding: EdgeInsets.all(15),
            child: Column(
              spacing: 25,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Text("Marca Actual:\n7.4 repeticiones x 6 kg",style: estiloTexto)),
                Center(child: Text("Valoración actual: 4.5 / 5",style: estiloTexto),),
                hacerBoton("Graficar según\ntiempo"),
                Center(child: Text("Meta Actual:\n8 repeticiones x 6 kg",style: estiloTexto)),
                Center(child: Text("Sin cumplir",style: estiloTexto)),
                hacerBoton("Establecer\nmeta"),
              ],
            ),
        ),
      ),
    );
  }
}