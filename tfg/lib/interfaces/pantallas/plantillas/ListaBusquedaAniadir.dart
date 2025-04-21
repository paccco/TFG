import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/BarraNavegacion.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/BotonContenido.dart';
import '../../widgetsPersonalizados/BarraTexto.dart';
import '../../widgetsPersonalizados/TituloConSalida.dart';
import '../../../constantes.dart';


class ListaBusquedaAniadir extends StatefulWidget {

  final String titulo;
  final Future<List<String>> Function() cargarContenido;
  final void Function(BuildContext context,String nombre) cargarElemento;
  final Future<void> Function(BuildContext context) aniadir;
  
  const ListaBusquedaAniadir({super.key, required this.aniadir, required this.cargarContenido, required this.cargarElemento ,required this.titulo});

  @override
  _ListaBusquedaAniadirState createState() => _ListaBusquedaAniadirState();
}

class _ListaBusquedaAniadirState extends State<ListaBusquedaAniadir>{

  final int elementosVisibles=4;
  List<String> contenido=[];
  List<String> filtrados=[];
  List<Widget> visible=[];
  int index=0;

  void _setVisble(){
    visible.clear();
    int cont=0;
    while(cont<elementosVisibles && (index+cont)<filtrados.length){
      final aux=filtrados[index+cont];
      visible.add(BotonContenido(texto: aux, func: ()=> widget.cargarElemento(context,aux)));
      cont++;
    }
  }

  void _fetchContenido() async{

    final elementosFetched = await widget.cargarContenido();

    contenido=List.from(elementosFetched);

    filtrados=List.from(contenido);

    _setVisble();

    setState(() {});
  }

  void _filtrar(String query){
    filtrados = contenido.where((elemento) {
      return elemento.toLowerCase().contains(query.toLowerCase());
    }).toList();

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
    _fetchContenido();
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
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconButton(
                          onPressed: (){
                            widget.aniadir(context);
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