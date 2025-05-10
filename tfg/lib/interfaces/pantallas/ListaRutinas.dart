import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/API.dart';
import 'package:tfg/ConexionBDLocal.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/funcionesAux.dart';
import 'package:tfg/interfaces/pantallas/ListaEjerRutina.dart';
import 'package:tfg/interfaces/pantallas/plantillas/ListaBusquedaAniadir.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/BarraTexto.dart';
import 'Confirmacion.dart';

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

    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            backgroundColor: Colores.azulOscuro,
            title: Center(
              child: Text(nombre,style: TextStyle(color: Colores.blanco,fontSize: Tamanios.fuenteTitulo)),
            ),
            content: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(5),
              color: Colores.grisClaro,
              height: 10.h,
              child: Column(
                spacing: 5,
                children: [
                  Text("Valoracion 4.3 / 5",style: estilo),
                  Text("Descanso $descanso",style: estilo)
                ],
              ),
            ),
            actions: [
              botonPopUp("Compartir", () async{
                bool decision=false;
                decision=await Navigator.push(context, MaterialPageRoute(builder: (context)=>Confirmacion()));

                if(decision){
                  final res=await subirRutina(nombre);
                  if(res==-2){
                    mensaje(context, "La rutina ha de contener ejercicios para poder compartirse", error: true);
                  }else if(res>=0){
                    mensaje(context, "Rutina subida correctamente");
                  }
                }
              }, 'assets/images/subir.png'),
              botonPopUp("Modificar", () async {
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      TextStyle estilo=TextStyle(color: Colores.negro,fontSize: 17.5.sp);

                      return AlertDialog(
                        backgroundColor: Colores.grisClaro,
                        content: SizedBox(
                          height: 28.h,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            spacing: 5,
                            children: [
                              Text("Descanso",style: estilo),
                              BarraTexto(controller: contDescanso),
                              Text("Descripcion",style: estilo),
                              BarraTexto(controller: contDescripcion,textoHint: "Descripcion",maxLineas: 3)
                            ],
                          ),
                        ),
                        actions: [
                          botonPopUp("Guardar", (){
                            final descanso=contDescanso.value.text;
                            if(validarFormatoHora(descanso)){
                              BDLocal.instance.modDescripcionDescansoRutina(nombre, contDescripcion.value.text, descanso);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }else{
                              mensaje(context, "Descanso hh:mm:ss",error: true);
                            }
                          },
                              'assets/images/save.png'
                          )
                        ],
                      );
                    }
                );
              },'assets/images/mod.png'),
              botonPopUp(
                  "Ejercicios",
                      (){Navigator.push(context, MaterialPageRoute(builder: (context)=>ListaEjerRutina(titulo: nombre)));},
                  'assets/images/ejercicio.png'
              ),
              botonPopUp("Eliminar", () async {

                bool decision=false;
                decision = await Navigator.push(context, MaterialPageRoute(builder: (context)=>Confirmacion()));

                if(decision){
                  await BDLocal.instance.borrarRutina(nombre);
                  Navigator.pop(context);
                  setState(() {});
                }
              },'assets/images/papelera.png')
            ]
          );
        }
    );
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