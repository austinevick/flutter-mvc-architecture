import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:movie_search_app/model/yts_movie_model.dart';
import '../apikey.dart';
import '../common/api.dart';
import '../model/tmdb_movie_model.dart';

final movieRepositoryProvider =
    Provider((ref) => RemoteMovieRepositoryServiceImpl(Client()));

abstract class RemoteMovieRepositoryService {
  Future searchTMDBMoviesByTitle(String name);
  Future searchYTSMoviesByTitle(String name);
  Future getYTSMovies();
  Future getTMDBMovies();
  Future getYTSMovieDetailsById(String id);
  Future getTMDBMovieDetailsById(String id);
}

class RemoteMovieRepositoryServiceImpl implements RemoteMovieRepositoryService {
  final Client client;
  RemoteMovieRepositoryServiceImpl(this.client);

  @override
  Future<TMDBMovieResponseModel> searchTMDBMoviesByTitle(String name) async {
    final response = await client.get(Uri.parse(
        "${baseUrlForTMDBMovies}search/movie?api_key=$apikey&query=$name"));
    final data = jsonDecode(response.body);
    print(data);
    return TMDBMovieResponseModel.fromJson(data);
  }

  @override
  Future<List<TMDBMovieResponseData>?> getTMDBMovies() async {
    final response = await client.get(
        Uri.parse("${baseUrlForTMDBMovies}trending/movie/day?api_key=$apikey"));
    final data = jsonDecode(response.body);
    print(data);
    return TMDBMovieResponseModel.fromJson(data).results;
  }

  @override
  Future<TMDBMovieResponseData> getTMDBMovieDetailsById(String id) async {
    final response = await client
        .get(Uri.parse("${baseUrlForTMDBMovies}movie/$id?api_key=$apikey"));
    final data = jsonDecode(response.body);
    print(data);
    return TMDBMovieResponseData.fromJson(data);
  }

  @override
  Future<List<YTSMoviesResponseModel>> getYTSMovies() async {
    final response =
        await client.get(Uri.parse("$baseUrlForYTSMovies?quality=3D"));
    final data = jsonDecode(response.body);
    Iterable movies = data['data']['movies'];
    print(movies);
    return movies.map((e) => YTSMoviesResponseModel.fromJson(e)).toList();
  }

  @override
  Future<YTSMoviesResponseModel> getYTSMovieDetailsById(String id) async {
    final response =
        await client.get(Uri.parse("$baseUrlForTMDBMovies/?movie_id=$id"));
    final data = jsonDecode(response.body);
    print(data);
    return YTSMoviesResponseModel.fromJson(data);
  }

  @override
  Future<List<YTSMoviesResponseModel>> searchYTSMoviesByTitle(
      String name) async {
    final response =
        await client.get(Uri.parse("$baseUrlForYTSMovies?query_term=$name"));
    final data = jsonDecode(response.body);
    print(data);
    Iterable movies = data['data']['movies'];
    print(movies);
    return movies.map((e) => YTSMoviesResponseModel.fromJson(e)).toList();
  }
}
