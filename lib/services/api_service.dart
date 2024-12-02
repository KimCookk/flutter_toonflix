import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:toonflix_app/models/episode_model.dart';
import 'package:toonflix_app/models/webtoon_model.dart';
import 'package:toonflix_app/models/webtoon_detail_model.dart';

class ApiService {
  final String baseUrl = "https://webtoon-crawler.nomadcoders.workers.dev";
  final String today = "today";
  final String episodes = "episodes";

  Future<List<WebtoonModel>> getTodaysToons() async {
    List<WebtoonModel> webtoonInstances = [];
    final url = Uri.parse('$baseUrl/$today');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(response.body);
      for (var webtoon in webtoons) {
        var webtoonModel = WebtoonModel.fromJson(webtoon);
        print(webtoonModel.id);
        webtoonInstances.add(webtoonModel);
      }

      return webtoonInstances;
    }
    throw Error();
  }

  Future<WebtoonDetailModel> getWebToonDetailById(String id) async {
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      WebtoonDetailModel webtoonDetailModel =
          WebtoonDetailModel.fromJson(jsonDecode(response.body));

      return webtoonDetailModel;
    } else {
      throw Error();
    }
  }

  Future<List<EpisodeModel>> getEpisodesById(String id) async {
    List<EpisodeModel> episodeInstances = [];
    final url = Uri.parse('$baseUrl/$id/$episodes');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> episodes = jsonDecode(response.body);
      for (var episode in episodes) {
        EpisodeModel episodeModel = EpisodeModel.fromJson(episode);
        episodeInstances.add(episodeModel);
      }

      return episodeInstances;
    } else {
      throw Error();
    }
  }
}
