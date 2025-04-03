import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/BarraNavegacion.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/CajaEjercicios.dart';
import '../widgetsPersonalizados/BarraTexto.dart';
import '../widgetsPersonalizados/BotonBool.dart';
import '../constantes.dart';

//AHORA MISMO LO PONGO COMO GLOBAL PARA QUE VAYA MAS RAPIDO

List<Widget> ejercicios=[
  CajaEjercicios(texto: "Ejercicio 1"),
  CajaEjercicios(texto: "Ejercicio 2"),
  CajaEjercicios(texto: "Ejercicio 3"),
  CajaEjercicios(texto: "Ejercicio 4"),
  CajaEjercicios(texto: "Ejercicio 5"),
  CajaEjercicios(texto: "Ejercicio 6"),
  CajaEjercicios(texto: "Ejercicio 7")
];

class ListaAniadir extends StatefulWidget {
  const ListaAniadir({super.key});

  @override
  ListaAniadirState createState() => ListaAniadirState();
}

class ListaAniadirState extends State<ListaAniadir>{

  final int elementosVisibles=4;
  int index=0;

  void navegar(bool value){
    if(value){
      if(index+elementosVisibles > ejercicios.length)
        index+=elementosVisibles;
      else
        index+=elementosVisibles;
    }

    if(!value && 0<(index-elementosVisibles)) {
      index-=elementosVisibles;
    }
  }

  final TextEditingController contBarraBusqueda = TextEditingController();
  final TextEditingController contNomEjercicio = TextEditingController();

  @override
  Widget build(BuildContext build){

    final BarraTexto barraBusqueda=BarraTexto(controller: contBarraBusqueda,textoHint: "Buscar");
    final BarraTexto barraNombreEjer=BarraTexto(controller: contNomEjercicio, textoHint: "Nombre");

    final BarraNavegacion barraNav=BarraNavegacion(navegar: navegar);

    bool repeticiones, peso, tiempo, distancia;
    repeticiones=peso=tiempo=distancia=false;

    BotonBool repBot=BotonBool(miBool: repeticiones, texto: "Repeticiones", cambio: (value) {repeticiones=value;});
    BotonBool pesoBot=BotonBool(miBool: peso, texto: "Peso", cambio: (value){peso=value;});
    BotonBool tiemBot=BotonBool(miBool: tiempo, texto: "Tiempo", cambio: (value){tiempo=value;});
    BotonBool distBot=BotonBool(miBool: distancia, texto: "Distancia", cambio: (value){distancia=value;});

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH),
          child: AppBar(
              backgroundColor: Colores.azulOscuro,
              title: Text("Mis ejercicios", style: TextStyle(color: Colores.blanco, fontSize: Tamanios.fuenteTitulo)),
              leading: Container(
                        width: Tamanios.appBarExitW,
                        height: Tamanios.appBarH,
                        decoration: BoxDecoration(
                            color: Colores.naranja
                        ),
                        child: IconButton(onPressed: (){}, icon: Image.asset('assets/images/exit.png')),
                    ),
          ),
      ),
        body: Container(
          color: Colores.grisClaro,
          child: Container(
          padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  barraBusqueda,
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconButton(
                          onPressed: (){
                            showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return AlertDialog(
                                      backgroundColor: Colores.azulOscuro,
                                      title: Center(
                                          child: Text("Añadir ejercicios",style: TextStyle(color: Colores.blanco)),
                                      ),
                                      content: Container(
                                        color: Colores.grisClaro,
                                        height: 45.h,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Container(padding: EdgeInsets.all(5),child: Text("Nombre",style: TextStyle(fontSize: Tamanios.fuentePopUp))),
                                            Container(padding: EdgeInsets.all(5),child: barraNombreEjer),
                                            Container(padding: EdgeInsets.all(5), child: Text("Parámetros", style: TextStyle(fontSize: Tamanios.fuentePopUp))),
                                            Expanded(child: Wrap(
                                              alignment: WrapAlignment.center,
                                              spacing: 10.0,
                                              children: [
                                                repBot,pesoBot,tiemBot,distBot
                                              ],
                                            )),
                                            FilledButton(
                                              style: ButtonStyle(
                                                backgroundColor: WidgetStateProperty.all(Colores.naranja)
                                              ),
                                                onPressed: (){
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Guardar")
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
                    children: visibe
                  )
                ],
              )
          ),
        ),
      bottomNavigationBar: barraNav
    );
  }
}