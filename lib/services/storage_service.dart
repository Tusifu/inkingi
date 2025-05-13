import 'package:inkingi/models/transaction.dart';
import 'package:sqflite/sqflite.dart' as sqf;
import 'package:path/path.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  static sqf.Database? _database;

  factory StorageService() => _instance;

  StorageService._internal();

  Future<sqf.Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<sqf.Database> _initDatabase() async {
    final databasesPath = await sqf.getDatabasesPath();
    final path = join(databasesPath, 'inkingi.db');

    return await sqf.openDatabase(
      path,
      version: 3, // Increment to force migration
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE transactions (
          id TEXT PRIMARY KEY,
          description TEXT,
          amount REAL,
          isIncome INTEGER,
          date INTEGER,
          category TEXT
        )
      ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          // Simplified migration: Convert all date values to integers
          final List<Map<String, dynamic>> maps =
              await db.query('transactions');
          for (var map in maps) {
            if (map['date'] != null) {
              try {
                int dateMillis;
                if (map['date'] is String) {
                  final dateStr = map['date'] as String;
                  final date = DateTime.parse(dateStr);
                  dateMillis = date.millisecondsSinceEpoch;
                } else {
                  dateMillis = int.parse(map['date'].toString());
                }
                await db.update(
                  'transactions',
                  {'date': dateMillis},
                  where: 'id = ?',
                  whereArgs: [map['id']],
                );
              } catch (e) {
                print('Error converting date for transaction ${map['id']}: $e');
              }
            }
          }
        }
      },
    );
  }

  Future<void> insertTransaction(Transaction transaction) async {
    final db = await database;
    await db.insert(
      'transactions',
      {
        'id': transaction.id,
        'description': transaction.description,
        'amount': transaction.amount,
        'isIncome': transaction.isIncome ? 1 : 0,
        'date': transaction.date.millisecondsSinceEpoch,
        'category': transaction.category,
      },
      conflictAlgorithm: sqf.ConflictAlgorithm.replace,
    );
  }

  Future<List<Transaction>> getTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('transactions');
    try {
      return List.generate(maps.length, (i) {
        DateTime transactionDate;
        final dateValue = maps[i]['date'];

        try {
          transactionDate = DateTime.fromMillisecondsSinceEpoch(
              int.parse(dateValue.toString()));
        } catch (e) {
          try {
            transactionDate = DateTime.parse(dateValue.toString());
          } catch (e) {
            throw FormatException(
                'Invalid date format for transaction ${maps[i]['id']}: $dateValue');
          }
        }

        return Transaction(
          id: maps[i]['id'].toString(),
          description: maps[i]['description'],
          amount: maps[i]['amount'],
          isIncome: maps[i]['isIncome'] == 1,
          date: transactionDate,
          category: maps[i]['category'],
        );
      });
    } catch (e, stackTrace) {
      print('Error in getTransactions: $e');
      print(stackTrace);
      throw e;
    }
  }

  Future<void> deleteTransaction(String id) async {
    final db = await database;
    await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllTransactions() async {
    final db = await database;
    await db.delete('transactions');
  }
}
