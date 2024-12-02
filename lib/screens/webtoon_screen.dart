import 'package:flutter/material.dart';
import 'package:toonflix_app/models/webtoon_detail_model.dart';
import 'package:toonflix_app/services/api_service.dart';
import 'package:toonflix_app/models/episode_model.dart';

class WebtoonScreen extends StatelessWidget {
  final String title, thumb, id;
  final ApiService apiService = ApiService();
  WebtoonScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });
  late final Future<WebtoonDetailModel> webtoonDetail =
      apiService.getWebToonDetailById(id);
  late final Future<List<EpisodeModel>> episodes =
      apiService.getEpisodesById(id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder(
        future: webtoonDetail,
        builder: (context, snapshot) {
          return Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Hero(
                  tag: id,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(13)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 12,
                            offset: const Offset(5, 5),
                          )
                        ]),
                    width: 250,
                    child: Image.network(
                      thumb,
                      headers: const {
                        'Referer': 'https://comic.naver.com',
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
