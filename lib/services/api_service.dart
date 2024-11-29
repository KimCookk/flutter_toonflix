import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:toonflix_app/models/webtoon_model.dart';

class ApiService {
  final String baseUrl = "https://webtoon-crawler.nomadcoders.workers.dev";
  final String today = "today";

  Future<List<WebtoonModel>> getTodaysToons() async {
    List<WebtoonModel> webtoonInstances = [];
    final url = Uri.parse('$baseUrl/$today');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(response.body);
      for (var webtoon in webtoons) {
        var webtoonModel = WebtoonModel.fromJson(webtoon);
        webtoonInstances.add(webtoonModel);
      }
      return webtoonInstances;
    }

    throw Error();
  }
}
