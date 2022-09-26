import 'package:flutter/material.dart';
import 'package:goshuintsuzuri/dao/db_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:async';
import 'package:path/path.dart';

class DbGoshuinData extends DBProvider {
  @override
  String get databaseName => "goshuintsuzuri.db";

  @override
  String get tableName => "goshuin";
  String get tableNameSopt => "spot";

  @override
  createDatabase(Database db, int version) async {
    db.execute(
      "CREATE TABLE $tableName(id TEXT PRIMARY KEY, spotId TEXT, goshuinName TEXT, date TEXT, memo TEXT, createData TEXT, img TEXT)",
    );
    db.execute(
      "CREATE TABLE $tableNameSopt(id TEXT PRIMARY KEY, spotName TEXT,  kbn TEXT, prefectures TEXT,  prefecturesNo TEXT, createData TEXT, img TEXT)",
    );
  }

  /* データ登録*/
  Future<void> insertGoshuin(GoshuinData goshuin) async {
    final Database db = await database;
    await db.insert(
      tableName,
      goshuin.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /* 更新 */
  Future<void> updateGoshuin(GoshuinData goshuin) async {
    print("★------------更新したよ-------------★");
    final db = await database;
    await db.update(
      tableName,
      goshuin.toMap(),
      where: "id = ?",
      whereArgs: [goshuin.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  /* 削除 */
  Future<void> deleteGoshuin(String id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );
    print("db_goshuin_data.dart★削除した");
  }

  /* 全件取得 */
  Future<List<GoshuinListData>> getAllGoshuins() async {
    var sqltext = 'SELECT goshuin.id, goshuin.spotId, spot.spotName, spot.prefecturesNo, spot.prefectures, goshuin.goshuinName, goshuin.date, goshuin.memo, goshuin.createData, goshuin.img FROM ' + tableName + ' INNER JOIN '+ tableNameSopt +' ON '+tableName+'.spotId = '+ tableNameSopt +'.id ORDER BY goshuin.id DESC';
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(sqltext);
    List<GoshuinListData> list =[];
    for (Map map in maps) {
      list.add(GoshuinListData(
        id: map['id'],
        img: map['img'],
        spotId: map['spotId'],
        spotName: map['spotName'],
        spotPrefecturesNo: map['prefecturesNo'],
        spotPrefectures: map['prefectures'],
        goshuinName: map['goshuinName'],
        date: map['date'],
        memo: map['memo'],
        createData: map['createData'],
      ));
    }
    return list;
  }

  /* 最大IDレコード取得 */
  Future<GoshuinData> getMaxIdGoshuin() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db
        .rawQuery('SELECT * FROM ' + tableName + ' ORDER BY id DESC LIMIT 1');
    var goshuin = new GoshuinData(id: '', img: '', spotId: '', goshuinName: '', date: '', memo: '', createData: '',);
    var i = 0;
    if (maps.length != 0) {
      print("★★★--------最大IDレコード取得");
      print(maps[i]['createData']);
      goshuin = GoshuinData(
        id: maps[i]['id'],
        img: maps[i]['img'],
        spotId: maps[i]['spotId'],
        goshuinName: maps[i]['goshuinName'],
        date: maps[i]['date'],
        memo: maps[i]['memo'],
        createData: maps[i]['createData'],
      );
    }
    return goshuin;
  }
}

class GoshuinData {
  final String id; // [GSI+連番9桁（GSI000000001）]
  final String img; // 画像(base64)
  final String spotId; // 神社・寺院ID [SPT+連番9桁（SPT000000001）]
  final String goshuinName; // 御朱印名
  final String date; // 参拝日
  final String memo; // メモ
  final String createData; // 登録日

  GoshuinData(
      {required this.id,
        required this.img,
        required this.spotId,
        required this.goshuinName,
        required this.date,
        required this.memo,
        required this.createData});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'img': img,
      'spotId': spotId,
      'goshuinName': goshuinName,
      'date': date,
      'memo': memo,
      'createData': createData,
    };
  }

  @override
  String toString() {
    return 'GoshuinData{id: $id, img: $img, spotId: $spotId, goshuinName: $goshuinName, date: $date, memo: $memo, createData: $createData}';
  }
}

class GoshuinListData {
  final String id; // [GSI+連番9桁（GSI000000001）]
  final String img; // 画像(base64)
  final String spotId; // 神社・寺院ID [SPT+連番9桁（SPT000000001）]
  final String spotName; // 神社・寺院名
  final String spotPrefecturesNo; // 都道府県番号
  final String spotPrefectures; // 神社・寺院 都道府県
  final String goshuinName; // 御朱印名
  final String date; // 参拝日
  final String memo; // メモ
  final String createData; // 登録日

  GoshuinListData(
      {required this.id,
      required this.img,
      required this.spotId,
      required this.spotName,
      required this.spotPrefecturesNo,
      required this.spotPrefectures,
      required this.goshuinName,
      required this.date,
      required this.memo,
      required this.createData});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'img': img,
      'spotId': spotId,
      'spotName': spotName,
      'spotPrefecturesNo': spotPrefecturesNo,
      'spotPrefectures': spotPrefectures,
      'goshuinName': goshuinName,
      'date': date,
      'memo': memo,
      'createData': createData,
    };
  }

  @override
  String toString() {
    return 'GoshuinListData{id: $id, img: $img, spotId: $spotId, spotName: $spotName, spotPrefecturesNo: $spotPrefecturesNo, spotPrefectures: $spotPrefectures, goshuinName: $goshuinName, date: $date, memo: $memo, createData: $createData}';
  }
}
