import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/interfaces/pantallas/ListaEjercicios.dart';
import 'package:tfg/interfaces/pantallas/ListaRutinas.dart';
import 'package:tfg/interfaces/pantallas/MiPerfil.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloSimple.dart';
import '../../constantes.dart';

class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({super.key});

  @override
  MneuPrincipalState createState() => MneuPrincipalState();
}

class MneuPrincipalState extends State<MenuPrincipal>{

  Widget _hacerBoton(String texto, Function() func){
    return InkWell(
      onTap: func,
      child: Container(
        height: 7.5.h,
        width: 50.w,
        color: Colores.naranja,
        alignment: Alignment.center,
        child: Text(texto,style: TextStyle(color: Colores.blanco, fontSize: 20.sp),),
      ),
    );
  }

  void _cargarBuscarRutinas(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            backgroundColor: Colores.azulOscuro,
            title: Center(
              child: Text("¿Quieres buscar por nombre o usuario?", style: TextStyle(color: Colores.blanco),),
            ),
            content: SizedBox(
              height: 18.h,
              child: Column(
                spacing: 1.5.h,
                children: [
                  _hacerBoton("Usuario",(){
                    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BuscarRutinasUsuario()));
                  }),
                  _hacerBoton("Rutina", (){})
                ],
              ),
            ),
          );
        }
    );
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
    final tamSecciones=39.h;

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
            child: Placeholder(
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ListaRutinas()));
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