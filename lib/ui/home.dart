import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sae/api/api_article.dart';
import 'package:sae/models/article.dart';
import 'package:sae/repository/databasehelper.dart';
import 'package:sae/ui/article_detail.dart';
import 'package:sae/ui/panier.dart';
import 'package:sae/view_models/article_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../view_models/utilisateur_view_model.dart';
import 'article_card.dart';
import 'article_liste.dart';
import 'favoris.dart';
import 'login.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late List<Article> articles;
  int _selectedIndex = 0;
  static List<Widget> pages = <Widget>[
    const ArticleList(),
    const FavorisPage(),
    PanierPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil - ${context.read<UserViewModel>().Utilisateur?.name}'),

        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Articles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Favoris',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Panier',
          )
        ]
      ),
    );
  }
}