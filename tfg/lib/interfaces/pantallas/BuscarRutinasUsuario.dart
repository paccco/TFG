import 'package:flutter/material.dart';
import 'package:tfg/API.dart';
import 'package:tfg/interfaces/pantallas/DatosRutinasComp.dart';
import 'plantillas/ListaBusquedaConId.dart';

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

  void _cargarInfoRutina(BuildContext context, String nombreRutina, int id) async{
    final rutina=await getRutina(id);
    final listaEjer=await getEjerciciosRutina(id);

    Navigator.push(context, MaterialPageRoute(builder: (context) => DatosRutinasComp(
        titulo: nombreRutina,
        id: id,
        rutina: rutina,
        listaEjer: listaEjer
    )));
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