class WebtoonDetailModel {
  String? title;
  String? about;
  String? genre;
  String? age;
  String? thumb;

  WebtoonDetailModel({
    this.title,
    this.about,
    this.genre,
    this.age,
    this.thumb,
  });

  factory WebtoonDetailModel.fromJson(Map<String, dynamic> json) {
    return WebtoonDetailModel(
      title: json['title'] as String?,
      about: json['about'] as String?,
      genre: json['genre'] as String?,
      age: json['age'] as String?,
      thumb: json['thumb'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'about': about,
        'genre': genre,
        'age': age,
        'thumb': thumb,
      };
}
