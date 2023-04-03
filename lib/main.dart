import 'package:flutter/material.dart';
import 'article_detail.dart';
import 'article_liste.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => Scaffold(
              appBar: AppBar(
                title: const Text('Liste des articles'),
              ),
              body: const ArticleList(),
            ),
        '/detail': (context) => const ArticleDetail(
              article: null,
            ),
      },
    );
  }
}
