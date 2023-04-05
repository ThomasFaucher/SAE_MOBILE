import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sae/models/article.dart';

class ApiArticle {
  static Future<List<dynamic>> fetchArticles() async {
    final response = await http.get(
      Uri.parse('https://fakestoreapi.com/products'),
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers':
            'Origin, Content-Type, X-Auth-Token, Authorization',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((articleData) => Article.fromJsonAPI(articleData)).toList();
    } else {
      throw Exception('Failed to fetch articles');
    }
  }
}
