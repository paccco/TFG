import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/ConexionBDLocal.dart';
import 'package:tfg/constantes.dart';
import '../../funcionesAux.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/BarraTexto.dart';

import '../widgetsPersonalizados/TituloConSalida.dart';

DataColumn _columna(String texto){
  return DataColumn(label: Text(texto,style: TextStyle(color: Colores.negro)));
}

DataCell _celda(String? texto){
  return DataCell(
    Center(
        child: Text(texto ?? "No disponible",style: TextStyle(color: Colores.negro))
    )
  );
}

Future<Widget> _tablaDatos(BuildContext context) async{

  final consulta = await Future.wait([
    storage.read(key: 'altura'),
    storage.read(key: 'fechaN'),
    storage.read(key: 'genero')
  ]);

  final int pesoActual=await BDLocal.instance.getPesoActual();
  int pesoObj=await BDLocal.instance.getPesoObjetivo();
  final TextEditingController pesoObjC=TextEditingController();

  return Container(
    margin: EdgeInsets.all(2.h),
    child: Column(
        spacing: 15,
        children: [
          DataTable(
              columns: [
                _columna(""),
                _columna("Valor")
              ],
              rows: [
                DataRow(cells: [_celda("Peso"),_celda("${pesoActual/100}")]),
                DataRow(cells: [_celda("Altura"),_celda(consulta[0])]),
                DataRow(cells: [_celda("Fecha nacimiento"),_celda(consulta[1])]),
                DataRow(cells: [_celda("Género"),_celda(consulta[2])])
              ]
          ),
          Text("Peso objetivo: ${pesoObj==0 ? "No establecido":"${pesoObj.abs()/10} kg"}", style: TextStyle(fontSize: 18.sp)),
          BarraTexto(controller: pesoObjC,tipoInput: TextInputType.numberWithOptions(decimal: true)),
          TextButton(
            onPressed: (){
              final String pesoStr=pesoObjC.value.text;

              if(regexPeso.hasMatch(pesoStr)){
                BDLocal.instance.insertMetaPeso(pesoStr,pesoActual);
                Navigator.pop(context);
              }else{
                mensaje(context, "Numero positivo con un decimal máximo", error: true);
              }
            },
            child: Container(
              height: 8.h,
              width: 60.w,
              color: Colores.naranja,
              child: Center(
                child: Text("Establecer objetivo",style: TextStyle(color: Colores.blanco,fontSize: 18.sp)),
              ),
            ),
          ),
        ]
    ),
  );
}

class DatosUsuario extends StatelessWidget{
  const DatosUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colores.grisClaro,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH),
          child: TituloConSalida(titulo: "Mis datos")
      ),
      body: FutureBuilder(
          future: _tablaDatos(context),
          builder: (context,snapshot){
            if(snapshot.hasError){
              return Text("Error, intenta volver a cargar la página, ${snapshot.error}");
            }else if(snapshot.hasData){
              return Center(
                child: snapshot.data!,
              );
            }
            return CircularProgressIndicator();
          }
      ),
    );
  }
}