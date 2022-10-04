
class SearchHistoryModel {
  final int? id;
  final int? movieId;
  final String? title;
  final String? image;
  final String? overview;
  final String? releaseDate;
  SearchHistoryModel({
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

  factory SearchHistoryModel.fromMap(Map<String, dynamic> map) {
    return SearchHistoryModel(
      id: map['id'],
      title: map['title'] ?? '',
      image: map['image'],
      movieId: map['movieId'],
      overview: map['overview'] ?? '',
      releaseDate: map['releaseDate'] ?? '',
    );
  }
}
