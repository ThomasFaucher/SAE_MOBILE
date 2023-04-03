import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiArticle {
  static Future<List<dynamic>> fetchArticles() async {
    final response = await http.get(
      Uri.parse('https://api.escuelajs.co/api/v1/products'),
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers':
            'Origin, Content-Type, X-Auth-Token, Authorization',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch articles');
    }
  }
}
