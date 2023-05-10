import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class VisitedPlaces {
  static const int MAX_PLACES = 2;

  List<String> facilities = [];

  VisitedPlaces({required this.facilities});

  VisitedPlaces.fromMap(Map<String, dynamic> item) :
    facilities = [item["id1"], item["id2"]];

  Map<String, Object> toMap(){
    return {'id1': facilities[0], 'id2': facilities[1]};
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
    /*facilities.add(newFac);
    return DatabaseHelper.updateFacilities(this);*/
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

    await deleteDatabase(join(path, 'database.db'));

    return openDatabase(
      join(path, 'database.db'),
      version: 1,
      onCreate: (database, version) async {
        await database.execute(
            "CREATE TABLE Recents (id1 TEXT, id2 TEXT);",
        );
      },
    );
  }

  static Future<int> updateFacilities(VisitedPlaces fac) async {
    final Database db = await instance.database;
    debugPrint("----> STORING ON DB: [ ${fac.facilities[0]} , ${fac.facilities[1]} ]");
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
    if (queryResult.isEmpty) return VisitedPlaces(facilities: ["", ""]);
    var listEnc = queryResult[0];
    if (queryResult.length > 1) debugPrint("Something here...");
    var listDec = VisitedPlaces.fromMap(listEnc);
    return listDec;
  }
}
