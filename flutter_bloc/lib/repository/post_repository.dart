import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blocs/models/post_model.dart';
import 'package:http/http.dart' as http;

class PostRepository {
  Future<List<PostModel>> fetchPost() async {
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/comments'),
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as List;
        return body.map((e) => PostModel.fromJson(e)).toList();
      }
      return [];
    } on SocketException {
      throw Exception('Error due to socket: ');
    } on TimeoutException {
      throw Exception('Error due to timeout');
    } catch (e) {
      debugPrint('Errror fethcing post: $e');
      rethrow;
    }
  }
}
