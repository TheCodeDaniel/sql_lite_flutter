import 'package:sqflite/sqflite.dart';
import 'package:untitled/db/database_service.dart';
import 'package:untitled/model/states_model.dart';

class StatesDB {
  final tableName = "state_table";

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
    "id" INTEGER PRIMARY KEY,
    "stateName" TEXT NOT NULL
  )""");
  }

  // create
  Future<int> create({required String stateName}) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
      '''INSERT INTO $tableName (stateName) VALUES (?)''',
      [stateName],
    );
  }

  // read
  Future<List<States>> fetchAll() async {
    final database = await DatabaseService().database;
    final states = await database.rawQuery(
      '''SELECT * FROM $tableName''',
    );

    return states.map((data) => States.fromSqfliteDatabase(data)).toList();
  }

  // read by id
  Future<States> fetchById(int id) async {
    final database = await DatabaseService().database;
    final states = await database.rawQuery(
      '''SELECT * from $tableName WHERE id = ?''',
      [id],
    );
    return States.fromSqfliteDatabase(states.first);
  }

  // update
  Future<int> update({required int id, String? stateName}) async {
    final database = await DatabaseService().database;
    return await database.update(
      tableName,
      {
        if (stateName != null) 'stateName': stateName,
      },
      where: 'id = ?',
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [id],
    );
  }

  // delete
  Future<void> delete(int id) async {
    final database = await DatabaseService().database;
    await database.rawDelete(
      '''DELETE FROM $tableName WHERE id = ?''',
      [id],
    );
  }
}
