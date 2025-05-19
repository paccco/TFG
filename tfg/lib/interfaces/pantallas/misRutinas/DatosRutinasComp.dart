import 'package:flutter/material.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloConSalida.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../API.dart';
import '../../../funcionesAux.dart';

class DatosRutinasComp extends StatelessWidget{
  final String titulo;
  final int id;
  final Map<String,dynamic> rutina;
  final List<String> listaEjer;
  final String creador;

  DatosRutinasComp({super.key, required this.titulo, required this.id, required this.rutina, required this.listaEjer, this.creador=""});

  Widget _creaBoton(String texto, Function() func){
    return InkWell(
        onTap: func,
        child: Container(
          alignment: Alignment.center,
          color: Colores.naranja,
          height: 8.h,
          child: Text(texto,style: TextStyle(color: Colores.blanco,fontSize: 18.sp)),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final estiloTitulo = TextStyle(color: Colores.negro,fontSize: 22.sp);
    final estiloTexto = TextStyle(color: Colores.negro,fontSize: 20.sp);

    String auxTitulo=(creador!="") ? "$titulo (by '$creador')" : titulo;

    return Scaffold(
      backgroundColor: Colores.grisClaro,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH),
          child: TituloConSalida(titulo: auxTitulo)
      ),
      body: Container(
        margin: EdgeInsets.all(2.h),
        child: Column(
          spacing: 2.h,
          children: [
            Container(
              padding: EdgeInsets.all(2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Descripción:",style: estiloTitulo),
                  Text(rutina['descripcion'],style: estiloTexto),
                  Text("Descargas: ",style: estiloTitulo,),
                  Text("${rutina['descargas']}",style: estiloTexto,),
                  Text("Descansos: ",style: estiloTitulo,),
                  Text(rutina['descansos'],style: estiloTexto,),
                  Text("Lista ejercicios: ",style: estiloTitulo,),
                  Text("$listaEjer",style: estiloTexto,)
                ],
              ),
            ),
            _creaBoton("Eliminar",() async{
              final aux= await borrarRutina(id);

              if(aux==0){
                Navigator.pop(context);
                mensaje(context, "Rutina eliminada correctamente");
              }else{
                mensaje(context, "Error al eliminar la rutina", error: true);
              }
            })
          ],
        ),
      ),
    );
  }
}