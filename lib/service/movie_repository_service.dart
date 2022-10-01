import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../apikey.dart';
import '../common/api.dart';
import '../model/movie_model.dart';

final movieRepositoryProvider =
    Provider((ref) => MovieRepositoryServiceImpl(Client()));

abstract class MovieRepositoryService {
  Future searchMovieByTitle(String name);
}

class MovieRepositoryServiceImpl implements MovieRepositoryService {
  final Client client;

  MovieRepositoryServiceImpl(this.client);

  @override
  Future<MovieResponseModel> searchMovieByTitle(String name) async {
    final response =
        await client.get(Uri.parse("$baseUrl?api_key=$apikey&query=$name"));
    final data = jsonDecode(response.body);
    print(data);
    return MovieResponseModel.fromJson(data);
  }
}
