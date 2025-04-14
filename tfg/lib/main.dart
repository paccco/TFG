import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/interfaces/pantallas/LogSignIn.dart';
import 'package:tfg/interfaces/pantallas/MenuPrinciapal.dart';
import 'constantes.dart';
import 'ConexionBDRemota.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  Widget aux=LogSignIn();
  bool tengoToken=await storage.containsKey(key: 'token');

  if(tengoToken){
    String token=await storage.read(key: 'token') ?? '';
    final res = await verificar(token);
    print(res);
    if(res){
      aux=MenuPrincipal();
    }
  }

  runApp(
      ResponsiveSizer(
        builder: (context, orientation, screenType) {
          return MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home:  aux,
          );
        },
      )
  );
}