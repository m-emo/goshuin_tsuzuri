import 'package:flutter/material.dart';
import 'package:goshuintsuzuri/dao/db_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:async';
import 'package:path/path.dart';

class DbSpotData extends DBProvider {
  @override
  String get databaseName => "goshuin.db";

  @override
  String get tableName => "spot";

  @override
  createDatabase(Database db, int version) async {
    db.execute(
      "CREATE TABLE $tableName(id TEXT PRIMARY KEY, spotName TEXT,  kbn TEXT, prefectures TEXT,  prefecturesNo TEXT, img TEXT, createData TEXT)",
    );
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
}

class SpotData {
  final String id; // 神社・寺院ID [SPT+連番6桁（SPT000001）]
  final String spotName; // 神社・寺名
  final String kbn; // 区分（1:神社, 2:寺 ,0:その他）
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