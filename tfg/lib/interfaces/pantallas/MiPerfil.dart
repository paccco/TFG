import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/interfaces/pantallas/DatosUsuario.dart';
import 'package:tfg/interfaces/pantallas/LogSignIn.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloConSalida.dart';

class MiPerfil extends StatelessWidget{
  final String usuario;

  const MiPerfil({super.key, required this.usuario});

  void _cerrarSesion(BuildContext context){
    storage.delete(key: 'token');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LogSignIn()),
          (route) => false,
    );
  }

  void _verMisDatos(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>DatosUsuario()));
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
            _boton("Cerrar sesion", () => _cerrarSesion(context)),
            _boton("Mis datos", () => _verMisDatos(context))
          ],
        ),
      ),
    );
  }
}