import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/interfaces/pantallas/calendario/OpcionesPeso.dart';
import '../../widgetsPersonalizados/TituloConSalida.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OpcionesDia extends StatefulWidget{

  final Widget hijosSuperior, hijosInferior;
  final DateTime fechaTitulo;
  final bool hideDatos;

  const OpcionesDia({super.key, required this.hijosSuperior, required this.hijosInferior, required this.fechaTitulo, this.hideDatos=false});

  @override
  _OpcionesDiaState createState() => _OpcionesDiaState();
}

class _OpcionesDiaState extends State<OpcionesDia>{

  final alturaCaja=35.h;

  late String diaActual;

  @override
  void initState() {
    super.initState();

    final aux=widget.fechaTitulo;
    final mes=meses[aux.month-1];

    diaActual="${aux.day} de $mes del ${aux.year}";
  }

  Widget _hacerCaja(Widget hijo){
    return Container(
      alignment: Alignment.center,
      height: alturaCaja,
      child: hijo,
    );   
  }
  
  @override
  Widget build(BuildContext context) {

    final aux = widget.hideDatos ? SizedBox(
      height: 10.h,
    ) :
    Container(
      color: Colores.azul,
      height: 10.h,
      alignment: Alignment.center,
      child: TextButton(
          onPressed: (){
            final hoy=DateTime.now();
            final bool esHoy = isSameDay(widget.fechaTitulo, hoy);

            Navigator.push(context, MaterialPageRoute(builder: (builder)=>OpcionesPeso(fecha: widget.fechaTitulo, esHoy: esHoy)));
          },
          child: Text("Datos",style: TextStyle(fontSize: 25.sp, color: Colores.blanco))),
    );

    return Scaffold(
      backgroundColor: Colores.grisClaro,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH),
          child: TituloConSalida(titulo: diaActual)
      ),
      body: Container(
        height: 80.h,
        margin: EdgeInsets.all(2.h),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 2.h,
          children: [
            _hacerCaja(widget.hijosSuperior),
            _hacerCaja(widget.hijosInferior)
          ],
        ),
      ),
      bottomNavigationBar: aux
    );
  }
}