import 'article.dart';

class ArticlePanier {
  final Article article;
  int quantite;

  ArticlePanier({required this.article, this.quantite = 1});

  void incrementQuantity() {
    quantite++;
  }

  void decrementQuantity() {
    if (quantite > 0) {
      quantite--;
    }
  }

}