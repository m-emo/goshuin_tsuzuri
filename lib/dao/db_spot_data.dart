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
      "CREATE TABLE $tableName(id TEXT PRIMARY KEY, spotName TEXT,  prefectures TEXT,  prefecturesNo TEXT, img TEXT, createData TEXT)",
    );
  }

  /* データ登録*/
  Future<void> insertSpot(Spot spot) async {
    final Database db = await database;
    await db.insert(
      tableName,
      spot.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

class Spot {
  final String id; // 神社・寺院ID [都道府県番号-都道府県番号内の連番5桁（03-00001）]
  final String spotName; // 神社・寺名
  final String prefectures; // 都道府県名
  final String prefecturesNo; // 都道府県No
  final String img; // 画像(base64)
  final String createData; // 登録日

  Spot(
      {this.id,
        this.spotName,
        this.prefectures,
        this.prefecturesNo,
        this.img,
        this.createData});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'spotName': spotName,
      'prefectures': prefectures,
      'prefecturesNo': prefecturesNo,
      'img': img,
      'createData': createData,
    };
  }

  @override
  String toString() {
    return 'Spot{id: $id, spotName: $spotName, prefectures: $prefectures, prefecturesNo: $prefecturesNo, img: $img, createData: $createData}';
  }
}