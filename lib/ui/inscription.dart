import 'package:flutter/material.dart';
import '../models/user.dart';
import '../repository/databasehelper.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameSignupController = TextEditingController();
  final _emailSignupController = TextEditingController();
  final _passwordSignupController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('S\'inscrire'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _nameSignupController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailSignupController,
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
                controller: _passwordSignupController,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer un mot de passe';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Confirmer le mot de passe',
                ),
                obscureText: true,
                validator: (value) {
                  if (value != _passwordSignupController.text) {
                    return 'Les mots de passe ne correspondent pas';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    DatabaseHelper dbHelper = DatabaseHelper();
                    dbHelper.addUser(User.newUser(
                      _nameSignupController.text,
                      _emailSignupController.text,
                      _passwordSignupController.text,
                    ));
                    Navigator.pop(context);
                  }
                },
                child: Text('S\'inscrire'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
