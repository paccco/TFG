import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/ConexionBDLocal.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/interfaces/pantallas/misRutinas/AniadirRutina.dart';
import 'package:tfg/interfaces/pantallas/plantillas/ListaBusquedaAniadir.dart';
import 'DatosRutinas.dart';

class ListaRutinas extends StatefulWidget{
  const ListaRutinas({super.key});
  
  @override
  _ListaRutinasState createState() => _ListaRutinasState();
}

class _ListaRutinasState extends State<ListaRutinas>{
  Future<List<String>> _fetchRutinas() async{
    return await BDLocal.instance.getNombresRutinas();
  }

  void _cargarRutina(BuildContext context,String nombre) async{

    final rutina = await BDLocal.instance.getRutina(nombre);
    final campos = BDLocal.instance.camposRutinas;

    final TextEditingController contDescripcion=TextEditingController();
    final TextEditingController contDescanso=TextEditingController();

    contDescripcion.text=rutina[campos[1]];
    contDescanso.text=rutina[campos[3]];

    Navigator.push(context, MaterialPageRoute(builder: (context)=>DatosRutinas(titulo: nombre, rutina: rutina, campos: campos)));
  }

  Widget botonPopUp(String texto, Function() func, String asset){
    final double alturaBoton=6.h;

    return InkWell(
      onTap: func,
      child: Container(
        padding: EdgeInsets.all(2),
        height: alturaBoton,
        margin: EdgeInsets.all(5),
        alignment: Alignment.center,
        color: Colores.naranja,
        child: Row(
          children: [
            Text(texto,style: TextStyle(color: Colores.blanco,fontSize: 17.5.sp),),
            Spacer(),
            Image.asset(asset, height: alturaBoton,width: alturaBoton,)
          ],
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListaBusquedaAniadir(
        aniadir: (context)=>Navigator.push(context, MaterialPageRoute(builder: (context)=>AniadirRutina())),
        cargarContenido: _fetchRutinas,
        cargarElemento: _cargarRutina,
        titulo: "Mis rutinas"
    );
  }
}