import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sae/api/api_article.dart';
import 'package:sae/models/article.dart';
import 'package:sae/repository/databasehelper.dart';
import 'package:sae/ui/article_detail.dart';
import 'package:sae/view_models/article_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../view_models/utilisateur_view_model.dart';
import 'add_article.dart';
import 'article_card.dart';

class ArticleList extends StatefulWidget {
  const ArticleList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ArticleListState createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {


  @override
  Widget build(BuildContext context) {
    final user = context
        .read<UserViewModel>()
        .Utilisateur!;

    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        padding: EdgeInsets.all(8.0),
        children: context
            .watch<ArticleViewModel>()
            .ListeArticle
            .map((article) {
          return FutureBuilder<bool>(
            future: DatabaseHelper().isInPanier(
                user.id, article.id),
            builder: (context, panierSnapshot) {
              if (panierSnapshot.connectionState == ConnectionState.done) {
                if (panierSnapshot.hasError) {
                  return Text('Erreur');
                } else {
                  return FutureBuilder<bool>(
                    future: DatabaseHelper().isFavori(user.id,article.id),
                    builder: (context, favSnapshot) {
                      if (favSnapshot.connectionState == ConnectionState.done) {
                        if (favSnapshot.hasError) {
                          return Text('Erreur');
                        } else {
                          return ArticleCard(
                            article: article,
                            isFavori: favSnapshot.data!,
                            isInCart: panierSnapshot.data!,
                          );
                        }
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  );
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          );
        }).toList(),
      ), floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewArticlePage(),
          ),
        );
      },
    child: Icon(Icons.add),
    ));
  }
}