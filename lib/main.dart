import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/post.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Working With API",
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  Future<List<Post>> fetchPosts() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode == 200) {
      List<Post> myPosts = [];
      var data = jsonDecode(response.body);
      for (Map i in data) {
        myPosts.add(Post.fromMap(i as Map<String, dynamic>));
      }
      return myPosts;
    } else {
      throw Exception('Failed to load album');
    }
  }

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get Data From API"),
      ),
      body: FutureBuilder<List<Post>>(
          future: fetchPosts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (contxt, index) {
                  return MyBox(snapshot.data![index]);
                },
              );
            }
            return CircularProgressIndicator();
          }),
    );
  }
}

class MyBox extends StatelessWidget {
  final Post p;
  MyBox(this.p);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(p.title),
      subtitle: Text(p.body),
    );
  }
}
