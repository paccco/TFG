import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ModificarDescrEjercicio.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloSalidaBorrar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../ConexionBDLocal.dart';
import '../../../constantes.dart';
import 'NuevaMetaEjercicio.dart';
import '../plantillas/Grafica.dart';

class DatosEjercicios extends StatelessWidget{

  final String titulo;

  const DatosEjercicios ({super.key, required this.titulo});

  Future<Widget> _fetchInfo(context) async{
    final datosEjercicio = await BDLocal.instance.getEjercicio(titulo);

    int tipoInt = datosEjercicio['tipo'];
    String tipo = tipoInt.toRadixString(2).padLeft(8,'0');
    TextEditingController controller=TextEditingController();
    controller.text=datosEjercicio['descripcion'];
    
    final datosMarca = await BDLocal.instance.getMarcaActual(titulo);
    final datosMeta = await BDLocal.instance.getMetaActual(titulo);

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH),
          child: TituloConSalidaBorrar(titulo: titulo)
      ),
      body: DataTable(
        dataRowMinHeight: 10.h,
        dataRowMaxHeight: 15.h,
        columns: [
          DataColumn(label: Text(''), columnWidth: FixedColumnWidth(28.w)),
          DataColumn(label: Text('Marca \n actual')),
          DataColumn(label: Text('Meta')),
          DataColumn(label: Text('')),
        ],
        rows: _construyeTabla(tipo,datosMeta,datosMarca),
      ),
      bottomNavigationBar: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _hacerBoton("Hacer grafica", ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>Grafica(ejercicio: titulo, fetchContenido: BDLocal.instance.getMediaMarca)))),
          Spacer(),
          _hacerBoton("Descripcion", ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ModificarDescrEjercicio(titulo: titulo)))),
          Spacer(),
          _hacerBoton("Nueva meta", () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context)=>NuevaMetaEjercicio(titulo: titulo,repeticiones: tipo[0]=='1',peso: tipo[1]=='1',tiempo: tipo[2]=='1',distancia: tipo[3]=='1'))
            );
          })
        ],
      ),
    );

  }

  Widget _hacerBoton(String texto,void Function() onPres){

    final TextStyle estiloBotones=TextStyle(color: Colores.blanco,fontSize: 21.sp);

    return Container(
        width: 30.w,
        color: Colores.naranja,
        child: TextButton(
            onPressed: onPres,
            child: Text(texto,style: estiloBotones)
        )
    );
  }

  List<DataRow> _construyeTabla(String tipo, Map<String,dynamic> meta,Map<String,dynamic> marca){

    final camposMarca=BDLocal.camposMarca;
    final repeticiones=camposMarca[2],
          peso=camposMarca[3],
          tiempo=camposMarca[4],
          distancia=camposMarca[5];
    List<DataRow> out=List.empty(growable: true);


    if(tipo[0]=='1'){
      out.add(
        DataRow(cells: _construyeFila('REPETICIONES',marca[repeticiones], meta[repeticiones])),
      );
    }
    if(tipo[1]=='1'){
      out.add(
        DataRow(cells: _construyeFila('PESO',marca[peso], meta[peso]))
      );
    }
    if(tipo[2]=='1'){
      String marcaT=marca[tiempo],metaT=meta[tiempo];
      String tiempos="$marcaT|$metaT";

      out.add(
          DataRow(cells: _construyeFila('TIEMPO',_time2Int(marcaT),_time2Int(metaT),esTiempo: tiempos))
      );
    }
    if(tipo[3]=='1'){
      String aux="";

      if(tipo[4]=='1'){
        aux="KM";
      }else{
        aux="M";
      }

      out.add(
        DataRow(cells: _construyeFila('DISTANCIA',marca[distancia], meta[distancia],unidades: aux)),
      );
    }


    return out;
  }

  int _time2Int(String value){
    final List<String> aux = value.split(':');
    int res=0;

    res+=int.parse(aux[0])*60;
    res+=int.parse(aux[1])*60;

    return res;
  }

  List<DataCell> _construyeFila(String nombre, int marca, int meta,{String esTiempo = '', String unidades=''}){
    List<DataCell> out=List.empty(growable: true);



    if(esTiempo.isNotEmpty){
      List<String> aux=esTiempo.split('|');

      out.addAll([
        DataCell(Text(nombre)),
        DataCell(Text(aux[0])),
        DataCell(Text(aux[1]))
      ]);
    } else{
      final auxMarca=marca/100,
          auxMeta=meta/100;
      
      if(unidades.isNotEmpty){
        out.addAll([
          DataCell(Text(nombre)),
          DataCell(Text("$auxMarca $unidades")),
          DataCell(Text("$auxMeta $unidades"))
        ]);
      }else{
        out.addAll([
          DataCell(Text(nombre)),
          DataCell(Text("$auxMarca")),
          DataCell(Text("$auxMeta"))
        ]);
      }
    }

    double tamIconos=7.w;

    if((marca>=meta) ){
      out.add(DataCell(Image.asset('assets/images/check.png',width: tamIconos,height: tamIconos)));
    } else {
      out.add(DataCell(Image.asset('assets/images/forbidden.png',width: tamIconos,height: tamIconos)));
    }
    
    return out;
  }

  @override
  Widget build(BuildContext context){

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);

    return FutureBuilder(
        future: _fetchInfo(context),
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
            return CircularProgressIndicator();
          }
        });
  }
}