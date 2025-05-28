import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tfg/ConexionBDLocal.dart';
import 'package:tfg/interfaces/pantallas/calendario/OpcionesPasado.dart';
import 'package:tfg/interfaces/pantallas/misEjercicios/ListaEjercicios.dart';
import 'package:tfg/interfaces/pantallas/misRutinas/ListaRutinas.dart';
import 'package:tfg/interfaces/pantallas/misRutinas/ListaRutinasCompartidas.dart';
import 'package:tfg/interfaces/pantallas/miPerfil/MiPerfil.dart';
import 'package:tfg/interfaces/pantallas/calendario/OpcionesDescanso.dart';
import 'package:tfg/interfaces/pantallas/calendario/OpcionesHoyFuturo.dart';
import 'package:tfg/interfaces/pantallas/plantillas/EligeEntre2.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloSimple.dart';
import '../../constantes.dart';
import 'buscarRutinas/BuscarRutinaNombre.dart';
import 'buscarRutinas/BuscarUsuario.dart';
import '../widgetsPersonalizados/Calendario.dart';

class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({super.key});

  @override
  MenuPrincipalState createState() => MenuPrincipalState();
}

class MenuPrincipalState extends State<MenuPrincipal>{

  late final DateTime _hoy;
  DateTime _selectedDay=DateTime.now();
  String _textoDiaSeleccionado="", _rutina="Sin asignar";
  late final Calendario _miCalendar=Calendario(onValueChanged: _seleccionarDia);

  @override
  void initState() {
    super.initState();
    final aux=DateTime.now();

    _hoy=DateTime(aux.year,aux.month,aux.day);
  }

  void _cambiaTextoDiaSeleccionado(){
    if(_rutina==""){
      _textoDiaSeleccionado="Descanso";
    }else{
      if(_hoy.isAfter(_selectedDay)){
        _textoDiaSeleccionado="Entrenaste $_rutina";
      }else if(isSameDay(_hoy, _selectedDay)){
        _textoDiaSeleccionado="Entrenas $_rutina";
      }else{
        _textoDiaSeleccionado="Entrenarás $_rutina";
      }
    }
  }

  void _seleccionarDia(List<dynamic> lista){
    setState(() {
      _selectedDay=lista[0];
      _rutina=lista[1];
      _cambiaTextoDiaSeleccionado();
    });
  }

  void _cargarMisRutinas(BuildContext context){

    Widget aux=EligeEntre2(
        titulo: "",
        pregunta: "¿Quieres ver tus rutinas o las que has compartido?",
        opcion1: "Mis rutinas",
        opcion2: "Compartidas",
        func1: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => ListaRutinas())),
        func2: ()async{
          final String usuario= await storage.read(key: 'usuario') ?? '';
          Navigator.push(context, MaterialPageRoute(builder: (context) => ListaRutinasCompartidas(usuario: usuario)));
        }
    );

    Navigator.push(context, MaterialPageRoute(builder: (context) => aux));
  }

  void _cargarBuscarRutinas(BuildContext context){

    Widget aux=EligeEntre2(
        titulo: "",
        pregunta: "¿Quieres buscar por nombre o usuario?",
        opcion1: "Usuario",
        opcion2: "Rutina",
        func1: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BuscarUsuario())),
        func2: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BuscarRutinaNombre()))
    );

    Navigator.push(context, MaterialPageRoute(builder: (context) => aux));
  }

  Widget _cajaElemento(String texto, Color color, String asset, void Function() func){

    double size=40.w;

    return Container(
      margin: EdgeInsets.all(1.h),
      color: color,
      width: size,
      height: size,
      child: TextButton(
          onPressed: func,
          child: Column(
            spacing: 5,
            children: [
              Text(texto, style: TextStyle(color: Colores.blanco,fontSize: 18.sp)),
              Image.asset(asset, height: size/2, width: size/2)
            ],
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    final tamSecciones=40.h;

    return Scaffold(
      backgroundColor: Colores.grisClaro,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH),
          child: TituloSimple(titulo: "Inicio")
      ),
      body: Column(
        spacing: 1.h,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: tamSecciones,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _miCalendar,
                Text(_textoDiaSeleccionado,style: TextStyle(fontSize: 20.sp)),
                InkWell(
                  onTap: () async {_cambiaTextoDiaSeleccionado();
                    //Seleccionar un dia anterior
                    if(_hoy.isAfter(_selectedDay)){
                      final marcas = await BDLocal.instance.getMarcasfecha(_selectedDay);
                      if(marcas.isNotEmpty){
                        Navigator.push(context, MaterialPageRoute(builder: (build)=>OpcionesPasado(diaSeleccionado: _selectedDay, rutina: _rutina,marcas: marcas, entrenado: true,)));
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (build)=>OpcionesPasado(diaSeleccionado: _selectedDay, rutina: _rutina,marcas: [])));
                      }
                    }else if(isSameDay(_hoy, _selectedDay)){//seleccionar dia actual
                      if(_rutina.isNotEmpty){
                        final marcas = await BDLocal.instance.getMarcasfecha(_selectedDay);
                        if(marcas.isNotEmpty){
                          Navigator.push(context, MaterialPageRoute(builder: (build)=>OpcionesPasado(diaSeleccionado: _selectedDay, rutina: _rutina,marcas: marcas, entrenado: true,)));
                        }else{
                          await Navigator.push(context, MaterialPageRoute(builder: (context) => OpcionesHoyFuturo(diaSeleccionado: _selectedDay, rutina: _rutina)));
                        }
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (build)=>OpcionesDescanso(fecha: _selectedDay)));
                      }
                    }else{
                      if(_rutina.isNotEmpty){
                        Navigator.push(context, MaterialPageRoute(builder: (build)=>OpcionesHoyFuturo(diaSeleccionado: _selectedDay, rutina: _rutina)));
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (build)=>OpcionesDescanso(fecha: _selectedDay)));
                      }
                    }

                    setState(() {
                      _textoDiaSeleccionado="";
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(2.h),
                    alignment: Alignment.center,
                    color: Colores.naranja,
                    height: 7.5.h,
                    child: Text("Informacion",style: TextStyle(fontSize: 22.5.sp, color: Colores.blanco)),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: tamSecciones,
            child: Wrap(
              children: [
                _cajaElemento("Mis Ejercicios", Colores.azul, 'assets/images/ejercicio.png' ,(){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ListaEjercicios()));
                }),
                _cajaElemento("Mi perfil", Colores.azul, 'assets/images/user.png', () async {
                  final String aux=await storage.read(key: 'usuario') ?? '';
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MiPerfil(usuario: aux)));
                }),
                _cajaElemento("Mis Rutinas", Colores.azul, 'assets/images/rutina.png',(){
                  _cargarMisRutinas(context);
                }),
                _cajaElemento("Buscar rutinas", Colores.azul, 'assets/images/red.png',(){
                  _cargarBuscarRutinas(context);
                })
              ],
            )
          )
        ],
      ),
    );
  }
}