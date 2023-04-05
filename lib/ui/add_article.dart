import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sae/models/article.dart';
import 'package:sae/view_models/article_view_model.dart';

class NewArticlePage extends StatefulWidget {
  const NewArticlePage({Key? key}) : super(key: key);

  @override
  _NewArticlePageState createState() => _NewArticlePageState();
}

class _NewArticlePageState extends State<NewArticlePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _imageController = TextEditingController();
  final _rateController = TextEditingController();
  final _countController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Nouvel article'),
        ),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
    child: Form(
    key: _formKey,
    child: ListView(
    children: [
    TextFormField(
    controller: _titleController,
    decoration: InputDecoration(
    labelText: 'Titre',
    ),
    validator: (value) {
    if (value!.isEmpty) {
    return 'Veuillez entrer un titre';
    }
    return null;
    },
    ),
    TextFormField(
    controller: _priceController,
    decoration: InputDecoration(
    labelText: 'Prix',
    ),
    validator: (value) {
    if (value!.isEmpty) {
    return 'Veuillez entrer un prix';
    } else if (double.tryParse(value) == null) {
    return 'Veuillez entrer un prix valide';
    }
    return null;
    },
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    ),
    TextFormField(
    controller: _descriptionController,
    decoration: InputDecoration(
    labelText: 'Description',
    ),
    validator: (value) {
    if (value!.isEmpty) {
    return 'Veuillez entrer une description';
    }
    return null;
    },
    ),
    TextFormField(
    controller: _categoryController,
    decoration: InputDecoration(
    labelText: 'Catégorie',
    ),
    validator: (value) {
    if (value!.isEmpty) {
    return 'Veuillez entrer une catégorie';
    }
    return null;
    },
    ),
    TextFormField(
    controller: _imageController,
    decoration: InputDecoration(
    labelText: 'Image',
    ),
    validator: (value) {
    if (value!.isEmpty) {
    return 'Veuillez entrer une image';
    }
    return null;
    },
    ),
    TextFormField(
    controller: _rateController,
    decoration: InputDecoration(
    labelText: 'Note',
    ),
    validator: (value) {
    if (value!.isEmpty) {
    return 'Veuillez entrer une note';
    } else if (double.tryParse(value) == null) {
    return 'Veuillez entrer une note valide';
    }
    return null;
    },
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    ),
    TextFormField(
    controller: _countController,
    decoration: InputDecoration(
    labelText: 'Quantité',
    ),
    validator: (value) {
    if (value!.isEmpty) {
    return 'Veuillez entrer une quantité';
    } else if (int.tryParse(value) == null) {
    return 'Veuillez entrer une quantité valide';
    }
    return null;
    },
    keyboardType: TextInputType.number,
    ),
    SizedBox(height: 16),
    ElevatedButton(
    onPressed: () {
    if (_formKey.currentState!.validate()) {
      context.read<ArticleViewModel>().addArticle(Article.newArticle(
          _titleController.text,
          double.parse(_priceController.text),
          _descriptionController.text,
           _categoryController.text,
           _imageController.text,
           double.parse(_rateController.text),
           int.parse(_countController.text)));


      ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         content: Text('Nouvel article ajouté avec succès'),
       ),
     );
     Navigator.of(context).pop();
    }
    },
      child: Text('Ajouter'),
    ),
    ],
    ),
    ),
        ),
    );
  }
}