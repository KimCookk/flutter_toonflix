class WebtoonDetailModel {
  final String? title, about, genre, age, thumb;

  //String get genre
  WebtoonDetailModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        about = json['about'],
        genre = json['genre'],
        age = json['age'],
        thumb = json['thumb'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'about': about,
        'genre': genre,
        'age': age,
        'thumb': thumb,
      };
}
