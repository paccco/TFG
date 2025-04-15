import 'package:flutter/material.dart';
import './DatosEjercicios.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/BarraNavegacion.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/BotonEjercicios.dart';
import '../widgetsPersonalizados/BarraTexto.dart';
import '../widgetsPersonalizados/BotonBool.dart';
import '../widgetsPersonalizados/TituloConSalida.dart';
import '../../constantes.dart';
import '../../ConexionBDLocal.dart';


class ListaEjercicios extends StatefulWidget {
  const ListaEjercicios({super.key});

  @override
  ListaEjerciciosState createState() => ListaEjerciciosState();
}

class ListaEjerciciosState extends State<ListaEjercicios>{

  final int elementosVisibles=4;
  List<String> ejercicios=[];
  List<String> ejerciciosFiltrados=[];
  List<Widget> visible=[];
  int index=0;

  void _setVisble(){
    visible.clear();
    int cont=0;
    while(cont<elementosVisibles && (index+cont)<ejerciciosFiltrados.length){
      final aux=ejerciciosFiltrados[index+cont];
      visible.add(Botonejercicios(texto: aux, func: ()=>_cargarDatosEjercicio(aux)));
      cont++;
    }
  }

  Future<void> _cargarDatosEjercicio(String texto) async{
    final res = await Navigator.push(context, MaterialPageRoute(builder: (constext)=>DatosEjercicios(titulo: texto)));

    if(res=='SI'){
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (constext)=>ListaEjercicios()));
    }
  }

  void _fetchContenido() async{
    final elementosFetched = await BDLocal.instance.getNombreEjercicios();

    ejercicios=List.from(elementosFetched);

    ejerciciosFiltrados=List.from(ejercicios);
    index=0;

    int cont=0;
    while(cont<elementosVisibles && (index+cont)<ejercicios.length){
      final aux=ejercicios[cont];
      visible.add(Botonejercicios(texto: aux,func: () => _cargarDatosEjercicio(aux)));
      cont++;
    }

    _setVisble();
    setState(() {});
  }

  void _filtrar(String query){
    ejerciciosFiltrados = ejercicios.where((ejercicio) {
      return ejercicio.toLowerCase().contains(query.toLowerCase());
    }).toList();

    index=0;
    _setVisble();
    setState(() {});
  }

  void _navegar(bool value){
    if(value && (index+elementosVisibles)<ejerciciosFiltrados.length){
      index+=elementosVisibles;
      _setVisble();
      setState(() {});
    }else if(!value && (index-elementosVisibles)>=0){
      index-=elementosVisibles;
      _setVisble();
      setState(() {});
    }
  }

  final TextEditingController contBarraBusqueda = TextEditingController();
  final TextEditingController contNomEjercicio = TextEditingController();
  final TextEditingController descEjercicio = TextEditingController();

  @override
  void initState() {
    _fetchContenido();
    super.initState();
  }

  @override
  Widget build(BuildContext build){
    final BarraTexto barraBusqueda=BarraTexto(controller: contBarraBusqueda, textoHint: "Buscar",);
    final BarraTexto barraNombreEjer=BarraTexto(controller: contNomEjercicio, textoHint: "Nombre");
    final BarraTexto barraDesc=BarraTexto(controller: descEjercicio, textoHint: "Descripcion");

    final BarraNavegacion barraNav=BarraNavegacion(navegar: _navegar);

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
                                _filtrar(contBarraBusqueda.text);
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
                            showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return AlertDialog(
                                      backgroundColor: Colores.azulOscuro,
                                      title: Center(
                                          child: Text("Añadir ejercicios",style: TextStyle(color: Colores.blanco)),
                                      ),
                                      content: Container(
                                        height: 45.h,
                                        color: Colores.grisClaro,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Container(padding: EdgeInsets.all(5),child: Text("Nombre",style: TextStyle(fontSize: Tamanios.fuentePopUp))),
                                            Container(padding: EdgeInsets.all(5),child: barraNombreEjer),
                                            Container(padding: EdgeInsets.all(5), child: Text("Parámetros", style: TextStyle(fontSize: Tamanios.fuentePopUp))),
                                            Expanded(child: Wrap(
                                              alignment: WrapAlignment.center,
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

                                                  if(contNomEjercicio.value.text.isNotEmpty){
                                                    nombre=contNomEjercicio.value.text;
                                                    if(descEjercicio.value.text.isNotEmpty){
                                                      desc=descEjercicio.value.text;
                                                      if(repeticiones || tiempo || distancia || peso){
                                                        String byte="";

                                                        byte += (repeticiones ? '1' : '0');
                                                        byte += (peso ? '1' : '0');
                                                        byte += (tiempo ? '1' : '0');
                                                        byte += (distancia ? '1' : '0');
                                                        byte += '0000';

                                                        codTipo=int.parse(byte,radix: 2);

                                                        Map<String,dynamic> datos={
                                                          BDLocal.instance.camposEjercicios[0] :  nombre,
                                                          BDLocal.instance.camposEjercicios[1] :  codTipo,
                                                          BDLocal.instance.camposEjercicios[2] :  desc
                                                        };

                                                        BDLocal.instance.insertEjercicios(datos).then((value){
                                                          if(value<0){
                                                            showDialog(
                                                                context: context,
                                                                builder: (BuildContext context){
                                                                  return AlertDialog(
                                                                    title: Text("Fallo al guardar ejercicio"),
                                                                  );
                                                                }
                                                            );
                                                          }
                                                        });
                                                        Navigator.pop(context);
                                                        _fetchContenido();
                                                      }else{
                                                        showDialog(context: context, builder: (BuildContext context){return AlertDialog(title: Text("Rellene el campo tipo "));});
                                                      }
                                                    }else{
                                                      showDialog(context: context, builder: (BuildContext context){return AlertDialog(title: Text("Rellena la descripcion"));});
                                                    }
                                                  }else{
                                                    showDialog(context: context, builder: (BuildContext context){return AlertDialog(title: Text("Rellene el nombre"));});
                                                  }
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

  @override void dispose() {
    contBarraBusqueda.dispose();
    contNomEjercicio.dispose();
    descEjercicio.dispose();
    super.dispose();
  }
}