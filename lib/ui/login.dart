import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../repository/databasehelper.dart';
import '../view_models/utilisateur_view_model.dart';
import 'home.dart';
import 'inscription.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _onFormSubmitted() async {
    if (_formKey.currentState!.validate()) {
      // Vérifiez l'authentification de l'utilisateur ici
      final email = _emailController.text;
      final password = _passwordController.text;
      final users = await DatabaseHelper().getUsers();
      User? user;

      // Vérifiez si l'utilisateur existe dans la base de données
      for (final u in users) {
        if (u.email == email && u.password == password) {
          user = u;
          break;
        }
      }

      if (user != null) {
        context.read<UserViewModel>().Panier = [];
        context.read<UserViewModel>().Favoris= [];
        context.read<UserViewModel>().User = user;
        await Future.wait([
          context.read<UserViewModel>().chargeFavoris(),
          context.read<UserViewModel>().chargePanier()
        ]);
        debugPrint(context.read<UserViewModel>().Articles.toString());
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ),
          );
        // Connectez l'utilisateur et redirigez-le vers la page d'accueil

      } else {
        // Affichez un message d'erreur si l'utilisateur n'existe pas
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Identifiants incorrects'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Se connecter'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer votre adresse email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer votre mot de passe';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _onFormSubmitted,
                child: Text('Se connecter'),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpPage(),
                    ),
                  );
                },
                child: Text(
                  'Pas encore inscrit ? Cliquez ici pour vous inscrire.',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
