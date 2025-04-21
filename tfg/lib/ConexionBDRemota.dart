import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constantes.dart';

final ipPuerto="192.168.0.20:3000";

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

Future<bool> verificar(String token) async{
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