import 'package:flutter/material.dart';

void mensajeError(BuildContext context, String correccion){
  showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Error de formato: $correccion"),
        );
      }
  );
}