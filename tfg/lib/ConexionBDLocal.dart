
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BDLocal{
  static final BDLocal instance = BDLocal._init();

  static Database? _database;

  BDLocal._init();

  final String ejercicios='ejercicios';
  final List<String> camposEjercicios = [
    'nombre', 'tipo', 'descripcion'
  ];

  final String marca='marca';
  final List<String> camposMarca=[
    'fecha','id','repeticiones','peso','tiempo','distancia','unidades','nombreEjercicio'
  ];

  final String rutinas='rutinas';
  final List<String> camposRutinas=[
    'nombre','descripcion','ejercicios'
  ];

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('local.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path,version: 1, onCreate: _onCreateDB);
  }

  Future _onCreateDB(Database db, int version) async {
    await db.execute('PRAGMA foreign_keys = ON');
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
    ${camposRutinas[2]} STRING NOT NULL
    )
    ''');
  }

  Future<void> deleteBD() async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'local.db');
    deleteDatabase(path);
  }

  Future<int> insertEjercicios(Map<String,dynamic> datos) async{
    final db = await instance.database;
    try{
      await db.insert(ejercicios, datos, conflictAlgorithm: ConflictAlgorithm.fail);
      await db.insert(marca, {
        camposMarca[0] : '0000-00-00',
        camposMarca[2] : 0,
        camposMarca[3] : 0,
        camposMarca[4] : '00:00:00',
        camposMarca[5] : 0,
        camposMarca[6] : 0,
        camposMarca[7] : datos.values.first
      });
      await db.insert(marca, {
        camposMarca[0] : '2025-01-01',
        camposMarca[2] : 0,
        camposMarca[3] : 0,
        camposMarca[4] : '00:00:00',
        camposMarca[5] : 0,
        camposMarca[6] : 0,
        camposMarca[7] : datos.values.first
      });

      return 0;
    }catch(error){
      print("\n $error \n");
      return -1;
    }
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
    await db.insert(ejercicios, datos, conflictAlgorithm: ConflictAlgorithm.fail);
  }

  Future<Map<String,dynamic>> getMetaActual(String ejercicio) async{
    final db = await instance.database;
    final out = await db.query(marca,where: '${camposMarca[0]} = ? AND ${camposMarca[7]} = ?', whereArgs: ['0000-00-00',ejercicio], columns: camposMarca.sublist(2,6));
    return out.first;
  }

  Future<Map<String,dynamic>> getMarcaActual(String ejercicio) async{
    final db = await instance.database;
    final out = await db.query(marca,where: '${camposMarca[7]} = ?', whereArgs: [ejercicio], orderBy: '${camposMarca[0]} DESC', columns: camposMarca.sublist(2,6));
    return out.first;
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

  Future<bool> insertRutina(String nombre, String descripcion, String ejercicios) async{
    final db = await instance.database;

    Map<String,dynamic> datos={
      camposRutinas[0] : nombre,
      camposRutinas[1] : descripcion,
      camposRutinas[2] : ejercicios
    };

    final res = await db.insert(rutinas, datos, conflictAlgorithm: ConflictAlgorithm.fail);
    return res!=0;
  }

  Future<List<String>> getNombresRutinas() async{
    final db = await instance.database;
    final mapa = await db.query(rutinas,columns: [camposRutinas[0]]);
    final List<String> out = mapa.map((e) => e.values.first as String).toList();

    return out;
  }
}