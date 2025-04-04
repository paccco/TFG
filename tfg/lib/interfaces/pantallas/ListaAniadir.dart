import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/BarraNavegacion.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/BotonEjercicios.dart';
import '../widgetsPersonalizados/BarraTexto.dart';
import '../widgetsPersonalizados/BotonBool.dart';
import '../widgetsPersonalizados/TituloConSalida.dart';
import '../constantes.dart';
import '../../ConexionBDLocal.dart';

//AHORA MISMO LO PONGO COMO GLOBAL PARA QUE VAYA MAS RAPIDO

class ListaAniadir extends StatefulWidget {
  const ListaAniadir({super.key});

  @override
  ListaAniadirState createState() => ListaAniadirState();
}

class ListaAniadirState extends State<ListaAniadir>{

  final int elementosVisibles=4;
  List<Widget> ejercicios=[];
  List<Widget> visible=[];
  int index=0;

  Future<void> borrar() async{

  }

  Future<void> fetchContenido() async{
    final elementosFetched = await BDLocal.instance.getNombreEjercicios();

    setState(() {
      for (var elemento in elementosFetched) {
        ejercicios.add(Botonejercicios(texto: elemento.values.first));
      }

      if(ejercicios.length>elementosVisibles) {
        visible=ejercicios.sublist(0,elementosVisibles);
      } else {
        visible=ejercicios;
      }

      index=0;
    });
  }

  void navegar(bool value){
    int cont=0;
    visible.clear();

    if(value && (index+elementosVisibles)<ejercicios.length){
      index+=elementosVisibles;
    }else if(!value && (index-elementosVisibles)>=0){
      index-=elementosVisibles;
    }

    while(cont<elementosVisibles && (index+cont)<ejercicios.length){
      visible.add(ejercicios.elementAt(index+cont));
      cont++;
    }

    print(ejercicios.length);

    setState(() {});
  }

  final TextEditingController contBarraBusqueda = TextEditingController();
  final TextEditingController contNomEjercicio = TextEditingController();
  final TextEditingController descEjercicio = TextEditingController();

  @override
  void initState() {
    fetchContenido();
    super.initState();
  }

  @override
  Widget build(BuildContext build){

    final BarraTexto barraBusqueda=BarraTexto(controller: contBarraBusqueda,textoHint: "Buscar");
    final BarraTexto barraNombreEjer=BarraTexto(controller: contNomEjercicio, textoHint: "Nombre");
    final BarraTexto barraDesc=BarraTexto(controller: descEjercicio, textoHint: "Descripcion");

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
          child: TituloConSalida(titulo: "Mis ejercicios")
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
                                        height: 52.h,
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
                                            Padding(padding: EdgeInsets.all(5),child: barraDesc),
                                            FilledButton(
                                              style: ButtonStyle(
                                                backgroundColor: WidgetStateProperty.all(Colores.naranja)
                                              ),
                                                onPressed: (){
                                                  int codTipo;
                                                  String desc, nombre;

                                                  if(!contNomEjercicio.value.text.isEmpty){
                                                    nombre=contNomEjercicio.value.text;
                                                    if(!descEjercicio.value.text.isEmpty){
                                                      desc=descEjercicio.value.text;
                                                      if(repeticiones || tiempo){
                                                        String byte="";

                                                        byte += (repeticiones ? '1' : '0');
                                                        byte += (tiempo ? '1' : '0');
                                                        byte += (peso ? '1' : '0');
                                                        byte += (distancia ? '1' : '0');
                                                        byte += '0000';

                                                        codTipo=int.parse(byte,radix: 2);

                                                        Map<String,dynamic> datos={
                                                          BDLocal.instance.camposEjercicios[0] :  nombre,
                                                          BDLocal.instance.camposEjercicios[1] :  codTipo,
                                                          BDLocal.instance.camposEjercicios[2] :  desc
                                                        };

                                                        BDLocal.instance.insertEjercicios(datos);
                                                        setState(() {

                                                        });
                                                      }
                                                    }
                                                  }

                                                  Navigator.pop(context);
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
                    children: visible
                  )
                ],
              )
          ),
        ),
      bottomNavigationBar: barraNav
    );
  }
}