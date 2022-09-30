import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/saved_movie_model.dart';

class LocalMovieRepositoryService {
  static const String TABLE = 'movie';
  static const String DB_NAME = 'movie.db';
  static const String ID = 'id';
  static const String TITLE = 'title';
  static const String RELEASEDATE = 'releaseDate';
  static const String IMAGE = 'image';
  static const String OVERVIEW = 'overview';
  static const String MOVIEID = 'movieId';

  static Future<Database?> get _db async => await initDB();

  static Future<Database?> initDB() async {
    final directory = await getDatabasesPath();
    final path = join(directory, DB_NAME);
    return openDatabase(path, version: 1, onCreate: createDatabase);
  }

  static createDatabase(Database db, int version) async {
    await db.execute(
        '''CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY AUTOINCREMENT, $TITLE TEXT, $RELEASEDATE TEXT, $MOVIEID TEXT, $IMAGE TEXT, $OVERVIEW TEXT)''');
  }

  static Future<int> saveMovie(SavedMovieModel model) async {
    var dbClient = await _db;
    return await dbClient!.insert(TABLE, model.toMap());
  }

  static Future<List<SavedMovieModel>> getMovies() async {
    var dbClient = await _db;
    List<Map<String, dynamic>> map = await dbClient!.query(TABLE);
    return map.map((e) => SavedMovieModel.fromMap(e)).toList();
  }

  static Future<int> deleteMovie(int id) async {
    var dbClient = await _db;
    return dbClient!.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }
}
