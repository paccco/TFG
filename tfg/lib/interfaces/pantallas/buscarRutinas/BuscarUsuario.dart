import 'package:flutter/material.dart';
import 'package:tfg/API.dart';
import 'BuscarRutinasUsuario.dart';
import '../plantillas/ListaBusqueda.dart';


class BuscarUsuario extends StatefulWidget{

  const BuscarUsuario({super.key});
  @override
  _BuscarUsuarioState createState() => _BuscarUsuarioState();
}

class _BuscarUsuarioState extends State<BuscarUsuario>{


  Future<List<String>> _cargarUsuarios() async{
    final res = await getUsuarios();

    return res;
  }

  void _cargarInfoRutina(BuildContext context, String usuario) async{
    Navigator.push(context, MaterialPageRoute(builder: (context) => BuscarRutinasUsuario(usuario: usuario)));
  }

  @override
  Widget build(BuildContext context){
    return ListaBusqueda(
        titulo: "Buscar usuario",
        cargarContenido: _cargarUsuarios,
        cargarElemento: _cargarInfoRutina
    );
  }

}