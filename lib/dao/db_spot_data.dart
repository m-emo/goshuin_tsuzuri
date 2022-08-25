import 'package:flutter/material.dart';
import 'package:goshuintsuzuri/dao/db_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:async';
import 'package:path/path.dart';

class DbSpotData extends DBProvider {
  @override
  String get databaseName => "goshuintsuzuri.db";

  @override
  String get tableName => "spot";

  @override
  createDatabase(Database db, int version) async {
    /*db.execute(
      "CREATE TABLE $tableName(id TEXT PRIMARY KEY, spotName TEXT,  kbn TEXT, prefectures TEXT,  prefecturesNo TEXT, img TEXT, createData TEXT)",
    );*/
  }

  /* データ登録*/
  Future<void> insertSpot(SpotData spot) async {
    final Database db = await database;
    await db.insert(
      tableName,
      spot.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /* 更新 */
  Future<void> updateSpot(SpotData spot) async {
    final db = await database;
    await db.update(
      tableName,
      spot.toMap(),
      where: "id = ?",
      whereArgs: [spot.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  /* 削除 */
  Future<void> deleteSpot(String id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  /* 全件取得 */
  Future<List<SpotData>> getAllSpot() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db
        .rawQuery('SELECT * FROM ' + tableName + ' ORDER BY id ASC');
    List<SpotData> list = [];
    for (Map map in maps) {
      list.add(SpotData(
        id: map['id'],
        spotName: map['spotName'],
        kbn: map['kbn'],
        prefectures: map['prefectures'],
        prefecturesNo: map['prefecturesNo'],
        img: map['img'],
        createData: map['createData'],
      ));
    }
    return list;
  }

  // /* 件数取得（取得条件なし） */
  // Future<int> getAllCount() async {
  //   final Database db = await database;
  //   var result = Sqflite.firstIntValue(
  //       await db.rawQuery("SELECT COUNT (*) FROM " + tableName)
  //   );
  //   return result;
  // }

  /* 最大IDレコード取得 */
  Future<SpotData> getMaxIdSpot() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db
        .rawQuery('SELECT * FROM ' + tableName + ' ORDER BY id DESC LIMIT 1');
    var spot = new SpotData();
    var i = 0;
    if (maps.length != 0) {
      spot = SpotData(
        id: maps[i]['id'],
        spotName: maps[i]['spotName'],
        kbn: maps[i]['kbn'],
        prefectures: maps[i]['prefectures'],
        prefecturesNo: maps[i]['prefecturesNo'],
        img: maps[i]['img'],
        createData: maps[i]['createData'],
      );
    }
    return spot;
  }

}



class SpotData {
  final String id; // 神社・寺院ID [SPT+連番9桁（SPT000000001）]
  final String spotName; // 神社・寺名
  final String kbn; // 区分（1:寺, 2:神社 ,0:その他）
  final String prefectures; // 都道府県名
  final String prefecturesNo; // 都道府県No
  final String img; // 画像(base64)
  final String createData; // 登録日

  SpotData(
      {this.id,
        this.spotName,
        this.kbn,
        this.prefectures,
        this.prefecturesNo,
        this.img,
        this.createData});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'spotName': spotName,
      'kbn': kbn,
      'prefectures': prefectures,
      'prefecturesNo': prefecturesNo,
      'img': img,
      'createData': createData,
    };
  }

  @override
  String toString() {
    return 'SpotData{id: $id, spotName: $spotName, kbn: $kbn, prefectures: $prefectures, prefecturesNo: $prefecturesNo, img: $img, createData: $createData}';
  }
}