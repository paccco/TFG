import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/API.dart';
import 'package:tfg/ConexionBDLocal.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/interfaces/pantallas/miPerfil/DatosUsuario.dart';
import 'package:tfg/interfaces/pantallas/logSing/LogSignIn.dart';
import 'package:tfg/interfaces/pantallas/plantillas/EligeEntre2.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloConSalida.dart';

class MiPerfil extends StatelessWidget{
  final String usuario;

  const MiPerfil({super.key, required this.usuario});

  void _cerrarSesion(BuildContext context){
    storage.deleteAll();
    BDLocal.instance.cerrarBD();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LogSignIn()),
          (route) => false,
    );
  }

  Widget _boton(String texto, void Function() func){
    return Container(
      margin: EdgeInsets.all(20),
      color: Colores.naranja,
      child: TextButton(
          onPressed: func,
          child: Text(texto,style: TextStyle(color: Colores.blanco,fontSize: 20.sp))
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final EligeEntre2 cerrarSesion = EligeEntre2(
        titulo: "Cerrar sesión",
        pregunta: "¿Estas seguro de que quieres cerrar sesión?",
        opcion1: "SI",
        opcion2: "NO",
        func1: () => _cerrarSesion(context),
        func2: () => Navigator.pop(context)
    ),
    borrar_Cuenta = EligeEntre2(
        titulo: "Borrar Cuenta",
        pregunta: "¿Estas seguro de que quieres borrar tu cuenta?",
        opcion1: "SI",
        opcion2: "NO",
        func1: () async{

          final int resnNube = await borrarCuenta();
          final int resLocal = await BDLocal.instance.deleteDataBase();

          if(resnNube>=0 && resLocal>=0){
            await storage.deleteAll();
            BDLocal.instance.cerrarBD();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LogSignIn()),
                  (route) => false,
            );
          }
        },
        func2: ()=>Navigator.pop(context)
    );



    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH),
          child: TituloConSalida(titulo: "Mi perfil")
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colores.grisClaro,
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              alignment: Alignment.center,
              child: Text("Usuario: $usuario",style: TextStyle(color: Colores.negro,fontSize: 24.sp),),
            ),
            _boton("Cerrar sesion", () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>cerrarSesion))),
            _boton("Borrar Cuenta", ()=>Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>borrar_Cuenta))),
            _boton("Mis datos", () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>DatosUsuario())))
          ],
        ),
      ),
    );
  }
}