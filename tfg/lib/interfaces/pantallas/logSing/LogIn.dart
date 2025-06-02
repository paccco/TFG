import 'package:flutter/material.dart';
import 'package:tfg/ConexionBDLocal.dart';
import '../../../funcionesAux.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/interfaces/pantallas/MenuPrincipal.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/BarraTexto.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloConSalida.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../API.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login>{

  final TextEditingController nomC=TextEditingController(), passC=TextEditingController();

  Future<bool> _esUnUsuarioEliminado(String usuario) async {
    //Si existe una bdlocal del usuario pero no en el server, es un usuario eliminado
    final existeEnElserver = await existeUser(usuario);
    final exieteSuBDLocal = await BDLocal.instance.existeBD(usuario);

    print("servidor: $existeEnElserver , local: $exieteSuBDLocal");

    if(exieteSuBDLocal && existeEnElserver==1){
      return true;
    }else{
      return false;
    }
  }

  @override
  Widget build(BuildContext context){
    final TextStyle estiloTexto=TextStyle(color: Colores.negro,fontSize: 25.sp);

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH),
          child: TituloConSalida(titulo: "EjercictaTec")
      ),
      body: Container(
        margin: EdgeInsets.all(5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 40,
          children: [
            Text("Nombre",style: estiloTexto,),
            BarraTexto(controller: nomC),
            Text("Contraseña", style: estiloTexto),
            BarraTexto(controller: passC,),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colores.azul,
        child: TextButton(
            onPressed: () async {
              final nombre = nomC.value.text;
              final passwd = passC.value.text;

              if(nombre.isNotEmpty && passwd.isNotEmpty){

                if(await _esUnUsuarioEliminado(nombre)){
                  await BDLocal.instance.borrarBDuserEliminado(nombre);
                  mensaje(context, "Se elmino la BD de un usuario borrado recientemente", error: false);
                  return;
                }

                final res = await login(nombre, passwd);
                if(res){
                  storage.write(key: 'usuario', value: nombre);
                  await BDLocal.instance.database;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MenuPrincipal()),
                        (route) => false,
                  );
                }else{
                  mensaje(context, "Credenciales incorrectos", error: true);
                }
              }else{
                mensaje(context, "Rellena los campos", error: true);
              }
            },
            child: Text("Iniciar sesion",style: TextStyle(color: Colores.blanco,fontSize: 31.sp),)
        ),
      ),
      
    );
  }
}