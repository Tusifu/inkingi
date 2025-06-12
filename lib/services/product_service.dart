import 'package:inkingi/models/product.dart';
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
      version: 4, // Increment version for new products table
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
        await db.execute('''
          CREATE TABLE products (
            id TEXT PRIMARY KEY,
            name TEXT,
            price REAL,
            category TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 4) {
          // Migrate existing data and add products table
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
          await db.execute('''
            CREATE TABLE products (
              id TEXT PRIMARY KEY,
              name TEXT,
              price REAL,
              category TEXT
            )
          ''');
        }
      },
    );
  }

  // Transaction methods (unchanged)
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
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllTransactions() async {
    final db = await database;
    await db.delete('transactions');
  }

  // Product methods
  Future<void> insertProduct(Product product) async {
    final db = await database;
    await db.insert(
      'products',
      {
        'id': product.id,
        'name': product.name,
        'price': product.price,
        'category': product.category,
      },
      conflictAlgorithm: sqf.ConflictAlgorithm.replace,
    );
  }

  Future<List<Product>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) {
      return Product(
        id: maps[i]['id'].toString(),
        name: maps[i]['name'],
        price: maps[i]['price'],
        category: maps[i]['category'],
      );
    });
  }

  Future<void> updateProduct(Product product) async {
    final db = await database;
    await db.update(
      'products',
      {
        'name': product.name,
        'price': product.price,
        'category': product.category,
      },
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<void> deleteProduct(String id) async {
    final db = await database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }
}
