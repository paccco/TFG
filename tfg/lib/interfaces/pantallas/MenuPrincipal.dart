import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/interfaces/pantallas/ListaEjercicios.dart';
import 'package:tfg/interfaces/pantallas/ListaRutinas.dart';
import 'package:tfg/interfaces/pantallas/ListaRutinasCompartidas.dart';
import 'package:tfg/interfaces/pantallas/MiPerfil.dart';
import 'package:tfg/interfaces/pantallas/plantillas/EligeEntre2.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloSimple.dart';
import '../../constantes.dart';
import './BuscarRutinaNombre.dart';
import 'BuscarUsuario.dart';
import '../widgetsPersonalizados/Calendario.dart';

class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({super.key});

  @override
  MneuPrincipalState createState() => MneuPrincipalState();
}

class MneuPrincipalState extends State<MenuPrincipal>{

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
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: tamSecciones,
            child: Calendario(),
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