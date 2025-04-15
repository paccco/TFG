import 'package:flutter/material.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/interfaces/PopUps/DialogosError.dart';
import 'package:tfg/interfaces/pantallas/EjerciciosRutina.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/BarraTexto.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloConSalida.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ListaRutinas extends StatefulWidget{
  const ListaRutinas({super.key});

  @override
  ListaRutinasState createState() => ListaRutinasState();
}

class ListaRutinasState extends State<ListaRutinas>{

  final TextEditingController contBarraBusqueda = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final BarraTexto barraBusqueda=BarraTexto(controller: contBarraBusqueda);

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH),
          child: TituloConSalida(titulo: "Mis rutinas"),
        ),
        body: Container(
          color: Colores.grisClaro,
          child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    height: 8.h,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 74.w,
                          child: barraBusqueda,
                        ),
                        Container(
                          color: Colores.naranja,
                          child: IconButton(
                              onPressed: (){
                                //_filtrar(contBarraBusqueda.text);
                              },
                              icon: Image.asset('assets/images/lupa.png',height: Tamanios.lupa, width: Tamanios.lupa,)
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconButton(
                          onPressed: (){
                            final TextEditingController controller = TextEditingController();

                            showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  
                                  return AlertDialog(
                                    backgroundColor: Colores.azulOscuro,
                                    title: Center(
                                      child: Text("Añadir rutina",style: TextStyle(color: Colores.blanco)),
                                    ),
                                    content: Container(
                                      padding: EdgeInsets.all(10),
                                      color: Colores.grisClaro,
                                      height: 17.h,
                                      child: Column(
                                        spacing: 10,
                                        children: [
                                          BarraTexto(controller: controller, textoHint: "Nombre de la rutina"),
                                          Container(
                                            color: Colores.naranja,
                                            child: TextButton(
                                                onPressed: (){
                                                  String nombreRut=controller.value.text;

                                                  if(nombreRut.isNotEmpty){
                                                    //Comprobar si existe la rutina
                                                    Navigator.push(context,MaterialPageRoute(builder: (BuildContext context)=>EjerciciosRutina(titulo: nombreRut)));
                                                  }else{
                                                    mensaje(context, "Rellena el nombre");
                                                    }
                                                },
                                                child: Text("Añadir ejercicios",style: TextStyle(color: Colores.blanco,fontSize: 15.sp))
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }
                            );
                          },
                          icon: Image.asset(
                              'assets/images/aniadir.png',
                              height: Tamanios.botonAniadir,
                              width: Tamanios.botonAniadir
                          )
                      ),
                      Text("Añadir",style: TextStyle(color: Colores.negro, fontSize: Tamanios.fuenteAniadir))
                    ],
                  ),
                  /*
                  * Los elementos irian aqui
                  * */
                  Column(
                      spacing: 5.0,
                      children: []
                  )
                ],
              )
          ),
        )
    );
  }
}