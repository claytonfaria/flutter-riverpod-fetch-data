import 'dart:convert' as convert;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final postsStateFuture = FutureProvider<List<Post>>((ref) async {
  return fetchPosts();
});

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post(this.userId, this.body, this.id, this.title);

  Post.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        id = json['id'],
        title = json['title'],
        body = json['body'];

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'id': id,
        'title': title,
        'body': body,
      };
}

Future<List<Post>> fetchPosts() async {
  var url = Uri.https('jsonplaceholder.typicode.com', '/posts');

  var response = await http.get(url);
  if (response.statusCode == 200) {
    var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;

    return jsonResponse.map((json) => Post.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load post');
  }
}
