import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class VisitedPlaces {
  List<String> facilities = [];

  VisitedPlaces({required this.facilities});

  VisitedPlaces.fromMap(Map<String, dynamic> item) :
    //facilities = [item["id1"], item["id2"]];
    facilities = [item["id1"], ""];
  Map<String, Object> toMap(){
    /*if (facilities.length == 1) {
      return {'id1': facilities[0]};
    } else {
      return {'id1': facilities[0],'id2': facilities[1]};
    }*/
    return {'id1': facilities[0],'id2': ""};
  }

  Future<int> updateFacilities(String newFac) {
    facilities.add(newFac);
    return DatabaseHelper.updateFacilities(this);
  }

  Future<void> fetchFacilities() async {
    debugPrint("--------> Inside fetchFacilities(): before getList\n");
    var list = await DatabaseHelper.getList();
    facilities = list.facilities;
    debugPrint("--------> Inside fetchFacilities(): ( ");
    for (String st in facilities) {
      debugPrint(st);
      debugPrint(" ");
    }
    debugPrint(")\n");
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
    final result = await db.insert(
        'Recents', fac.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
    debugPrint("----> Inside updateFacilities: added fac with success");
    return result;
  }

  static Future<VisitedPlaces> getList() async {
    final Database db = await instance.database;
    final List<Map<String, Object?>> queryResult = await db.rawQuery('SELECT * FROM Recents');
    if (queryResult.isEmpty) return VisitedPlaces(facilities: []);
    var listEnc = queryResult[0];
    var listDec = VisitedPlaces.fromMap(listEnc);
    return listDec;
  }
}
