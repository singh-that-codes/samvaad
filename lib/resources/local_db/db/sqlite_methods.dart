import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:samvaad/models/log.dart';
import 'package:samvaad/resources/local_db/interface/log_interface.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteMethods implements LogInterface {
  Database _db;

  String databaseName = "";
  String tableName = "Call_Logs";

  // columns
  final String id = 'log_id';
  final String callerName = 'caller_name';
  final String callerPic = 'caller_pic';
  final String receiverName = 'receiver_name';
  final String receiverPic = 'receiver_pic';
  final String callStatus = 'call_status';
  final String timestamp = 'timestamp';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    print("Database was null, now awaiting initialization");
    _db = await init();
    return _db;
  }

  @override
  void openDb(String dbName) {
    databaseName = dbName;
  }

  @override
  Future<Database> init() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, databaseName);
    final db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    final createTableQuery = '''
      CREATE TABLE $tableName (
        $id INTEGER PRIMARY KEY,
        $callerName TEXT,
        $callerPic TEXT,
        $receiverName TEXT,
        $receiverPic TEXT,
        $callStatus TEXT,
        $timestamp TEXT
      )
    ''';

    await db.execute(createTableQuery);
    print("Table created");
  }

  @override
  Future<void> addLogs(Log log) async {
    final dbClient = await db;
    print("The log has been added to the SQLite database");
    await dbClient.insert(tableName, log.toMap());
  }

  @override
  Future<void> updateLogs(Log log) async {
    final dbClient = await db;

    await dbClient.update(
      tableName,
      log.toMap(),
      where: '$id = ?',
      whereArgs: [log.logId],
    );
  }

  @override
  Future<List<Log>> getLogs() async {
    try {
      final dbClient = await db;

      final maps = await dbClient.query(tableName);

      final logList = <Log>[];

      if (maps.isNotEmpty) {
        for (final map in maps) {
          logList.add(Log.fromMap(map));
        }
      }

      return logList;
    } catch (e) {
      print(e);
      return <Log>[];
    }
  }

  @override
  Future<void> deleteLogs(int logId) async {
    final client = await db;
    await client.delete(tableName, where: '$id = ?', whereArgs: [logId]);
  }

  @override
  Future<void> close() async {
    final dbClient = await db;
    await dbClient.close();
  }
}
