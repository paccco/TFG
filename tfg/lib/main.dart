import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/interfaces/pantallas/LogSignIn.dart';
import 'package:tfg/interfaces/pantallas/MenuPrincipal.dart';
import 'constantes.dart';
import 'API.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  Widget aux=LogSignIn();
  bool tengoToken=await storage.containsKey(key: 'token');

  if(tengoToken){
    final res = await verificar();
    print(res);
    if(res){
      aux=MenuPrincipal();
    }
  }else{
    storage.deleteAll();
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