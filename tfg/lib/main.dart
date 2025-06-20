import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/interfaces/pantallas/logSing/LogSignIn.dart';
import 'package:tfg/interfaces/pantallas/MenuPrincipal.dart';
import 'constantes.dart';
import 'API.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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

  await initializeDateFormatting('es_ES');

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