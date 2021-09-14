import 'package:flutter/material.dart';
import 'package:goshuintsuzuri/dao/db_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:async';
import 'package:path/path.dart';

class DbGoshuinData extends DBProvider {
  @override
  String get databaseName => "goshuin.db";

  @override
  String get tableName => "goshuin";

  @override
  createDatabase(Database db, int version) async {
    db.execute(
      "CREATE TABLE $tableName(id TEXT PRIMARY KEY, img TEXT, spotId TEXT, goshuinName TEXT, date TEXT, memo TEXT, createData TEXT)",
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
}

class GoshuinData {
  final String id; // [GSI+連番6桁（GSI000001）]
  final String img; // 画像(base64)
  final String spotId; // 神社・寺院ID [都道府県番号-都道府県番号内の連番5桁（03-00001）]
  final String goshuinName; // 御朱印名
  final String date; // 参拝日
  final String memo; // メモ
  final String createData; // 登録日

  GoshuinData(
      {this.id,
        this.img,
        this.spotId,
        this.goshuinName,
        this.date,
        this.memo,
        this.createData});

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
  final String id; // [GSI+連番6桁（GSI000001）]
  final String img; // 画像(base64)
  final String spotId; // 神社・寺院ID [都道府県番号-都道府県番号内の連番5桁（03-00001）]
  final String spotName; // 神社・寺院名
  final String spotPrefectures; // 神社・寺院 都道府県
  final String goshuinName; // 御朱印名
  final String date; // 参拝日
  final String memo; // メモ
  final String createData; // 登録日

  GoshuinListData(
      {this.id,
        this.img,
        this.spotId,
        this.spotName,
        this.spotPrefectures,
        this.goshuinName,
        this.date,
        this.memo,
        this.createData});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'img': img,
      'spotId': spotId,
      'spotName': spotName,
      'spotPrefectures': spotPrefectures,
      'goshuinName': goshuinName,
      'date': date,
      'memo': memo,
      'createData': createData,
    };
  }

  @override
  String toString() {
    return 'GoshuinListData{id: $id, img: $img, spotId: $spotId, spotName: $spotName, spotPrefectures: $spotPrefectures, goshuinName: $goshuinName, date: $date, memo: $memo, createData: $createData}';
  }
}