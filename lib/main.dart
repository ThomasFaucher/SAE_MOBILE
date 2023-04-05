import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sae/theme/theme.dart';
import 'package:sae/ui/home.dart';
import 'package:sae/ui/login.dart';
import 'package:sae/view_models/article_view_model.dart';
import 'package:sae/view_models/utilisateur_view_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MultiProvider(
        providers: [
        ChangeNotifierProvider(
          create: (_)
    {
      ArticleViewModel articleViewModel = ArticleViewModel();
      return articleViewModel;
    }),
    ChangeNotifierProvider(
    create: (_)
    {
    UserViewModel userViewModel = UserViewModel();
    userViewModel.loadUserData();
    return userViewModel;

    },
    )],
      child: Consumer<UserViewModel>(
        builder: (context,UserViewModel notifier,child){
          return MaterialApp(
              title: 'Boutique en ligne',
            theme: theme,
            home: notifier.Utilisateur == null ? LoginPage() : Home()
          );
        },
      ),
    );
  }
}

/*


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
 */