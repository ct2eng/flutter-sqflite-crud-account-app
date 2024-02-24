import 'dart:async';
import 'dart:io' as io;

import 'package:account_app/db/model/pos_rec.dart';
import 'package:account_app/db/model/acc_info.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "record.db");
    var theDb = await openDatabase(path,
        version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute("CREATE TABLE pos_rec(" +
        "pos_ser_no INTEGER PRIMARY KEY NOT NULL, " +
        "pos_type TEXT NOT NULL, " +
        "acc_ser_no INTEGER NOT NULL, " +
        "symbol TEXT NOT NULL, " +
        "company_nm TEXT NOT NULL, " +
        "shares INTEGER NOT NULL, " +
        "price INTEGER NOT NULL, " +
        "status INTEGER NOT NULL," +
        "trade_dt DateTime NOT NULL, " +
        "mark INTEGER NOT NULL," +
        "comment TEXT, " +
        "crt_tm TEXT DEFAULT CURRENT_TIMESTAMP" +
        ")");

    await db.execute("CREATE TABLE acc_info(" +
        "acc_ser_no INTEGER PRIMARY KEY NOT NULL, " +
        "acc_nm TEXT NOT NULL, " +
        "total_value INTEGER NOT NULL, " +
        "od INTEGER NOT NULL, " +
        "comment TEXT, " +
        "crt_tm DateTime DEFAULT CURRENT_TIMESTAMP" +
        ")");
    await db.execute("INSERT INTO acc_info (acc_nm,total_value,od)" +
        "VALUES ('初始帳戶', 0, 0)");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future<int> saveRec(Pos_rec rec) async {
    var dbClient = await db;
    int res = await dbClient.insert("pos_rec", rec.toMap());
    return res;
  }

  Future<List<Pos_rec>> getRec() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM pos_rec');
    List<Pos_rec> rtnList = new List<Pos_rec>();
    for (int i = 0; i < list.length; i++) {
      var rec =
          // new Pos_rec(list[i]["firstname"], list[i]["lastname"], list[i]["dob"]);
          new Pos_rec(
              list[i]["pos_type"],
              list[i]["acc_ser_no"],
              list[i]["symbol"],
              list[i]["company_nm"],
              list[i]["shares"],
              list[i]["price"],
              list[i]["status"],
              list[i]["trade_dt"],
              list[i]["mark"],
              list[i]["comment"]);
      rtnList.add(rec);
    }
    return rtnList;
  }

  //搜尋關鍵字
  Future<List<Map>> getSearchData(Map key, int accSerNo) async {
    var dbClient = await db;
    String stringConditions = '';
    if (key.isNotEmpty) {
      stringConditions +=
          ' and (symbol like "%${key['symbol']}%" or company_nm like "%${key['company_nm']}%")';
    }

    List<Map> list = await dbClient.rawQuery(
        'SELECT DISTINCT symbol, company_nm  FROM pos_rec where acc_ser_no = $accSerNo $stringConditions');
    return list;
  }

  //搜尋明細
  Future<List<Map>> getRecResult(Map key, int accSerNo, bool isFuzzy) async {
    var dbClient = await db;
    String stringConditions = '';

    if (key.isNotEmpty) {
      if (isFuzzy) {
        stringConditions +=
            ' and (symbol like "%${key['symbol']}%" or company_nm like "%${key['company_nm']}%")';
      } else {
        stringConditions +=
            ' and (symbol = "${key['symbol']}" and company_nm = "${key['company_nm']}")';
      }
    }

    List<Map> list = await dbClient.rawQuery(
        'SELECT *  FROM pos_rec where acc_ser_no = $accSerNo $stringConditions');
    return list;
  }

  Future<Acc_info> getInitUser() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM acc_info');
    // new Pos_rec(list[i]["firstname"], list[i]["lastname"], list[i]["dob"]);
    Acc_info rtnMap = new Acc_info(list[0]["acc_ser_no"], list[0]["acc_nm"],
        list[0]["total_value"], list[0]["od"], list[0]["comment"]);
    return rtnMap;
  }

  Future<List<Acc_info>> getUserList() async {
    var dbClient = await db;
    List<Map> list =
        await dbClient.rawQuery('SELECT * FROM acc_info order by crt_tm');
    List<Acc_info> rtnList = new List<Acc_info>();
    for (int i = 0; i < list.length; i++) {
      Acc_info rtnMap = new Acc_info(list[i]["acc_ser_no"], list[i]["acc_nm"],
          list[i]["total_value"], list[i]["od"], list[i]["comment"]);
      rtnList.add(rtnMap);
    }
    return rtnList;
  }

  // 選擇當前user
  Future<int> selectUser(Acc_info acc) async {
    var dbClient = await db;
    // await dbClient.transaction((txn) async {
    //     await txn.execute("DELETE FROM User");
    //     await txn.execute("DELETE FROM Posts");
    //   });
    int res;
    await dbClient.transaction((txn) async {
      await txn.rawUpdate("UPDATE acc_info SET od = 1 WHERE 1=1");
      res = await txn.rawUpdate(
          "UPDATE acc_info SET od = 0"
          " WHERE acc_ser_no=?",
          [acc.acc_ser_no]);
    });
    return res;
  }

  Future<int> insertUser(Acc_info user) async {
    var dbClient = await db;
    int res = await dbClient.insert("acc_info", user.toMap());
    return res;
  }

  Future<int> upadteUser(Acc_info acc) async {
    var dbClient = await db;
    int res = await dbClient.rawUpdate(
        "UPDATE acc_info SET acc_nm = ?" +
            ", total_value = ?" +
            ", comment = ?" +
            " WHERE acc_ser_no=?",
        [acc.acc_nm, acc.total_value, acc.comment, acc.acc_ser_no]);
    return res;
  }

  Future<int> delUser(Acc_info acc) async {
    var dbClient = await db;
    int res;
    await dbClient.transaction((txn) async {
      await txn.rawDelete(
          'DELETE FROM pos_rec WHERE acc_ser_no = ?', [acc.acc_ser_no]);
      res = await txn.rawDelete(
          'DELETE FROM acc_info WHERE acc_ser_no = ?', [acc.acc_ser_no]);
    });

    return res;
  }
  //交易控制
  // Future test() async {
  //   var dbClient = await db;
  //   await dbClient.transaction((txn) async {
  //     await txn.execute("DELETE FROM User");
  //     await txn.execute("DELETE FROM Posts");
  //   });
  // }
}
