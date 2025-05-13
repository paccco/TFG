import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tfg/constantes.dart';

class Calendario extends StatefulWidget{
  const Calendario({super.key});

  @override
  _calendarioState createState() => _calendarioState();
}

class _calendarioState extends State<Calendario>{

  Future<Widget> _calendario(context) async{
    final DateTime hoy=DateTime.now();
    final String aux = await storage.read(key: 'fechaCreacion') ??'';
    final DateTime primerDia = DateTime.parse(aux);
    final DateTime ultimoDia = hoy.add(Duration(days: 31));

    return TableCalendar(

      calendarFormat: CalendarFormat.twoWeeks,
      locale: 'es_ES',
        focusedDay: hoy,
        firstDay: primerDia,
        lastDay: ultimoDia
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _calendario(context),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return CircularProgressIndicator();
          }else if(snapshot.hasError){
            return Text("ERROR");
          }else{
            return snapshot.data!;
          }
        }
    );
  }
}