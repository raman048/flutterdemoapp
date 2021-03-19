import 'package:flutter_app/core/models/address.dart';
import 'package:flutter_app/core/models/mobileno.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_app/core/models/users.dart';

class DataBaseHelper {
  static DataBaseHelper _dataBaseHelper; //Singleton Database helper
  static Database _database;
  String usersTable = 'users';
  String colId = "id";
  String colFname = "f_name";
  String colLname = "l_name";
  String colEmailId = "email_id";
  String colPassword = "u_password";
  String colGender = "gender";
  String colDateOfBirth = "date_of_birth";
  String colUserImage = "user_image";

  String mobileNoTable = 'mobile';
  String colMobileId = 'm_id';
  String colUserId = 'user_id';
  String colMobileNo = 'mobile_no';

  String addressTable = 'address';
  String colAddressId = 'a_id';
  String colAddres = 'address_detail';

  DataBaseHelper._createInstance();

  factory DataBaseHelper() {
    if (_dataBaseHelper == null) {
      _dataBaseHelper = DataBaseHelper
          ._createInstance(); // This is executed once, Singleton object
    }
    return _dataBaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'usersdata.db';
    var usersDatabase =
        await openDatabase(path, version: 5, onCreate: _createDb);
    return usersDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $usersTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colFname TEXT, $colLname TEXT, $colEmailId TEXT , $colPassword TEXT,$colGender TEXT, $colDateOfBirth TEXT, $colUserImage TEXT)');

    await db.execute(
        'CREATE TABLE $mobileNoTable($colMobileId INTEGER PRIMARY KEY AUTOINCREMENT, $colUserId INTEGER,$colMobileNo TEXT)');
    await db.execute(
        'CREATE TABLE $addressTable ($colAddressId INTEGER PRIMARY KEY AUTOINCREMENT, $colUserId INTEGER, $colAddres TEXT)');
  }

  getUserDetail(int user_id) async {
    Database db = await this.database;
    var result = await db.query(usersTable, orderBy: colId);
    return result;
  }

  Future<int> insertUserNode(Users users) async {
    Database db = await this.database;
    int result = await db.insert(usersTable, users.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    print('---llll' + result.toString());
    return result;
  }

  Future<int> insertMobileNoNode(List<MobileNoModel> mobileNoModel) async {
    Database db = await this.database;
    Batch batch = db.batch();
    mobileNoModel.forEach((mobileno) {
      batch.insert(mobileNoTable, mobileno.toMap());
    });
    batch.commit();
    return 1;
  }

  Future<int> insertAddressNode(List<AddressModel> addressModel) async {
    Database db = await this.database;
    Batch batch = db.batch();
    addressModel.forEach((address) {
      batch.insert(addressTable, address.toMap());
    });
    batch.commit();
    return 1;
  }

  Future<int> getNoOfRecords() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('select count(*) from $usersTable');
    int result = Sqflite.firstIntValue(x);
    print('------' + result.toString());
    return result;
  }

  Future<int> getNoOfMobileRecords() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('select count(*) from $mobileNoTable');
    int result = Sqflite.firstIntValue(x);
    print('------' + result.toString());
    return result;
  }

  Future<int> getNoOfAddressRecords() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('select count(*) from $addressTable');
    int result = Sqflite.firstIntValue(x);
    print('------' + result.toString());
    return result;
  }

  Future<Users> getLogin(String user, String password) async {
    Database db = await this.database;
    var res = await db.rawQuery(
        "SELECT * FROM $usersTable WHERE $colEmailId = '$user' and $colPassword = '$password'");

    if (res.length > 0) {
      print('----' + res.toString());
      return new Users.fromMap(res.first);
    }
    return null;
  }

  Future<List<MobileNoModel>> getMobileNoList(int userId) async {
    Database db = await this.database;
    List<Map> maps = await db
        .rawQuery("SELECT * FROM $mobileNoTable WHERE $colUserId = '$userId'");
    List<MobileNoModel> mobileList = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        mobileList.add(MobileNoModel.fromMap(maps[i]));
      }
    }
    print('asdfasd'+maps.length.toString());
    return mobileList;
  }

  Future<List<AddressModel>> getAddressList(int userId) async {
    Database db = await this.database;
    List<Map> maps = await db
        .rawQuery("SELECT * FROM $addressTable WHERE $colUserId = '$userId'");
    List<AddressModel> addressList = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        addressList.add(AddressModel.fromMap(maps[i]));
      }
    }
    print('asdfasd'+maps.length.toString());
    return addressList;
  }
}
