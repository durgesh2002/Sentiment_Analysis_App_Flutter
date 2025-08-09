import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  Future<List<String>> fetchTweets(String query) async {
    final response = await http.get(Uri.parse('http://192.168.1.9:8080/tweets?query=$query'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List tweets = data['data'] ?? [];
      return tweets.map<String>((tweet) => tweet['text'].toString()).toList();
    } else {
      throw Exception('Failed to load tweets');
    }
  }
}


