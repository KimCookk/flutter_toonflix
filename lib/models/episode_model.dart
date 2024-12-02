class EpisodeModel {
  String? thumb;
  String? id;
  String? title;
  String? rating;
  String? date;

  EpisodeModel({this.thumb, this.id, this.title, this.rating, this.date});

  factory EpisodeModel.fromJson(Map<String, dynamic> json) => EpisodeModel(
        thumb: json['thumb'] as String?,
        id: json['id'] as String?,
        title: json['title'] as String?,
        rating: json['rating'] as String?,
        date: json['date'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'thumb': thumb,
        'id': id,
        'title': title,
        'rating': rating,
        'date': date,
      };
}
