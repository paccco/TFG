
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/funcionesAux.dart';

class BDLocal{
  static final BDLocal instance = BDLocal._init();

  static Database? _database;

  BDLocal._init();

  final String ejercicios='ejercicios';
  static const List<String> camposEjercicios = [
    'nombre', 'tipo', 'descripcion'
  ];

  final String marca='marca';
  static const List<String> camposMarca=[
    'fecha','id','repeticiones','peso','tiempo','distancia','unidades','nombreEjercicio'
  ];

  final String rutinas='rutinas';
  static const List<String> camposRutinas=[
    'nombre','descripcion','ejercicios', 'descansos'
  ];

  final String entrenamientos='entrenamientos';
  static const List<String> camposEntrenamientos=[
    'fecha','rutina'
  ];

  final String pesajes='pesajes';
  static const List<String> camposPesajes=[
    'fecha','peso','grasa','hueso','musculo'
  ];

  Future<Database> get database async {

    if (_database != null) return _database!;

    String nombreUsuario = await storage.read(key: 'usuario') ?? '';

    _database = await _initDB('$nombreUsuario.db');
    return _database!;
  }

  Future<int> deleteDataBase() async{
    final nombreUsuario = await storage.read(key: 'usuario') ?? '';

    if (_database != null){
      await deleteDatabase('$nombreUsuario.db');
    }

    return 0;
  }

  Future<void> borrarBDuserEliminado(String usuario)async{
    await deleteDatabase('$usuario.db');
  }

  Future<void> cerrarBD() async{
    if(_database!=null) await _database!.close();
    _database=null;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path,version: 1,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
        onCreate: _onCreateDB);
  }

  Future _onCreateDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $ejercicios(
    ${camposEjercicios[0]} STRING PRIMARY KEY,
    ${camposEjercicios[1]} TINYINT NOT NULL,
    ${camposEjercicios[2]} STRING[255]
    )
    ''');
    await db.execute('''
    CREATE TABLE $marca(
    ${camposMarca[0]} DATE,
    ${camposMarca[1]} INTEGER PRIMARY KEY,
    ${camposMarca[2]} TINYINT,
    ${camposMarca[3]} INT,
    ${camposMarca[4]} TIME,
    ${camposMarca[5]} INT,
    ${camposMarca[6]} TINYINT,
    ${camposMarca[7]} STRING,
    FOREIGN KEY (${camposMarca[7]}) REFERENCES $ejercicios(${camposEjercicios[0]}) ON DELETE CASCADE
    )
    ''');

    await db.execute('''
    CREATE TABLE $rutinas(
    ${camposRutinas[0]} STRING PRIMARY KEY,
    ${camposRutinas[1]} STRING[255],
    ${camposRutinas[2]} STRING,
    ${camposRutinas[3]} TIME NOT NULL
    )
    ''');

    await db.execute('''
      CREATE TABLE $entrenamientos(
      ${camposEntrenamientos[0]} DATE PRIMARY KEY,
      ${camposEntrenamientos[1]} STRING,
      FOREIGN KEY (${camposEntrenamientos[1]}) REFERENCES $rutinas(${camposRutinas[0]}) ON DELETE SET NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $pesajes(
        ${camposPesajes[0]} DATE PRIMARY KEY,
        ${camposPesajes[1]} INT NOT NULL,
        ${camposPesajes[2]} INT,
        ${camposPesajes[3]} INT,
        ${camposPesajes[4]} INT
      )
    ''');
  }

  Future<bool> existeBD(String usuario) async {
    return databaseExists('$usuario.db');
  }

  Future<String> insertEjercicios(Map<String,dynamic> datos) async{
    final db = await instance.database;
    try{
      await db.insert(ejercicios, datos, conflictAlgorithm: ConflictAlgorithm.fail);
      await db.insert(marca, {
        camposMarca[0] : '0000-00-00',
        camposMarca[2] : 0,
        camposMarca[3] : 0,
        camposMarca[4] : '00:00',
        camposMarca[5] : 0,
        camposMarca[6] : 0,
        camposMarca[7] : datos.values.first
      });
    }catch(error){

      if(error.toString().contains('UNIQUE constraint failed')){
        Map<String,dynamic> datosMod=Map.of(datos);
        String nombre=datos.values.first;
        final regex = RegExp(r'\(\d+\)');

        String resultado = "";

        if(regex.hasMatch(nombre)){
          resultado=nombre.replaceAllMapped(regex, (match) {
            String texto = match.group(0)!;
            int numero = int.parse(texto.substring(1,texto.length-1));
            int nuevoNumero = numero + 1;
            return '($nuevoNumero)';
          });
        }else{
          resultado="$nombre(1)";
        }

        datosMod[camposEjercicios[0]]=resultado;
        return insertEjercicios(datosMod);
      }
    }

    return datos.values.first;
  }

  Future<List<Map<String,dynamic>>> getEjercicios() async{
    final db= await instance.database;
    final List<Map<String,dynamic>> out = await db.query(ejercicios);

    return out;
  }

  Future<Map<String,dynamic>> getEjercicio(String nombre) async{
    final db = await instance.database;
    final List<Map<String,dynamic>> out = await db.query(ejercicios,where: '${camposEjercicios[0]} = ?',whereArgs: [nombre]);

    return out.first;
  }

  Future<List<String>> getNombreEjercicios() async{
    final db= await instance.database;
    final List<Map<String,dynamic>> aux = await db.query(ejercicios,columns: [camposEjercicios[0]]);

    List<String> out=[];
    for (var elemento in aux) {
      out.add(elemento.values.first);
    }

    return out;
  }
  
  Future<void> borrarEjer(String nombre) async{
    final db = await instance.database;

    //Obtengo las rutinas que contengan el ejercicio
    List<Map<String,dynamic>> aux = await db.query(rutinas,where: '${camposRutinas[2]} LIKE ?', whereArgs: ['%$nombre%'],columns: [camposRutinas[0],camposRutinas[2]]);

    if(aux.isNotEmpty){
      //Borro el ejercicio
      List<Map<String,dynamic>> nuevosDatos=[];
      aux.forEach((rutina){
        String listaEjercicios = rutina[camposRutinas[2]];
        listaEjercicios = listaEjercicios.replaceAll(RegExp(r'(,?)' + RegExp.escape(nombre) + r'(,?)'), '');
        nuevosDatos.add({ camposRutinas[0] : rutina[camposRutinas[0]] , camposRutinas[2] : listaEjercicios});
      });

      //Hago una query para actualiarlo todo a la vez
      String query='''
      UPDATE $rutinas
      SET ${camposRutinas[2]} = CASE
    ''';

      nuevosDatos.forEach((rutina){

        final String listaEjercicios=rutina[camposRutinas[2]];

        query+= ''' 
      WHEN ${camposRutinas[0]} = '${rutina[camposRutinas[0]]}' THEN '$listaEjercicios'
      ''';
      });

      query+='''
      ELSE ${camposRutinas[2]}
      END
    ''';

      await db.rawUpdate(query);
    }

    await db.delete(ejercicios,where: '${camposEjercicios[0]} = ?', whereArgs: [nombre]);
  }

  Future<String> getDescripcionEjer(String nombre) async{
    final db = await instance.database;
    final List<Map<String,dynamic>> aux = await db.query(ejercicios,where: '${camposEjercicios[0]} = ?', whereArgs: [nombre],columns: [camposEjercicios[2]]);

    return aux.first.values.first;
  }

  Future<bool> modDescripcionEjer(String desc, String nombre) async{
    final db = await instance.database;
    final res = await db.update(
          ejercicios,
          {camposEjercicios[2] : desc},
          where: '${camposEjercicios[0]} = ?',
          whereArgs: [nombre]
        );

    return res!=0;
  }

  Future<void> insertMarca(Map<String,dynamic> datos) async{
    final db = await instance.database;
    Map<String,dynamic> aux = datos;
    aux[camposMarca[2]]=aux[camposMarca[2]]==null ? null : aux[camposMarca[2]]*100;
    aux[camposMarca[3]]=aux[camposMarca[3]]==null ? null : aux[camposMarca[3]]*100;
    aux[camposMarca[5]]=aux[camposMarca[5]]==null ? null : aux[camposMarca[5]]*100;

    await db.insert(marca, aux, conflictAlgorithm: ConflictAlgorithm.fail);
  }

  Future<Map<String,dynamic>> getMetaActual(String ejercicio) async{
    final db = await instance.database;
    final out = await db.query(marca,where: '${camposMarca[0]} = ? AND ${camposMarca[7]} = ?', whereArgs: ['0000-00-00',ejercicio], columns: camposMarca.sublist(2,6));
    return out.first;
  }

  Future<Map<String,dynamic>> getMarcaActual(String ejercicio) async{
    final db = await instance.database;
    final out = await db.query(marca,where: '${camposMarca[7]} = ?', whereArgs: [ejercicio], orderBy: '${camposMarca[1]} DESC', columns: camposMarca.sublist(2,6));
    return out.first;
  }

  Future<List<Map<String,dynamic>>> getMarcasfecha(DateTime fecha) async{
    final db = await instance.database;
    final out = await db.query(marca,where: '${camposMarca[0]} = ?', whereArgs: [stringDate(fecha)], columns: camposMarca.sublist(2,8));

    return out;
  }

  Future<Map<String,Map<String,dynamic>>> getMediaMarca(String ejercicio, {DateTime? desde, DateTime? hasta}) async {
    final db = await instance.database;

    desde??=DateTime(1);
    hasta??=DateTime.now();

    final aux = await db.rawQuery('''
    SELECT
      ${camposMarca[0]} AS fecha,
      AVG(${camposMarca[2]}) AS repeticiones,
      AVG(${camposMarca[3]}) AS peso,
      AVG(${camposMarca[5]}) AS distancia,
      AVG(
        (strftime('%M', ${camposMarca[4]}) * 60) + COALESCE(strftime('%S', ${camposMarca[4]}), 0)
      ) AS tiempo
    FROM $marca
    WHERE ${camposMarca[7]} = ?
      AND ${camposMarca[0]} BETWEEN ? AND ?
    GROUP BY ${camposMarca[0]}
    ORDER BY ${camposMarca[0]} ASC
  ''', [ejercicio,stringDate(desde),stringDate(hasta)]);

    final Map<String,Map<String,dynamic>> out={};

    aux.forEach((mediaPorFecha){

      String fecha = mediaPorFecha[camposMarca[0]] as String;

      final List<String> aux=fecha.split('-');

      if(aux[1].length!=2){
        aux[1]='0'+aux[1];
      }
      if(aux[2].length!=2){
        aux[2]='0'+aux[2];
      }

      fecha="${aux[0]}-${aux[1]}-${aux[2]}";

      out[fecha]={
        camposMarca[2] : ((mediaPorFecha[camposMarca[2]] as double)/100).round()*1.0,
        camposMarca[3] : ((mediaPorFecha[camposMarca[3]] as double)/100).round()*1.0,
        camposMarca[4] : mediaPorFecha[camposMarca[4]],
        camposMarca[5] : ((mediaPorFecha[camposMarca[5]] as double)/100).round()*1.0
      };
    });

    return out;
  }



  Future<void> modMeta(String ejercicio,Map<String,dynamic> datos) async{
    final db = await instance.database;

    Map<String,dynamic> datosAu=Map.of(datos);

    if(datosAu.containsKey(camposMarca[3])){
      int aux=(datosAu[camposMarca[3]]*100).round();
      datos[camposMarca[3]]=aux;
    }
    if(datosAu.containsKey(camposMarca[5])){
      int aux=(datosAu[camposMarca[5]]*100).round();
      datos[camposMarca[5]]=aux;
    }

    await db.update(
        marca,
        where: '${camposMarca[7]} = ? AND ${camposMarca[0]} = ?',
        whereArgs:[ejercicio,'0000-00-00'] ,
        datos
    );
  }

  Future<String> insertRutina(String nombre, String descripcion, String descansos) async{
    final db = await instance.database;

    Map<String,dynamic> datos={
      camposRutinas[0] : nombre,
      camposRutinas[1] : descripcion,
      camposRutinas[3] : descansos
    };

    final aux=await getRutina(nombre);

    if(aux.isNotEmpty){
      int contador=1;
      datos[camposRutinas[0]]+="($contador)";
      Map<String,dynamic> consulta = await getRutina(datos[camposRutinas[0]]);

      while(consulta.isNotEmpty){
        contador++;
        datos[camposRutinas[0]]="$nombre($contador)";
        consulta = await getRutina(datos[camposRutinas[0]]);
      }
    }

    final res = await db.insert(rutinas, datos, conflictAlgorithm: ConflictAlgorithm.fail);

    if(res==0){
      return "";
    }else{
      return datos[camposRutinas[0]];
    }
  }

  Future<List<String>> getNombresRutinas() async{
    final db = await instance.database;
    final mapa = await db.query(rutinas,columns: [camposRutinas[0]]);
    final List<String> out = mapa.map((e) => e.values.first as String).toList();

    return out;
  }

  Future<Map<String,dynamic>> getRutina(String nombre) async{
    final db = await instance.database;
    final mapa = await db.query(rutinas,where: '${camposRutinas[0]} = ?', whereArgs: [nombre]);

    if(mapa.isNotEmpty){
      return mapa.first;
    }else{
      return {};
    }
  }

  Future<Map<String,dynamic>> getDescansoDescripcionRutina(String nombre) async{
    final db = await instance.database;
    final mapa = await db.query(rutinas,where: '${camposRutinas[0]} = ?', whereArgs: [nombre] ,columns:[camposRutinas[1],camposRutinas[3]] );

    if(mapa.isNotEmpty){
      return mapa.first;
    }else{
      return {};
    }
  }

  Future<List<String>> getEjerciciosRutina(String nombre) async{
    final db = await instance.database;
    final mapa = await db.query(rutinas,where: '${camposRutinas[0]} = ?', whereArgs: [nombre],columns: [camposRutinas[2]]);

    final aux = mapa.first.values.first;

    if(mapa.isNotEmpty && aux!="" && aux!=null){
      final String out = mapa.first.values.first as String;
      return out.split(',');
    }else{
      return [];
    }
  }

  //Este añade contenido a lo que hay
  Future<bool> aniadirEjerRutina(String nombreRutina, List<String> nombreEjercicios) async{
    final db = await instance.database;
    final consulta = await db.query(rutinas,where: '${camposRutinas[0]} = ?', whereArgs: [nombreRutina],columns: [camposRutinas[2]]);
    final aux=consulta.isNotEmpty ? consulta.first.values.first : "";

    String ejercicios="";
    final cadenaEjercicios=nombreEjercicios.join(',');

    if(aux==""){
      ejercicios=cadenaEjercicios;
    }else if (aux!=null){
      ejercicios=aux as String;
      ejercicios+=',$cadenaEjercicios';
    }

    final res = await db.update(rutinas,{camposRutinas[2] : ejercicios},where: '${camposRutinas[0]} = ?', whereArgs: [nombreRutina]);

    return res!=0;
  }

  //Sustituye la lista por otra
  Future<int> modEjerRutina(String nombreRutina, List<String> ejercicios) async{
    final db = await instance.database;
    String ejerciciosStr = ejercicios.join(',');
    return await db.update(rutinas,{camposRutinas[2] : ejerciciosStr},where: '${camposRutinas[0]} = ?', whereArgs: [nombreRutina]);
  }

  Future<int> modRutina(String nombreRutina,String desripcion,String descanso, {String nombreNuevo=""}) async{
    final db = await instance.database;

    int res=0;

    if(nombreNuevo.isEmpty){
      res = await db.update(rutinas,{camposRutinas[1] : desripcion,camposRutinas[3] : descanso},where: '${camposRutinas[0]} = ?', whereArgs: [nombreRutina]);
    }else{
      res = await db.update(rutinas,{camposRutinas[0] : nombreNuevo,camposRutinas[1] : desripcion,camposRutinas[3] : descanso},where: '${camposRutinas[0]} = ?', whereArgs: [nombreRutina]);
    }

    return res;
  }

  Future<void> borrarRutina(String nombre) async{
    final db = await instance.database;
    await db.delete(rutinas,where: '${camposRutinas[0]} = ?', whereArgs: [nombre]);
  }

  Future<bool> insertEntrenamiento(DateTime fecha, String rutina) async{
    final db = await instance.database;
    final res=await db.insert(entrenamientos,{camposEntrenamientos[0] : stringDate(fecha),camposEntrenamientos[1] : rutina},conflictAlgorithm: ConflictAlgorithm.replace);

    return res!=0;
  }

  Future<Map<String,String>> getEntrenamientos(DateTime inicial, DateTime ultima) async{
    final db = await instance.database;
    final String sInicial=stringDate(inicial), sUltima=stringDate(ultima);
    final List<Map<String,dynamic>> aux = await db.query(entrenamientos,where: '${camposEntrenamientos[0]} BETWEEN ? AND ?',whereArgs: [sInicial,sUltima]);

    Map<String,String> res={};

    aux.forEach((fila){
      res[fila[camposEntrenamientos[0]]]=fila[camposEntrenamientos[1]];
    });

    return res;
  }

  Future<void> borrarEntremiento(DateTime fecha) async{
    final db = await instance.database;
    await db.delete(entrenamientos,where: '${camposEntrenamientos[0]} = ?', whereArgs: [stringDate(fecha)]);
  }

  Future<bool> insertPesaje(DateTime fecha, String peso) async {
    final db = await instance.database;

    String aux="${peso}00";
    final res = await db.insert(pesajes, {camposPesajes[0] : stringDate(fecha),camposPesajes[1] : aux},conflictAlgorithm: ConflictAlgorithm.replace);

    return res!=0;
  }

  Future<void> insertMetaPeso(String nuevoPeso, int pesoActual) async {
    final db = await instance.database;

    print(nuevoPeso);

    int pesoObj=gestorDeComas(nuevoPeso);

    if(pesoActual>pesoObj){
      //El peso actual es mayor que el objetivo, quiere adelgazar, peso negativo
      pesoObj=(-pesoObj);
    }

    await db.insert(pesajes, {camposPesajes[0] : '0000-00-00',camposPesajes[1] : pesoObj},conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<bool> setMacros(DateTime fecha, int grasa, int hueso, int musculo) async{
    final db = await instance.database;
    final res = await db.update(pesajes,
        {camposPesajes[2] : grasa,camposPesajes[3] : hueso,camposPesajes[4] : musculo},
        where: '${camposPesajes[0]} = ?',
        whereArgs: [stringDate(fecha)],
        conflictAlgorithm: ConflictAlgorithm.replace
    );

    return res!=0;
  }

  Future<Map<String,int>> getPesaje(DateTime fecha) async{
    final db = await instance.database;
    final res = await db.query(pesajes,
        where: '${camposPesajes[0]} = ?',
        whereArgs: [stringDate(fecha)],
        columns: [camposPesajes[1],camposPesajes[2],camposPesajes[3],camposPesajes[4]]
    );

    if(res.isNotEmpty){
      Map<String,int> out = {};
      res.first.forEach((key, value) {
        out[key]=(value ?? 0) as int;
      });
      return out;
    }else{
      return {};
    }
  }

  Future<int> getPesoObjetivo() async{
    final db = await instance.database;
    final res = await db.query(pesajes,
        where: '${camposPesajes[0]} = ?',
        whereArgs: ['0000-00-00'],
        columns: [camposPesajes[1]]);

    int out = 0;

    if(res.isNotEmpty){
      out = res.first[camposPesajes[1]] as int;
    }

    return out;
  }

  Future<int> getPesoActual() async{
    final db = await instance.database;
    final res = await db.query(
        pesajes,
        columns: [camposPesajes[1]],
        orderBy: '${camposPesajes[0]} DESC',
      limit: 1
    );

    final out = res.first[camposPesajes[1]] as int;

    return out;
  }
}