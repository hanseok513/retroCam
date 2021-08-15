import 'dart:io';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

final String tableFilms = 'films';
final String columnId = '_id';
final String columnName = 'name';
final String columnImagePaths = 'image_paths';
final String columnCanImagePath = 'can_image_path';

class Film {
  int id;
  String name;
  List<String> imagePaths;
  String canImagePath;

  Film(this.name, this.imagePaths, this.canImagePath);

  Film.withId(String name, List<String> imagePaths, String canImagePath, int id)
      : id = id,
        name = name,
        imagePaths = imagePaths,
        canImagePath = canImagePath;

  Film.fromMap(Map<String, dynamic> map)
      : id = map[columnId],
        name = map[columnName],
        imagePaths = map[columnImagePaths].split('^'),
        canImagePath = map[columnCanImagePath];

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnName: name,
      columnImagePaths: imagePaths.where((element) => element != '').join('^'),
      columnCanImagePath: canImagePath,
    };

    if (id != null) {
      map[columnId] = id;
    }

    return map;
  }
}

class DatabaseHelper {
  static final _databaseName = "films_database.db";
  static final _databaseVersion = 3;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableFilms (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnImagePaths TEXT NOT NULL,
        $columnCanImagePath TEXT NOT NULL
      )
      ''');
  }

  Future<int> insert(Film film) async {
    Database db = await database;
    int id = await db.insert(tableFilms, film.toMap());
    return id;
  }

  Future<Film> queryFilm(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableFilms,
        columns: [columnId, columnName, columnImagePaths],
        where: '$columnId  = ?',
        whereArgs: [id]);

    if (maps.length > 0) {
      return Film.fromMap(maps.first);
    }
    return null;
  }

  Future<void> update(Film film) async {
    Film prevFilm = await queryFilm(film.id);
    if (prevFilm == null) {
      insert(film);
      return;
    }
    Database db = await database;
    db.update(tableFilms, film.toMap(),
        where: '$columnId  = ?', whereArgs: [film.id]);
  }

  Future<List<Film>> queryAllFilms() async {
    Database db = await database;
    List<Map> maps = await db.query(tableFilms,
        columns: [columnId, columnName, columnImagePaths, columnCanImagePath]);

    print(maps.join('\n'));
    if (maps.length > 0) {
      return maps.map((e) {
        return Film.fromMap(e);
      }).toList();
    }

    return null;
  }
}
