import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:samvaad/models/log.dart';
import 'package:samvaad/resources/local_db/interface/log_interface.dart';

class HiveMethods implements LogInterface {
  late String hiveBoxName;
  late Box _box;

  @override
  dynamic openDb(String dbName) {
    hiveBoxName = dbName;
    _box = Hive.box(hiveBoxName);
  }
  @override
  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  @override
  Future<int> addLogs(Log log) async {
    final logMap = Log.toMap(log);

    final idOfInput = await _box.add(logMap);

    print("Log added with id ${idOfInput.toString()} in Hive db");

    return idOfInput;
  }

  @override
  Future<void> updateLogs(int index, Log newLog) async {
    final newLogMap = Log.toMap(newLog);

    _box.putAt(index, newLogMap);
  }

  @override
  Future<List<Log>> getLogs() async {
    final logList = <Log>[];

    for (int i = 0; i < _box.length; i++) {
      final logMap = _box.getAt(i);

      logList.add(Log.fromMap(logMap));
    }
    return logList;
  }

  @override
  Future<void> deleteLogs(int logId) async {
    await _box.deleteAt(logId);
  }

  @override
  void close() {
    Hive.close();
  }
}
