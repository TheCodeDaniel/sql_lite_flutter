import 'package:sqflite/sqflite.dart';
import 'package:untitled/db/database_service.dart';
import 'package:untitled/model/lga_model.dart';
import 'package:untitled/model/states_model.dart';

class StatesDB {
  final statesTableName = "state_table";
  final localGovernmentsTableName = "local_governments_table";

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $statesTableName (
    "id" INTEGER PRIMARY KEY,
    "stateName" TEXT NOT NULL
  )""");

    await database
        .execute("""CREATE TABLE IF NOT EXISTS $localGovernmentsTableName (
    "id" INTEGER PRIMARY KEY,
    "stateId" INTEGER NOT NULL,
    "localGovernmentName" TEXT NOT NULL,
    FOREIGN KEY (stateId) REFERENCES $statesTableName(id) ON DELETE CASCADE
  )""");
  }

  // STATES SECTION------------------

  // create
  Future<int> create({required String stateName}) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
      '''INSERT INTO $statesTableName (stateName) VALUES (?)''',
      [stateName],
    );
  }

  // read
  Future<List<States>> fetchAll() async {
    final database = await DatabaseService().database;
    final states = await database.rawQuery(
      '''SELECT * FROM $statesTableName''',
    );

    return states.map((data) => States.fromSqfliteDatabase(data)).toList();
  }

  // read by id
  Future<States> fetchById(int id) async {
    final database = await DatabaseService().database;
    final states = await database.rawQuery(
      '''SELECT * from $statesTableName WHERE id = ?''',
      [id],
    );
    return States.fromSqfliteDatabase(states.first);
  }

  // update
  Future<int> update({required int id, String? stateName}) async {
    final database = await DatabaseService().database;
    return await database.update(
      statesTableName,
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
      '''DELETE FROM $statesTableName WHERE id = ?''',
      [id],
    );
  }

  // LOCAL GOVERNMENT SECTION

  // create local government
  Future<int> createLocalGovernment({
    required int stateId,
    required String localGovernmentName,
  }) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
      '''INSERT INTO $localGovernmentsTableName (stateId, localGovernmentName) VALUES (?, ?)''',
      [stateId, localGovernmentName],
    );
  }

  // fetch all local governments by state id
  Future<List<LocalGovernment>> fetchLocalGovernmentsByStateId(
      int stateId) async {
    final database = await DatabaseService().database;
    final localGovernments = await database.rawQuery(
      '''SELECT * FROM $localGovernmentsTableName WHERE stateId = ?''',
      [stateId],
    );

    return localGovernments
        .map((data) => LocalGovernment.fromSqfliteDatabase(data))
        .toList();
  }

  // update local government
  Future<int> updateLocalGovernment({
    required int id,
    String? localGovernmentName,
  }) async {
    final database = await DatabaseService().database;
    return await database.update(
      localGovernmentsTableName,
      {
        if (localGovernmentName != null)
          'localGovernmentName': localGovernmentName,
      },
      where: 'id = ?',
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [id],
    );
  }

  // delete local government
  Future<void> deleteLocalGovernment(int id) async {
    final database = await DatabaseService().database;
    await database.rawDelete(
      '''DELETE FROM $localGovernmentsTableName WHERE id = ?''',
      [id],
    );
  }

  //
}
