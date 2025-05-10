import 'package:flutter/material.dart';
import 'package:tfg/API.dart';
import 'package:tfg/constantes.dart';
import '../../funcionesAux.dart';
import 'plantillas/ListaBusquedaConId.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ListaRutinasCompartidas extends StatefulWidget{

  final String usuario;

  const ListaRutinasCompartidas({super.key, required this.usuario});
  @override
  State<ListaRutinasCompartidas> createState() => _ListaRutinasCompartidasState();
}

class _ListaRutinasCompartidasState extends State<ListaRutinasCompartidas>{


  Future<Map<int,String>> _cargarRutinas() async{
    final rutinas=await getRutinaCompDeUser(widget.usuario);

    return rutinas;
  }

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

  void _cargarInfoRutina(BuildContext context, String nombreRutina, int id) async{
    final rutina=await getRutina(id);
    final listaEjer=await getEjerciciosRutina(id);
    final estiloTitulo = TextStyle(color: Colores.blanco,fontSize: 18.sp);
    final estiloTexto = TextStyle(color: Colores.blanco,fontSize: 16.sp);

    showDialog(
        context: context,
        builder: (BuildContext context){

          return AlertDialog(
            backgroundColor: Colores.azulOscuro,
            title: Text(nombreRutina,style: TextStyle(color: Colores.blanco,fontSize: 20.sp)),
            content: SizedBox(
              height: 40.h,
              child: Column(
                spacing: 5,
                children: [
                  Container(
                    width: 60.w,
                    height: 29.h,
                    padding: EdgeInsets.all(1.h),
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
                      setState(() {

                      });
                      mensaje(context, "Rutina eliminada correctamente");
                    }else{
                      mensaje(context, "Error al eliminar la rutina", error: true);
                    }
                  })
                ],
              )
              ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context){
    return ListaBusquedaConId(
        titulo: "Rutinas Compartidas",
        cargarContenido: _cargarRutinas,
        cargarElemento: _cargarInfoRutina
    );
  }

}