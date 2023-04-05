import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sae/models/article_panier.dart';

import '../models/article.dart';
import '../repository/databasehelper.dart';
import '../view_models/utilisateur_view_model.dart';
import 'article_detail.dart';

class ArticleCard extends StatefulWidget {
  final Article article;
  final bool isFavori;
  final bool isInCart;

  const ArticleCard({Key? key, required this.article, this.isFavori = false,this.isInCart = false})
      : super(key: key);

  @override
  _ArticleCardState createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  bool _isFavori = false;
  bool _isInCart = false;

  @override
  void initState() {
    super.initState();
    _isFavori = widget.isFavori;
    _isInCart = widget.isInCart;
  }

  @override
  Widget build(BuildContext context) {
    final dbHelper = DatabaseHelper();
    final user = context
        .read<UserViewModel>()
        .Utilisateur!;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetail(article: widget.article),
          ),
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 4,
                child: Image.network(
                  widget.article.image,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.article.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '${widget.article.price} €',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[900],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          _isFavori ? Icons.favorite : Icons.favorite_border,
                          color: _isFavori ? Colors.red : null,
                        ),
                        onPressed: () async {
                          await dbHelper.toggleFavoris(
                              user.id, widget.article.id);

                          setState(() {
                            _isFavori = !_isFavori;
                            if (_isFavori) {
                              context
                                  .read<UserViewModel>()
                                  .Articles
                                  .add(widget.article);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Article ajouté aux favoris'),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 2),
                                  margin: EdgeInsets.fromLTRB(16, 0, 16, 30),
                                  backgroundColor: Colors.green[300],
                                ),
                              );
                            } else {
                              context
                                  .read<UserViewModel>()
                                  .Articles
                                  .remove(widget.article);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Article retiré des favoris'),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 2),
                                  margin: EdgeInsets.fromLTRB(16, 0, 16, 30),
                                  backgroundColor: Colors.red[200],
                                ),
                              );
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          _isInCart ? Icons.shopping_cart : Icons
                              .add_shopping_cart,
                          color: _isInCart ? Colors.orange[900] : null,
                        ),
                        onPressed: () {
                          setState(() {
                            ArticlePanier article = context
                                .read<UserViewModel>()
                                .addArticlePanier(widget.article);
                            if (article.quantite > 1) {


                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Quanité ajoutée au panier'),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 2),
                                  margin: EdgeInsets.fromLTRB(16, 0, 16, 30),
                                  backgroundColor:  Colors.green[300],
                                ),
                              );

                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Article ajouté au panier'),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 2),
                                  margin: EdgeInsets.fromLTRB(16, 0, 16, 30),
                                  backgroundColor: Colors.green[300],
                                ),
                              );

                            }

                            _isInCart = true;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
