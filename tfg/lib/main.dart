import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/interfaces/pantallas/ListaAniadir.dart';

void main() {
  runApp(
      ResponsiveSizer(
        builder: (context, orientation, screenType) {
          return MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.blue,
              // Puedes personalizar más el tema aquí
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home:  ListaAniadir(),
          );
        },
      )
  );
}