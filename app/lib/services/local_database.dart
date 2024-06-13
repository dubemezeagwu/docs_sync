import 'package:docs_sync/screens/app_screens.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static LocalDatabase? _instance;
  static Database? _database;

  LocalDatabase._internal();

  static LocalDatabase get instance {
    _instance ??= LocalDatabase._internal();
    return _instance!;
  }
  Future<Database> get database async {
    _database ??= await _initializeDatabase("documents.db");
    return _database!;
  }

  Future<Database> _initializeDatabase(String path) async {
    final directory = await getApplicationDocumentsDirectory();
    String databasePath = directory.path + path;
    return await openDatabase(
      databasePath,
      version: 1,
    );
  }

  
  
}
