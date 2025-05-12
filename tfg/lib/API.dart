import 'package:http/http.dart' as http;
import 'package:tfg/ConexionBDLocal.dart';
import 'dart:convert';
import 'constantes.dart';

final ipPuerto="192.168.0.21:3000";

Future<bool> login(String user, String passwd) async {
  final url = Uri.parse('http://$ipPuerto/login');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'username': user, 'passwd': passwd}),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final token = data['token'];

    await storage.write(key: 'token', value: token);

    print('Login correcto: ${response.body}');
    return true;
  } else {
    print('Error: ${response.statusCode} - ${response.body}');
    return false;
  }
}

Future<bool> verificar() async{

  final String token= await storage.read(key: 'token') ?? '';
  final url = Uri.parse('http://$ipPuerto/verificar');

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    print('Login correcto: ${response.body}');
    return true;
  } else {
    print('Error: ${response.statusCode} - ${response.body}');
    return false;
  }
}

Future<bool> singin(String user, String passwd) async {
  final url = Uri.parse('http://$ipPuerto/singin');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'username': user, 'passwd': passwd}),
  );

  if (response.statusCode == 200) {
    print('Cuenta creada correctamente: ${response.body}');
    return true;
  } else {
    print('Error: ${response.statusCode} - ${response.body}');
    return false;
  }
}

Future<int> existeUser(String user) async{
  final url = Uri.parse('http://$ipPuerto/existeUser');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'username': user}),
  );

  if (response.statusCode == 200) {
    final datos=jsonDecode(response.body);

    if(datos['existe']){
      return 1;
    }else{
      return 0;
    }

  } else {
    print('Error: ${response.statusCode} - ${response.body}');
    return -1;
  }
}

Future<int> subirRutina(String nombre) async{

  final ver = await verificar();

  if(!ver){
    return -3;
  }

  final bd=BDLocal.instance;

  //Obtengo los datos de la rutina
  final rutina = await bd.getRutina(nombre);

  if(rutina['ejercicios']==null){
    return -2;
  }

  String aux = rutina['ejercicios'];
  final List<String> listaEjercicios = aux.split(',');

  //Subo los ejercicios, lo hago así para obtener los ids
  List<Future<int>> futures = List.empty(growable: true);
  listaEjercicios.forEach((value) => futures.add(_subirEjercicio(value,bd)));

  //Espero a que se suban
  List<int> res = await Future.wait(futures);

  if(res.contains(-1)){
    return -1;
  }

  final usuario=await storage.read(key: 'usuario') ?? '';

  //Subo los datos de la rutina
  final url = Uri.parse('http://$ipPuerto/subirRutina');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'nombre': nombre, 'descripcion': rutina['descripcion'], 'ejercicios': res,'usuario':usuario , 'descansos': rutina['descansos']}),
  );

  if(response.statusCode!=200){
    return -1;
  }
  //Añado a los ejercicios el id de la rutina a la que pertenecen
  final idRutina=jsonDecode(response.body)['id'];
  final url2 = Uri.parse('http://$ipPuerto/aniadirIdsAEjercicios');

  final response2 = await http.post(
    url2,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'idsEjercicios': res, 'idRutina': idRutina})
  );

  if(response2.statusCode!=200){
    return -1;
  }

  final idsEjercicios=res.join(',');

  final url3 = Uri.parse('http://$ipPuerto/aniadirEjerciciosARutina');
  final response3 = await http.post(
      url3,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'idsEjercicios': idsEjercicios, 'idRutina': idRutina})
  );

  if(response3.statusCode!=200){
    return -1;
  }

  return 0;
}

Future<int> _subirEjercicio(String nombre,BDLocal bd) async{
  final ejercicio = await bd.getEjercicio(nombre);

  final url = Uri.parse('http://$ipPuerto/subirEjercicio');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'nombre': ejercicio['nombre'], 'tipo': ejercicio['tipo'], 'descripcion': ejercicio['descripcion']}),
  );

  if(response.statusCode==200){
    final datos=jsonDecode(response.body);
    return datos['id'];
  }else{
    return -1;
  }
}

Future<Map<int,String>> getRutinaCompDeUser(String usuario) async{
  final url = Uri.parse('http://$ipPuerto/rutinasCompartidasUsuario');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'usuario': usuario }),
  );

  final datos=jsonDecode(response.body);

  if(response.statusCode==404){
    return {};
  }

  if(response.statusCode!=200){
    return {-1:""};
  }

  final consulta=datos['rutinas'];
  Map<int,String> out={};
  consulta.forEach((value) => out[value['id']]=value['nombre']);

  return out;
}

Future<Map<String,dynamic>> getRutina (int id, {bool usuario=false}) async{
  final url = Uri.parse('http://$ipPuerto/getRutina');

  final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id' : id, 'usuario': usuario})
  );

  if(response.statusCode!=200){
    return {'error':-1};
  }

  return jsonDecode(response.body)['rutina'];
}

Future<Map<int,String>> getRutinas () async{
  final url = Uri.parse('http://$ipPuerto/getRutinas');

  final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
  );

  if(response.statusCode!=200){
    return {-1:"error"};
  }


  final aux=jsonDecode(response.body)['rutinas'];
  Map<int,String> out={};
  aux.forEach((value) => out[value['id']]=value['nombre']);

  return out;
}

Future<int> borrarRutina (int id) async{

  final ver = await verificar();

  if(!ver){
    return -3;
  }

  final url = Uri.parse('http://$ipPuerto/borrarRutina');

  final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id' : id})
  );

  if(response.statusCode!=200){
    return -1;
  }

  return 0;
}

Future<List<String>> getEjerciciosRutina (int id) async{
  final url = Uri.parse('http://$ipPuerto/getEjerciciosRutina');

  final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id' : id})
  );

  if(response.statusCode!=200) {
    return ["error"];
  }

  final consulta = jsonDecode(response.body)['ejercicios'];

  List<String> out = List.empty(growable: true);

  consulta.forEach((value) => out.add(value['nombre']));

  return out;
}

Future<List<Map<String,dynamic>>> getEjerciciosRutinaDescargar (int id) async{
  final url = Uri.parse('http://$ipPuerto/getEjerciciosRutinaDescargar');

  final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'id' : id})
  );

  if(response.statusCode!=200) {
    return [{}];
  }

  final consulta = jsonDecode(response.body)['ejercicios'];

  List<Map<String,dynamic>> out=List.empty(growable: true);

  consulta.forEach((value){
    out.add(value);
  });

  return out;
}

Future<List<String>> getUsuarios() async{
  final url = Uri.parse('http://$ipPuerto/getUsuarios');

  final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
  );

  if(response.statusCode!=200) {
    return ["error"];
  }

  final aux = jsonDecode(response.body)['usuarios'];
  List<String> out = List.empty(growable: true);

  aux.forEach((value) => out.add(value['username']));

  return out;
}

Future<int> registrarDescarga(int id) async {

  final ver = await verificar();

  if(!ver){
    return -3;
  }

  final url=Uri.parse('http://$ipPuerto/registrarDescarga');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({ 'id' : id })
  );

  if(response.statusCode!=200){
    print(jsonDecode(response.body));
  }

  return 0;
}

Future<int> borrarCuenta() async {

  final ver=await verificar();

  if(!ver){
    return -3;
  }

  final String usuario = await storage.read(key: 'usuario') ?? '';
  final url=Uri.parse('http://$ipPuerto/borrarCuenta');

  final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({ 'usuario' : usuario })
  );

  if(response.statusCode!=200){
    return -1;
  }

  return 0;
}