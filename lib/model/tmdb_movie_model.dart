class TMDBMovieResponseModel {
  List<TMDBMovieResponseData>? results;

  TMDBMovieResponseModel({this.results});

  TMDBMovieResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <TMDBMovieResponseData>[];
      json['results'].forEach((v) {
        results!.add(TMDBMovieResponseData.fromJson(v));
      });
    }
  }
}

class TMDBMovieResponseData {
  bool? adult;
  String? backdropPath;
  List<dynamic>? genres;
  int? id;
  String? originalLanguage;
  String? originalTitle;
  String? overview;
  String? homepage;
  double? popularity;
  String? posterPath;
  String? releaseDate;
  String? title;
  bool? video;
  num? voteAverage;
  int? voteCount;

  TMDBMovieResponseData(
      {this.adult,
      this.backdropPath,
      this.genres,
      this.id,
      this.originalLanguage,
      this.originalTitle,
      this.overview,
      this.popularity,
      this.posterPath,
      this.homepage,
      this.releaseDate,
      this.title,
      this.video,
      this.voteAverage,
      this.voteCount});

  TMDBMovieResponseData.fromJson(Map<String, dynamic> json) {
    adult = json['adult'];
    backdropPath = json['backdrop_path'];
    genres = json['genres'];
    id = json['id'];
    homepage = json['homepage'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    overview = json['overview'];
    popularity = json['popularity'];
    posterPath = json['poster_path'] ?? '';
    releaseDate = json['release_date'];
    title = json['title'];
    video = json['video'];
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
  }
}
