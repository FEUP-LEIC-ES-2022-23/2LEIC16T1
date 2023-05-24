import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class VisitedPlaces {
  static const int MAX_PLACES = 6; // Here we can define the nr of visited places

  List<String> facilities = [];

  VisitedPlaces({required this.facilities});

  VisitedPlaces.fromMap(Map<String, dynamic> item) {
    facilities.clear();
    for (int i = 1; i <= MAX_PLACES; i++) {
      facilities.add(item['id$i']);
    }
  }

  Map<String, Object> toMap(){
    Map<String, Object> map = {};
    for (int i = 1; i <= MAX_PLACES; i++) {
      map['id$i'] = facilities[i-1];
    }
    return map;
  }

  Future<int> updateFacilities(String newFac) {
    if (facilities.contains(newFac)) {
      facilities.remove(newFac);
      facilities.insert(0, newFac);
    } else {
      facilities.insert(0, newFac);

      if (facilities.length > MAX_PLACES) {
        facilities.removeLast();
      }
    }

    return DatabaseHelper.updateFacilities(this);
  }

  Future<void> fetchFacilities() async {
    var list = await DatabaseHelper.getList();
    facilities = list.facilities;
  }
}

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await initializeDB();

  static Future<Database> initializeDB() async {
    String path = await getDatabasesPath();

    List<String> idFields = [];
    for (int i = 1; i <= VisitedPlaces.MAX_PLACES; i++) {
      idFields.add('id$i TEXT');
    }
    String tableAttrs = idFields.join(', ');

    return openDatabase(
      join(path, 'database.db'),
      version: 1,
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE Recents ($tableAttrs);',
        );
      },
    );
  }

  static Future<int> updateFacilities(VisitedPlaces fac) async {
    final Database db = await instance.database;
    await db.execute(
      "DELETE FROM Recents;",
    );
    final result = await db.insert(
        'Recents', fac.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
    return result;
  }

  static Future<VisitedPlaces> getList() async {
    final Database db = await instance.database;
    final List<Map<String, Object?>> queryResult = await db.rawQuery('SELECT * FROM Recents');
    if (queryResult.isEmpty) return VisitedPlaces(facilities: List.generate(VisitedPlaces.MAX_PLACES, (index) => ""));
    var listEnc = queryResult[0];
    var listDec = VisitedPlaces.fromMap(listEnc);
    return listDec;
  }
}
