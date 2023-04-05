import 'package:flutter/material.dart';
import 'package:sae/api/api_article.dart';
import '../models/article.dart';
import '../repository/databasehelper.dart';

class ArticleViewModel extends ChangeNotifier {
  late List<Article> liste = []; // late permet de ne pas initialiser la variable
  final DatabaseHelper dbHelper = DatabaseHelper();
  ArticleViewModel() {
    chargeArticle().then((value) => liste = value);
  }

  List<Article> get ListeArticle => liste;

  void addArticle(Article article) async {
    await DatabaseHelper().addArticle(article);
    liste.add(article);
    notifyListeners(); // permet de notifier les listeners
  }

  Future<List<Article>> chargeArticle() async{
    liste = await DatabaseHelper().getArticles();
    if(liste.isEmpty){
      chargeDataApi();
    }
    notifyListeners();
    return liste;
  }

  void deleteArticle(Article article) {
    liste.remove(article);
    DatabaseHelper().deleteArticle(article);
    notifyListeners();
  }
  Future<void> chargeDataApi() async {
    var articleList = await ApiArticle.fetchArticles();
    for (var article in articleList) {
      await dbHelper.addArticle(article);
    }
    liste = await DatabaseHelper().getArticles();

  }
  void updateArticle(Article article) {
    final index = liste.indexWhere((t) => t.id == article.id);
    DatabaseHelper().updateArticle(article);
    if (index >= 0) {
      liste[index] = article;
      notifyListeners();
    }
  }

  Future<void> toggleFavoris(int userId, int articleId) async {
    await DatabaseHelper().toggleFavoris(userId, articleId);
    DatabaseHelper().isFavori(userId, articleId).then((value) {
      bool isFavori = value as bool;
      debugPrint('Favori: $isFavori');
    });
    notifyListeners();
  }

  Future<void> removeFavoris(int userId, int articleId) async {
    await DatabaseHelper().deleteFavoris(userId, articleId);
    notifyListeners();
  }

}
