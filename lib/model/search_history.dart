class SearchHistoryModel {
  final int? id;
  final String? title;
  final String? image;
  SearchHistoryModel({
    this.id,
    this.image,
    this.title,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'image': image};
  }

  factory SearchHistoryModel.fromMap(Map<String, dynamic> map) {
    return SearchHistoryModel(
        id: map['id'], title: map['title'], image: map['image']);
  }
}
