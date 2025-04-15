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


class AniadirEjerRutina extends StatefulWidget {
  const AniadirEjerRutina({super.key});

  @override
  AniadirEjerRutinaState createState() => AniadirEjerRutinaState();
}

class AniadirEjerRutinaState extends State<AniadirEjerRutina>{

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
      visible.add(Botonejercicios(texto: aux, func: ()=>Navigator.pop(context,aux)));
      cont++;
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
      visible.add(Botonejercicios(texto: aux,func: () => Navigator.pop(context,aux)));
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

    final BarraNavegacion barraNav=BarraNavegacion(navegar: _navegar);

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