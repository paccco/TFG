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
    db.execute('''
    CREATE TABLE $ejercicios(
    ${camposEjercicios[0]} STRING PRIMARY KEY,
    ${camposEjercicios[1]} INT NOT NULL,
    ${camposEjercicios[2]} STRING[255]
    )
    ''');
  }

  Future<void> insertEjercicios(Map<String,dynamic> datos) async{
    final db = await instance.database;
    await db.insert(ejercicios, datos, conflictAlgorithm: ConflictAlgorithm.fail);
  }

  Future<List<Map<String,dynamic>>> getEjercicios() async{
    final db= await instance.database;
    final List<Map<String,dynamic>> out = await db.query(ejercicios);

    return out;
  }

  Future<List<Map<String,dynamic>>> getNombreEjercicios() async{
    final db= await instance.database;
    final List<Map<String,dynamic>> out = await db.query(ejercicios,columns: [camposEjercicios[0]]);

    return out;
  }
  
  Future<void> borrarEjer(String nombre) async{
    final db = await instance.database;
    await db.delete(ejercicios,where: '${camposEjercicios[0]} = ?', whereArgs: [nombre]);
  }
}