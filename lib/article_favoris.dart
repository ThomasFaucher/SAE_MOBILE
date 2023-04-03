import 'package:flutter/material.dart';
import 'package:sae/api_article.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesList extends StatefulWidget {
  const FavoritesList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FavoritesListState createState() => _FavoritesListState();
}

class _FavoritesListState extends State<FavoritesList> {
  List<dynamic> favorites = [];
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    fetchFavorites().then((value) {
      setState(() {
        favorites = value;
      });
    });
  }

  Future<List<dynamic>> fetchFavorites() async {
    final List<dynamic> articles = await ApiArticle.fetchArticles();
    final List<String> favorites = _prefs.getStringList('favorites') ?? [];
    return articles
        .where((article) => favorites.contains(article['id']))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favories'),
      ),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Image.network(favorites[index]['images'][0]),
            title: Text(favorites[index]['title']),
            subtitle: Text("${favorites[index]['price']} €"),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/detail',
                arguments: favorites[index],
              );
            },
          );
        },
      ),
    );
  }
}
