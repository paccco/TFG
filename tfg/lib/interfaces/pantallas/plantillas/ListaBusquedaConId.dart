import 'package:flutter/material.dart';
import '../../../constantes.dart';
import '../../widgetsPersonalizados/BotonContenido.dart';
import '../../widgetsPersonalizados/BarraTexto.dart';
import '../../widgetsPersonalizados/TituloConSalida.dart';
import '../../widgetsPersonalizados/BarraNavegacion.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ListaBusquedaConId extends StatefulWidget{
  final String titulo;
  final Future<Map<int,String>> Function() cargarContenido;
  final void Function(BuildContext context,String nombre,int id) cargarElemento;

  const ListaBusquedaConId({super.key, required this.titulo, required this.cargarContenido, required this.cargarElemento});

  @override
  _ListaBusquedaConIdState createState() => _ListaBusquedaConIdState();
}

class _ListaBusquedaConIdState extends State<ListaBusquedaConId>{
  final int elementosVisibles=4;
  Map<int,String> contenido={};
  Map<int,String> filtrados={};
  List<Widget> visible=[];
  int index=0;

  void _setVisble(){
    visible.clear();
    int cont=0;
    final filtradosComoLista=filtrados.values.toList();
    final idsComoLista=filtrados.keys.toList();

    while(cont<elementosVisibles && (index+cont)<filtrados.length){
      final nombre=filtradosComoLista[index+cont];
      final id=idsComoLista[index+cont];
      visible.add(BotonContenido(texto: nombre, func: ()=> widget.cargarElemento(context,nombre,id)));
      cont++;
    }
  }

  void _fetchContenido() async{

    final elementosFetched = await widget.cargarContenido();

    contenido=Map.from(elementosFetched);

    filtrados=Map.from(contenido);
    index=0;

    _setVisble();
    setState(() {});
  }

  void _filtrar(String query){
    filtrados=Map.from(contenido)..removeWhere((key,value){
      return !value.toLowerCase().contains(query.toLowerCase());
    });

    index=0;
    _setVisble();
    setState(() {});
  }

  void _navegar(bool value){
    if(value && (index+elementosVisibles)<filtrados.length){
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
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(Tamanios.appBarH),
            child: TituloConSalida(titulo: widget.titulo)
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
    super.dispose();
  }
}