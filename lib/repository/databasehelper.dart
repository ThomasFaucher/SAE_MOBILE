import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/article.dart';
import '../models/user.dart';
import '../models/article_panier.dart';

class DatabaseHelper {
  static final _databaseName = 'my_database.db';
  static final _databaseVersion = 1;

  static final userTable = 'User';
  static final columnId = 'id';
  static final columnName = 'name';
  static final columnEmail = 'email';
  static final columnPassword = 'password';

  // La méthode onCreate
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE Article(
            id INTEGER PRIMARY KEY,
            title TEXT,
            price REAL,
            description TEXT,
            category TEXT,
            image TEXT,
            rate REAL,
            count INTEGER
          )
        ''');
    await db.execute('''
        CREATE TABLE $userTable (
          $columnId INTEGER PRIMARY KEY,
          $columnName TEXT NOT NULL,
          $columnEmail TEXT NOT NULL,
          $columnPassword TEXT NOT NULL
        )
      ''');
    await db.execute('''
        CREATE TABLE user_favoris (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          article_id INTEGER NOT NULL,
          FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
          FOREIGN KEY (article_id) REFERENCES articles (id) ON DELETE CASCADE
        )
        ''');
    await db.execute('''
      CREATE TABLE user_panier (
        user_id INTEGER,
        article_id INTEGER NOT NULL,
        quantite INTEGER NOT NULL,
        PRIMARY KEY(user_id, article_id)
      )
    ''');
  }

  Future<Database> _openDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    Database db = await openDatabase(path);
    db = await openDatabase(
      path,
      onCreate: _onCreate,
      version: _databaseVersion,
    );

    return db;
  }


  Future<void> addArticle(Article article) async {
    final db = await _openDatabase();
    final List<Map<String, dynamic>> maxIdResult = await db.rawQuery(
        "SELECT MAX(id) as max_id FROM Article");
    int maxId = maxIdResult.first['max_id'] ?? 0;
    article.setId = maxId+1;
    await db.insert("Article", article.toMap());
  }
  Future<void> updateArticle(Article article) async {
    final db = await _openDatabase();
    await db.update(
      "Article",
      article.toMap(),
      where: '$columnId = ?',
      whereArgs: [article.id],
    );
  }

  Future<void> deleteArticle(Article user) async {
    final db = await _openDatabase();
    await db.delete(
      "Article",
      where: '$columnId = ?',
      whereArgs: [user.id],
    );
  }

  Future<List<Article>> getArticles() async {
    final db = await _openDatabase();
    final List<Map<String, dynamic>> maps = await db.query("Article");
    return List.generate(maps.length, (i) => Article.fromJson(maps[i]));

  }

  Future<void> addUser(User user) async {
    final db = await _openDatabase();

    // Récupérer l'ID maximum dans la table users
    final List<Map<String, dynamic>> maxIdResult = await db.rawQuery(
        "SELECT MAX(id) as max_id FROM $userTable");
    int maxId = maxIdResult.first['max_id'] ?? 0;

    // Affecter un nouvel ID à l'utilisateur qui sera ajouté
    

    // Insérer l'utilisateur dans la base de données
    await db.insert(userTable, user.toMap()).then((value) => user.id = maxId);
  }

  Future<void> addPanier(int userId, int articleId, int quantity) async {
    final db = await _openDatabase();
    await db.insert(
      'user_panier',
      {
        'user_id': userId,
        'article_id': articleId,
        'quantite': quantity,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    getPanier(userId).then((value) => debugPrint(value.toString()));
  }

  Future<void> removePanier(int userId, int articleId) async {
    final db = await _openDatabase();
    await db.delete(
      'user_panier',
      where: 'user_id = ? AND article_id = ?',
      whereArgs: [userId, articleId],
    );
  }
  Future<void> updateArticlePanier(ArticlePanier panier,int user_id) async {
    final db = await _openDatabase();

    await db.update(
      "user_panier",
      {'quantite': panier.quantite},
      where: 'user_id = ? AND article_id = ?',
      whereArgs: [user_id, panier.article.id],
    );
  }
  Future<void> updateUser(User user) async {
    final db = await _openDatabase();
    await db.update(
      userTable,
      user.toMap(),
      where: '$columnId = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(User user) async {
    final db = await _openDatabase();
    await db.delete(
      userTable,
      where: '$columnId = ?',
      whereArgs: [user.id],
    );
  }

  Future<List<User>> getUsers() async {
    final db = await _openDatabase();
    final List<Map<String, dynamic>> maps = await db.query(userTable);
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i][columnId],
        name: maps[i][columnName],
        email: maps[i][columnEmail],
        password: maps[i][columnPassword],
      );
    });

  }
  Future<void> toggleFavoris(int userId, int articleId) async {
    bool isFavori = await this.isFavori(userId, articleId);
    if (isFavori) {
      await this.deleteFavoris(userId, articleId);
    } else {
      final db = await _openDatabase();
      await db.insert(
        'user_favoris',
        {
          'user_id': userId,
          'article_id': articleId,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

  }

  Future<void> deleteFavoris(int userId, int articleId) async {
    final db = await _openDatabase();
    await db.delete(
      'user_favoris',
      where: 'user_id = ? AND article_id = ?',
      whereArgs: [userId, articleId],
    );
  }

  Future<List<Article>> getFavoris(int userId) async {
    final db = await _openDatabase();
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT a.*
      FROM Article a
      JOIN user_favoris uf ON uf.article_id = a.id
      WHERE uf.user_id = ?
    ''', [userId]);

    debugPrint("Favoris chargé ");

    return List.generate(maps.length, (i) {
      return Article(
        id: maps[i]['id'],
        title: maps[i]['title'],
        price: maps[i]['price'],
        description: maps[i]['description'],
        category: maps[i]['category'],
        image: maps[i]['image'],
        rate: maps[i]['rate'],
        count: maps[i]['count'],
      );
    });
  }
  Future<bool> isFavori(int userId, int articleId) async {
    final db = await _openDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'user_favoris',
      where: 'user_id = ? AND article_id = ?',
      whereArgs: [userId, articleId],
      limit: 1,
    );
    return maps.isNotEmpty;
  }
  Future<bool> isInPanier(int userId, int articleId) async {
    final db = await _openDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'user_panier',
      where: 'user_id = ? AND article_id = ?',
      whereArgs: [userId, articleId],
      limit: 1,
    );
    return maps.isNotEmpty;
  }
  Future<void> clearPanier(int userId) async {
    final db = await _openDatabase();
    await db.delete(
      'user_panier',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

    Future<Article?> getArticle(int id) async {
      final db = await _openDatabase();
      final maps = await db.query('Article', where: 'id = ?', whereArgs: [id]);
      if (maps.isNotEmpty) {
        return Article.fromMap(maps.first);
      }
      return null;
    }
  Future<List<ArticlePanier>> getPanier(int userId) async {
    final db = await _openDatabase();
    final res = await db.query(
      'user_panier',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    final List<ArticlePanier> articlesPanier = [];
    for (final panier in res) {
      final article = await getArticle(int.parse(panier['article_id'].toString()));
      articlesPanier.add(ArticlePanier(article: article!, quantite: int.parse(panier['quantite'].toString())));
    }
    debugPrint("Panier : " + articlesPanier.toString());
    return articlesPanier;
  }


}