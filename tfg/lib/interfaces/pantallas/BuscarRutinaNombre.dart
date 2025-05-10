import 'package:flutter/material.dart';
import 'package:tfg/API.dart';
import 'package:tfg/interfaces/pantallas/DatosRutinasComp.dart';
import 'plantillas/ListaBusquedaConId.dart';

class BuscarRutinaNombre extends StatefulWidget{
  const BuscarRutinaNombre({super.key});

  @override
  _BuscarRutinaNombreState createState() => _BuscarRutinaNombreState();
}

class _BuscarRutinaNombreState extends State<BuscarRutinaNombre>{


  Future<Map<int,String>> _cargarRutinas() async{
    final rutinas=await getRutinas();

    return rutinas;
  }

  void _cargarInfoRutina(BuildContext context, String nombreRutina, int id) async{
    final rutina=await getRutina(id, usuario: true);
    final listaEjer=await getEjerciciosRutina(id);
    final String creador=rutina['usuario'];

    Navigator.push(context, MaterialPageRoute(builder: (context) => DatosRutinasComp(
        titulo: nombreRutina,
        id: id,
        rutina: rutina,
        listaEjer: listaEjer,
        creador: creador,
    )
    ));
  }

  @override
  Widget build(BuildContext context){
    return ListaBusquedaConId(
        titulo: "Buscar rutinas por nombre",
        cargarContenido: _cargarRutinas,
        cargarElemento: _cargarInfoRutina
    );
  }

}