import 'package:flutter/material.dart';
import 'package:tfg/API.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/funcionesAux.dart';
import 'package:tfg/interfaces/PopUps/DialogosError.dart';
import 'plantillas/ListaBusquedaConId.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BuscarRutinasUsuario extends StatefulWidget{

  final String usuario;

  const BuscarRutinasUsuario({super.key, required this.usuario});
  @override
  _BuscarRutinasUsuarioState createState() => _BuscarRutinasUsuarioState();
}

class _BuscarRutinasUsuarioState extends State<BuscarRutinasUsuario>{
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
                    _creaBoton("Descargar", () async {
                      final aux=await descargarRutina(id, nombreRutina);
                      if(aux){
                        mensaje(context, "Rutina descargada correctamente");
                      }else{
                        mensaje(context, "Error al descargar la rutina");
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
        titulo: "Rutinas de ${widget.usuario}",
        cargarContenido: _cargarRutinas,
        cargarElemento: _cargarInfoRutina
    );
  }

}