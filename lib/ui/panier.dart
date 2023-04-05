import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sae/ui/article_panier.dart';
import 'package:sae/view_models/utilisateur_view_model.dart';

class PanierPage extends StatefulWidget {
  @override
  _PanierPageState createState() => _PanierPageState();
}

class _PanierPageState extends State<PanierPage> {
  @override
  Widget build(BuildContext context) {
    final userViewModel = context.read<UserViewModel>();

    return Scaffold(
        body: Consumer<UserViewModel>(
        builder: (context, userViewModel, child) {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: userViewModel.Panier.length,
              itemBuilder: (BuildContext context, int index) {
                final articlePanier = userViewModel.Panier[index];

                return ArticlePanierWidget(
                  articlePanier: articlePanier,
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                userViewModel.clearPanier();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Commande payée'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                  margin: EdgeInsets.fromLTRB(16, 0, 16, 30),
                  backgroundColor: Colors.green
                ),
              );
            },
            child: Text('Commander'),
          ),
        ],
      );
        },
        ),
    );
  }
}
