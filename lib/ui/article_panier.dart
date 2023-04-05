import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sae/ui/article_panier.dart';
import 'package:sae/view_models/utilisateur_view_model.dart';

import '../models/article_panier.dart';

class ArticlePanierWidget extends StatefulWidget {
  final ArticlePanier articlePanier;

  const ArticlePanierWidget({
    Key? key,
    required this.articlePanier,
  }) : super(key: key);

  @override
  ArticlePanierWidgetState createState() => ArticlePanierWidgetState();
}

class ArticlePanierWidgetState extends State<ArticlePanierWidget> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.articlePanier.quantite;
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = context.watch<UserViewModel>();

    final panierArticle =
    userViewModel.getArticlePanier(widget.articlePanier.article.id);

    return ListTile(
      leading: Image.network(widget.articlePanier.article.image),
      title: Text(widget.articlePanier.article.title),
      subtitle: Row(
        children: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              if (_quantity <= 1) {
                userViewModel.removeArticlePanier(widget.articlePanier.article.id);
              }
              setState(() {
                if (_quantity > 0) {
                  _quantity--;
                  widget.articlePanier.decrementQuantity();
                  if (panierArticle != null) {
                    panierArticle.decrementQuantity();
                  }
                }
              });
            },
          ),
          Text(_quantity.toString()),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                _quantity++;
                widget.articlePanier.incrementQuantity();
                if (panierArticle != null) {
                  panierArticle.incrementQuantity();
                }
              });
            },
          ),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          userViewModel.removeArticlePanier(widget.articlePanier.article.id);
          setState(() {});
        },
      ),
    );
  }
}