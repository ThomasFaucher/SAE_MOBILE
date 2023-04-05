import 'package:flutter/material.dart';
import 'package:sae/models/article.dart';

class ArticleDetail extends StatelessWidget {
  final Article article;

  const ArticleDetail({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: Image.network(
              article.image,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 16),
          Text(
            article.title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            '${article.price} €',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            article.description,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}