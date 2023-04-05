import 'package:flutter/material.dart';
import 'package:sae/models/article.dart';
import 'package:sae/repository/databasehelper.dart';
import '../models/user.dart' as myUser;
import '../repository/user_repository.dart';
import '../models/article_panier.dart';
import 'article_view_model.dart';

class UserViewModel extends ChangeNotifier {


  late UserRepository _UserRepository;
  myUser.User? _User;
  List<Article> _favoris = [];
  List<ArticlePanier> _panier = [];

  myUser.User? get Utilisateur => _User;

  List<Article> get Articles => _favoris;

  List<ArticlePanier> get Panier => _panier;

  UserViewModel() {
    _User = null;
    _UserRepository = UserRepository();
    getUser();
  }

  set User(myUser.User value) {
    _User = value;
    _UserRepository.saveUser(_User!);
  }

  set Panier(List<ArticlePanier> value) {
    _panier = value;

  }

  set Favoris(List<Article> value) {
    _favoris = value;
  }

  void removeArticlePanier(int articleId) {

    final index = _panier.indexWhere((element) => element.article.id == articleId);

    if (index >= 0) {
      _panier.removeAt(index);
      DatabaseHelper().removePanier(_User!.id, articleId);
      notifyListeners();
    }
  }

  getUser() async {
    _User = await _UserRepository.getUser();
    notifyListeners();
  }

  Future<void> chargeFavoris() async {
    if (_User != null) {
      DatabaseHelper().getFavoris(_User!.id).then((value) =>
      _favoris = value);
    }
    notifyListeners();
  }
  Future<void> chargePanier() async {
    if (_User != null) {
      DatabaseHelper().getPanier(_User!.id).then((value) =>
      _panier = value);
    }
    notifyListeners();
  }

  bool containsArticle(int articleId) {
    for (var articlePanier in _panier) {
      if (articlePanier.article.id == articleId) {
        return true;
      }
    }
    return false;
  }

  Future<void> loadUserData() async {
    final user = await _UserRepository.getUser();
    _User = user;
    await chargeFavoris();
    await chargePanier();
  }


  ArticlePanier? getArticlePanier(int articleId) {
    final index = _panier.indexWhere((element) =>
    element.article.id == articleId);
    return index != -1 ? _panier[index] : null;
  }

  ArticlePanier addArticlePanier(Article article) {
    final index = _panier.indexWhere((element) =>
    element.article.id == article.id);

    if (index == -1) {
      // L'article n'est pas encore dans le panier
      _panier.add(ArticlePanier(article: article));
      DatabaseHelper().addPanier(_User!.id, article.id, 1);
      return ArticlePanier(article: article);
    } else {
      // L'article est déjà dans le panier, on incrémente sa quantité
      _panier[index].incrementQuantity();
      DatabaseHelper().updateArticlePanier(_panier[index],_User!.id);
      return _panier[index];

    }

    notifyListeners();
  }

  void clearPanier() {
    Panier.clear();
    DatabaseHelper().clearPanier(_User!.id);
  }


}
