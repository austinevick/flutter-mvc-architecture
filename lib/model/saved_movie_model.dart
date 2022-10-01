class SavedMovieModel {
  final int? id;
  final int? movieId;
  final String? title;
  final String? image;
  final String? overview;
  final String? releaseDate;
  SavedMovieModel({
    this.id,
    this.title,
    this.image,
    this.movieId,
    this.overview,
    this.releaseDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'movieId': movieId,
      'overview': overview,
      'releaseDate': releaseDate,
    };
  }

  factory SavedMovieModel.fromMap(Map<String, dynamic> map) {
    return SavedMovieModel(
      id: map['id'],
      title: map['title'] ?? '',
      image: map['image'],
      movieId: map['movieId'],
      overview: map['overview'] ?? '',
      releaseDate: map['releaseDate'] ?? '',
    );
  }
}
