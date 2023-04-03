import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_article.dart';

class ArticleList extends StatefulWidget {
  const ArticleList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ArticleListState createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  late SharedPreferences _prefs;
  List<dynamic> articles = [];

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _prefs = prefs;
      });
    });
    fetchArticles().then((value) {
      setState(() {
        articles = value;
      });
    });
  }

  Future<List<dynamic>> fetchArticles() async {
    final List<dynamic> articles = await ApiArticle.fetchArticles();
    final List<String> favorites = _prefs.getStringList('favorites') ?? [];
    articles.forEach((article) {
      article['isFavorite'] = favorites.contains(article['id']);
    });
    return articles;
  }

  Future<void> toggleFavorite(int index) async {
    final Article article = Article.fromMap(articles[index]);
    await article.toggleFavorite();
    setState(() {
      articles[index]['isFavorite'] = article.isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: articles.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/detail',
              arguments: articles[index],
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300]!,
                  blurRadius: 3.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(articles[index]['images'][0]),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        articles[index]['title'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        articles[index]['description'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "${articles[index]['price']} €",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[900],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      IconButton(
                        icon: Icon(
                          articles[index]['isFavorite']
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color:
                              articles[index]['isFavorite'] ? Colors.red : null,
                        ),
                        onPressed: () async {
                          await toggleFavorite(index);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Article {
  final String id;
  final String title;
  final String description;
  final List<String> images;
  final double price;

  bool isFavorite;

  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.price,
    required this.isFavorite,
  });

  factory Article.fromMap(Map<String, dynamic> map) {
    final List<String> images = List.castFrom(map['images']);
    return Article(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      images: images,
      price: map['price'].toDouble(),
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  Future<void> toggleFavorite() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList('favorites') ?? [];
    if (isFavorite) {
// Retirer l'article des favoris
      favorites.remove(id);
    } else {
// Ajouter l'article aux favoris
      favorites.add(id);
    }
    await prefs.setStringList('favorites', favorites);
    isFavorite = !isFavorite;
  }
}
