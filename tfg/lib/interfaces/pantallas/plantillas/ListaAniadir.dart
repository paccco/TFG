import 'package:flutter/material.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/BotonContenidoBorrar.dart';
import '../../widgetsPersonalizados/BotonContenido.dart';
import '../../widgetsPersonalizados/TituloConSalida.dart';
import '../../widgetsPersonalizados/BarraNavegacion.dart';
import '../../../constantes.dart';

class ListaAniadir extends StatefulWidget{

  final String titulo;
  final Future<List<String>> Function() cargarContenido;
  final bool sePuedeBorrar;
  final void Function(BuildContext context,String nombre)? borrarElemento;
  final void Function(BuildContext context,String nombre) cargarElemento;
  final void Function(BuildContext context) aniadir;

  const ListaAniadir({super.key, required this.aniadir, required this.cargarContenido, required this.cargarElemento ,required this.titulo, this.sePuedeBorrar=false,this.borrarElemento});

  @override
  _ListaAniadirState createState() => _ListaAniadirState();
}

class _ListaAniadirState extends State<ListaAniadir>{
  final int elementosVisibles=4;
  List<String> contenido=[];
  List<Widget> visible=[];
  int index=0;

  void _setVisble(){
    visible.clear();
    int cont=0;
    if(widget.sePuedeBorrar){
      Function(BuildContext context,String nombre) borrarElemento;
      widget.borrarElemento!=null ? borrarElemento=widget.borrarElemento! : borrarElemento=(context,nombre)=> {};
      while(cont<elementosVisibles && (index+cont)<contenido.length){
        final aux=contenido[index+cont];
        visible.add(BotonContenidoBorrar(texto: aux, func: ()=> widget.cargarElemento(context,aux), borrar: (){
          borrarElemento(context,aux);
          setState(() {
            _fetchContenido();
          });
        }));
        cont++;
      }
    }else{
      while(cont<elementosVisibles && (index+cont)<contenido.length){
        final aux=contenido[index+cont];
        visible.add(BotonContenido(texto: aux, func: ()=> widget.cargarElemento(context,aux)));
        cont++;
      }
    }
  }

  void _fetchContenido() async{

    final elementosFetched = await widget.cargarContenido();

    setState(() {
      contenido=List.from(elementosFetched);
    });

    _setVisble();
  }

  void _navegar(bool value){
    if(value && (index+elementosVisibles)<contenido.length){
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
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconButton(
                          onPressed: () async {
                            widget.aniadir(context);
                            setState(() {
                              _fetchContenido();
                            });
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
}