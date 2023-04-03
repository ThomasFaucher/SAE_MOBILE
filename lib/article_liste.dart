import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'api.dart';

class ArticleList extends StatefulWidget {
  const ArticleList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ArticleListState createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  List<dynamic> articles = [];

  @override
  void initState() {
    super.initState();
    fetchArticles().then((value) {
      setState(() {
        articles = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(articles[index]['title']),
          subtitle: Text(articles[index]['description']),
          onTap: () {
            // TODO: Naviguer vers la fiche de l'article sélectionné
          },
        );
      },
    );
  }
}
