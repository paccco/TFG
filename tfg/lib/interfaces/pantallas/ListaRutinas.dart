import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/ConexionBDLocal.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/funcionesAux.dart';
import 'package:tfg/interfaces/pantallas/ListaEjerRutina.dart';
import 'package:tfg/interfaces/pantallas/plantillas/ListaBusquedaAniadir.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/BarraTexto.dart';
import 'DatosRutinas.dart';

class ListaRutinas extends StatefulWidget{
  const ListaRutinas({super.key});
  
  @override
  _ListaRutinasState createState() => _ListaRutinasState();
}

class _ListaRutinasState extends State<ListaRutinas>{
  Future<void> _aniadir(BuildContext context) async{

    final TextEditingController contNom=TextEditingController();
    final TextEditingController contDescanso=TextEditingController();
    final TextEditingController contDescripcion=TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            backgroundColor: Colores.azulOscuro,
            title: Text("Nueva rutina",style: TextStyle(color: Colores.blanco)),
            content: Column(
              spacing: 5,
              mainAxisSize: MainAxisSize.min,
              children: [
                BarraTexto(controller: contNom,textoHint: "Nombre",),
                BarraTexto(controller: contDescanso,textoHint: "Descanso: hh:mm:ss",tipoInput: TextInputType.datetime),
                BarraTexto(controller: contDescripcion,textoHint: "Descripcion",maxLineas: 3,)
              ],
            ),
            actions: [
              Container(
                color: Colores.naranja,
                child: TextButton(
                    onPressed: () async {
                      final nombre = contNom.value.text;
                      final descanso = contDescanso.value.text;
                      final descripcion = contDescripcion.value.text;

                      if(validarFormatoHora(descanso)){
                        final aux=await BDLocal.instance.insertRutina(nombre,descripcion,descanso);
                        setState(() {});
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ListaEjerRutina(titulo: aux)));
                      }else{
                        mensaje(context, "Descanso hh:mm:ss", error: true);
                      }
                    },
                    child: Text("Seguir", style: TextStyle(color: Colores.blanco))
                )
              )
            ],
          );
        }
    );
  }

  Future<List<String>> _fetchRutinas() async{
    return await BDLocal.instance.getNombresRutinas();
  }

  void _cargarRutina(BuildContext context,String nombre) async{

    final rutina = await BDLocal.instance.getRutina(nombre);
    final campos = BDLocal.instance.camposRutinas;
    String descanso = rutina[campos[3]];
    TextStyle estilo=TextStyle(color: Colores.negro,fontSize: 20.sp);

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
        aniadir: (context)=>_aniadir(context),
        cargarContenido: _fetchRutinas,
        cargarElemento: _cargarRutina,
        titulo: "Mis rutinas"
    );
  }
}