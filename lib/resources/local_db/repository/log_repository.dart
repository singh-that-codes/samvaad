import 'package:samvaad/models/log.dart';
import 'package:samvaad/resources/local_db/db/hive_methods.dart';
import 'package:meta/meta.dart';
import 'package:samvaad/resources/local_db/db/sqlite_methods.dart';

class LogRepository {
  static var dbObject;

  LogRepository({required bool isHive}) {
    dbObject = isHive ? HiveMethods() : SqliteMethods();
  }

  static init({required bool isHive, required String dbName}) {
    dbObject.openDb(dbName);
    dbObject.init();
  }

  static addLogs(Log log) => dbObject.addLogs(log);

  static deleteLogs(int logId) => dbObject.deleteLogs(logId);

  static getLogs() => dbObject.getLogs();

  static close() => dbObject.close();
}
