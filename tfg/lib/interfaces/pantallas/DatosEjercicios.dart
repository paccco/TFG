import 'package:flutter/material.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloSalidaBorrar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../ConexionBDLocal.dart';
import '../constantes.dart';

class DatosEjercicios extends StatelessWidget{

  final String titulo;

  const DatosEjercicios ({super.key, required this.titulo});

  Future<Widget> _fetchInfo() async{
    final datosEjercicio = await BDLocal.instance.getEjercicio(titulo);

    int tipoInt = datosEjercicio['tipo'];
    String tipo = tipoInt.toRadixString(2).padLeft(8,'0');
    
    
    final datosMarca = await BDLocal.instance.getMarcaActual(titulo);
    final datosMeta = await BDLocal.instance.getMetaActual(titulo);

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH),
          child: TituloConSalidaBorrar(titulo: titulo)
      ),
      body: DataTable(
        columnSpacing: 6.w,
        dataRowMinHeight: 10.h,
        dataRowMaxHeight: 15.h,
        columns: [
          DataColumn(label: Text(''), columnWidth: FixedColumnWidth(28.w)),
          DataColumn(label: Text('Marca actual')),
          DataColumn(label: Text('Meta')),
          DataColumn(label: Text('')),
        ],
        rows: _construyeTabla(tipo,datosMeta,datosMarca),
      ),
      bottomNavigationBar: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        children: [
          _hacerBoton("Hacer grafica", (){}),
          _hacerBoton("Descripcion", (){}),
          _hacerBoton("Nueva meta", (){})
        ],
      ),
    );

  }

  List<DataRow> _construyeTabla(String tipo, Map<String,dynamic> meta,Map<String,dynamic> marca){

    List<DataRow> out=List.empty(growable: true);

    if(tipo[0]=='1'){
      out.add(
        DataRow(cells: _construyeFila('REPETICIONES',marca['repeticiones'], meta['repeticiones'])),
      );
    }
    if(tipo[1]=='1'){

      String marcaT=marca['tiempo'],metaT=meta['tiempo'];
      String tiempos="$marcaT|$metaT";

      out.add(
        DataRow(cells: _construyeFila('TIEMPO',time2Int(marcaT),time2Int(metaT),esTiempo: tiempos))
      );
    }
    if(tipo[2]=='1'){
      out.add(
        DataRow(cells: _construyeFila('PESO',marca['peso'], meta['peso'],esDouble: true))
      );
    }if(tipo[3]=='1'){
      String aux="";

      if(tipo[4]=='1'){
        aux="KM";
      }else{
        aux="M";
      }

      out.add(
        DataRow(cells: _construyeFila('DISTANCIA',marca['distancia'], meta['distancia'],unidades: aux,esDouble: true)),
      );
    }


    return out;
  }

  int time2Int(String value){
    final List<String> aux = value.split(':');
    int res=0;

    res+=int.parse(aux[0])*24;
    res+=int.parse(aux[1])*60;
    res+=int.parse(aux[2])*60;

    return res;
  }

  List<DataCell> _construyeFila(String nombre, int marca, int meta,{bool esDouble=false, String esTiempo = '', String unidades=''}){
    List<DataCell> out=List.empty(growable: true);

    if(esDouble){
      double auxMarca=marca/100,
              auxMeta=meta/100;

      out.addAll([
        DataCell(Text(nombre)),
        DataCell(Text("$auxMarca")),
        DataCell(Text("$auxMeta"))
      ]);
    }else if(esTiempo.isNotEmpty){
      List<String> aux=esTiempo.split('|');

      out.addAll([
        DataCell(Text(nombre)),
        DataCell(Text(aux[0])),
        DataCell(Text(aux[1]))
      ]);
    } else if(unidades.isNotEmpty){
      out.addAll([
        DataCell(Text(nombre)),
        DataCell(Text("$marca $unidades")),
        DataCell(Text("$meta $unidades"))
      ]);
    } else{
      out.addAll([
        DataCell(Text(nombre)),
        DataCell(Text("$marca")),
        DataCell(Text("$meta"))
      ]);
    }

    double tamIconos=7.w;

    if(marca>=meta){
      out.add(DataCell(Image.asset('assets/images/check.png',width: tamIconos,height: tamIconos)));
    } else {
      out.add(DataCell(Image.asset('assets/images/forbidden.png',width: tamIconos,height: tamIconos)));
    }
    
    return out;
  }

  Widget _hacerBoton(String texto,void Function() onPres){

    final TextStyle estiloBotones=TextStyle(color: Colores.blanco,fontSize: 21.sp);

    return Container(
        width: 28.w,
        color: Colores.naranja,
        child: TextButton(
            onPressed: onPres,
            child: Text(texto,style: estiloBotones)
        )
    );
  }

  @override
  Widget build(BuildContext context){
    return FutureBuilder(
        future: _fetchInfo(),
        builder: (context,snapshot){
          if(snapshot.hasError){
            return Scaffold(
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(Tamanios.appBarH),
                  child: TituloConSalidaBorrar(titulo: titulo)
              ),
              body: Center(child: Text("ERROR : ${snapshot.error}")),
            );
          }else if(snapshot.hasData){
            return snapshot.data!;
          }else {
            return Scaffold(
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(Tamanios.appBarH),
                  child: TituloConSalidaBorrar(titulo: titulo)
              ),
              body: Center(child: Text("No hay datos disponibles")),
            );
          }

          return CircularProgressIndicator();
        });
  }
}