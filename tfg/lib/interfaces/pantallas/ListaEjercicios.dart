import 'package:flutter/material.dart';
import 'package:tfg/interfaces/pantallas/plantillas/ListaBusquedaAniadir.dart';
import './DatosEjercicios.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../widgetsPersonalizados/BarraTexto.dart';
import '../widgetsPersonalizados/BotonBool.dart';
import '../../constantes.dart';
import '../../ConexionBDLocal.dart';

class ListaEjercicios extends StatefulWidget{
  const ListaEjercicios({super.key});

  @override
  ListaEjerciciosState createState()=> ListaEjerciciosState();
}

class ListaEjerciciosState extends State<ListaEjercicios>{

  Future<void> _aniadir(BuildContext context) async{
    final TextEditingController contNomEjercicio = TextEditingController();
    final TextEditingController descEjercicio = TextEditingController();

    final BarraTexto barraNombreEjer=BarraTexto(controller: contNomEjercicio, textoHint: "Nombre");
    final BarraTexto barraDesc=BarraTexto(controller: descEjercicio, textoHint: "Descripcion");

    bool repeticiones, peso, tiempo, distancia;
    repeticiones=peso=tiempo=distancia=false;

    BotonBool repBot=BotonBool(miBool: repeticiones, texto: "Repeticiones", cambio: (value) {repeticiones=value;});
    BotonBool pesoBot=BotonBool(miBool: peso, texto: "Peso", cambio: (value){peso=value;});
    BotonBool tiemBot=BotonBool(miBool: tiempo, texto: "Tiempo", cambio: (value){tiempo=value;});
    BotonBool distBot=BotonBool(miBool: distancia, texto: "Distancia", cambio: (value){distancia=value;});

    await showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            backgroundColor: Colores.azulOscuro,
            title: Center(
              child: Text("Añadir ejercicios",style: TextStyle(color: Colores.blanco)),
            ),
            content: Container(
              height: 45.h,
              color: Colores.grisClaro,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(padding: EdgeInsets.all(5),child: Text("Nombre",style: TextStyle(fontSize: Tamanios.fuentePopUp))),
                  Container(padding: EdgeInsets.all(5),child: barraNombreEjer),
                  Container(padding: EdgeInsets.all(5), child: Text("Parámetros", style: TextStyle(fontSize: Tamanios.fuentePopUp))),
                  Expanded(child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      repBot,pesoBot,tiemBot,distBot
                    ],
                  )),
                  Padding(padding: EdgeInsets.all(5),child: barraDesc),
                  FilledButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colores.naranja)
                      ),
                      onPressed: (){
                        int codTipo;
                        String desc, nombre;

                        if(contNomEjercicio.value.text.isNotEmpty){
                          nombre=contNomEjercicio.value.text;
                          if(descEjercicio.value.text.isNotEmpty){
                            desc=descEjercicio.value.text;
                            if(repeticiones || tiempo || distancia || peso){
                              String byte="";

                              byte += (repeticiones ? '1' : '0');
                              byte += (peso ? '1' : '0');
                              byte += (tiempo ? '1' : '0');
                              byte += (distancia ? '1' : '0');
                              byte += '0000';

                              codTipo=int.parse(byte,radix: 2);

                              Map<String,dynamic> datos={
                                BDLocal.instance.camposEjercicios[0] :  nombre,
                                BDLocal.instance.camposEjercicios[1] :  codTipo,
                                BDLocal.instance.camposEjercicios[2] :  desc
                              };

                              BDLocal.instance.insertEjercicios(datos).then((value){
                                if(value<0){
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context){
                                        return AlertDialog(
                                          title: Text("Fallo al guardar ejercicio"),
                                        );
                                      }
                                  );
                                }
                              });
                              Navigator.pop(context);
                            }else{
                              showDialog(context: context, builder: (BuildContext context){return AlertDialog(title: Text("Rellene el campo tipo "));});
                            }
                          }else{
                            showDialog(context: context, builder: (BuildContext context){return AlertDialog(title: Text("Rellena la descripcion"));});
                          }
                        }else{
                          showDialog(context: context, builder: (BuildContext context){return AlertDialog(title: Text("Rellene el nombre"));});
                        }
                      },
                      child: Text("Guardar")
                  )
                ],
              ),
            ),
          );
        }
    );
  }

  Future<List<String>> _fetchEjercicios() async{
    return await BDLocal.instance.getNombreEjercicios();
  }

  void _cargarEjercicio(BuildContext context,String nombre)async{
    final res = await Navigator.push(context, MaterialPageRoute(builder: (context)=>DatosEjercicios(titulo: nombre)));

    if(res=='SI'){
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ListaEjercicios()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListaBusquedaAniadir(
        aniadir: _aniadir,
        cargarContenido: _fetchEjercicios,
        cargarElemento: _cargarEjercicio,
        titulo: "Mis ejercicios"
    );
  }
}