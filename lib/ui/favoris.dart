import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/article_view_model.dart';
import '../view_models/utilisateur_view_model.dart';
import 'article_card.dart';

class FavorisPage extends StatelessWidget {
  const FavorisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserViewModel>().Utilisateur!;
    final favoris = context.watch<UserViewModel>().Articles ?? [];

    return Scaffold(
      body: favoris.isEmpty
          ? Center(
        child: Text('Aucun favori'),
      )
          : GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        padding: EdgeInsets.all(8.0),
        children: favoris.map((article) {
          return ArticleCard(
            article: article,
            isFavori: true,
          );
        }).toList(),
      ),
    );
  }
}
