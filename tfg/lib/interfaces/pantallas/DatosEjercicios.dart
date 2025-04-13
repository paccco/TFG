import 'package:flutter/material.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/BarraTexto.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloSalidaBorrar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../ConexionBDLocal.dart';
import '../constantes.dart';
import '../PopUps/DialogosError.dart';

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
        children: [
          _hacerBoton("Hacer grafica", (){}),
          Spacer(),
          _hacerBoton("Descripcion", (){
            showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    backgroundColor: Colores.azulOscuro,
                    content: BarraTexto(controller: controller,maxLineas: 5,),
                    actions: [_hacerBoton("Guardar", () async{
                        await BDLocal.instance.modDescripcionEjer(controller.value.text, titulo);
                    })],
                  );
                });
          }),
          Spacer(),
          _hacerBoton("Nueva meta", () {

            TextEditingController rpc,tc,psc,dtc;
            List<Widget> miWrap=List.empty(growable: true);

            rpc=TextEditingController();
            tc=TextEditingController();
            psc=TextEditingController();
            dtc=TextEditingController();

            if(tipo[0]=='1'){
              miWrap.add(
                _nuevaMetaNum(rpc, "REPETICIONES")
              );
            }
            if(tipo[1]=='1'){
              miWrap.add(
                  _nuevaMetaNum(tc, "TIEMPO",tiempo: true)
              );
            }
            if(tipo[2]=='1'){
              miWrap.add(
                  _nuevaMetaNum(psc, "PESO", decimal: true)
              );
            }if(tipo[3]=='1'){
              miWrap.add(
                  _nuevaMetaNum(dtc, "DISTANCIA", decimal: true)
              );
            }

            showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    title: Text("Nueva meta",style: TextStyle(fontSize: Tamanios.fuenteTitulo,color: Colores.blanco),),
                    backgroundColor: Colores.azulOscuro,
                    content: Column(
                        spacing: 5,
                        mainAxisSize: MainAxisSize.min,
                        children: miWrap
                      ),
                    actions: [
                      _hacerBoton("Guardar", () async {
                        Map<String,dynamic> aux={};

                        if(tipo[0]=='1' && rpc.value.text.isNotEmpty){
                          try{
                            aux['repeticiones']=int.parse(rpc.value.text);
                          }catch(exception){
                            mensajeError(context, "Repeticiones: Usa un numero positivo sin comas");
                          }
                        }
                        if(tipo[1]=='1' && tc.value.text.isNotEmpty){
                          final horaVal = tc.value.text;
                          if(_validarFormatoHora(horaVal)) {
                            aux['tiempo'] = horaVal;
                          }else{
                            aux['tiempo'] = false;
                          }
                        }
                        if(tipo[2]=='1' && psc.value.text.isNotEmpty){
                          try{
                            aux['peso']=double.parse(psc.value.text);
                          }catch(exception){
                            mensajeError(context, "Peso: Usa un numero con punto");
                          }
                        }
                        if(tipo[3]=='1' && dtc.value.text.isNotEmpty){
                         try{
                           aux['distancia']=double.parse(dtc.value.text);
                         }catch(execption){
                           mensajeError(context, "Distancia: Usa un numero con punto");
                         }
                        }

                        if(aux.values.contains(false)){
                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(title: Text("Formato de hora incorrecto: hh:mm:ss"),);
                              }
                          );
                        } else if(aux.isNotEmpty){
                          await BDLocal.instance.modMeta(titulo,aux);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }else{
                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(title: Text("Rellena los campos"),);
                              }
                          );
                        }
                      })
                    ],
                  );
                }
            );
          })
        ],
      ),
    );

  }

  bool _validarFormatoHora(String hora) {
    final regexHora = RegExp(r'^\d{2}:\d{2}:\d{2}$');
    if (!regexHora.hasMatch(hora)) {
      return false;
    }

    final partes = hora.split(':');
    final horas = int.parse(partes[0]);
    final minutos = int.parse(partes[1]);
    final segundos = int.parse(partes[2]);

    return horas >= 0 && horas <= 23 &&
        minutos >= 0 && minutos <= 59 &&
        segundos >= 0 && segundos <= 59;
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

  Widget _nuevaMetaNum(TextEditingController controller, String label,{bool decimal=false, bool tiempo=false}){
    TextInputType aux;

    if(tiempo){
      aux=TextInputType.datetime;
    }else{
      aux=TextInputType.numberWithOptions(decimal: decimal);
    }

    return TextFormField(
      keyboardType: aux,
      decoration: InputDecoration(
        filled: true, 
          fillColor: Colores.azul,
        labelText: label
      ),
      controller: controller,
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
        DataRow(cells: _construyeFila('TIEMPO',_time2Int(marcaT),_time2Int(metaT),esTiempo: tiempos))
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

  int _time2Int(String value){
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

  @override
  Widget build(BuildContext context){
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