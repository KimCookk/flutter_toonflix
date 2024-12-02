import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:toonflix_app/models/webtoon_detail_model.dart';
import 'package:toonflix_app/services/api_service.dart';
import 'package:toonflix_app/models/episode_model.dart';

class WebtoonScreen extends StatefulWidget {
  final String title, thumb, id;

  const WebtoonScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<WebtoonScreen> createState() => _WebtoonScreenState();
}

class _WebtoonScreenState extends State<WebtoonScreen> {
  final ApiService apiService = ApiService();

  late final Future<WebtoonDetailModel> webtoonDetail;
  late final Future<List<EpisodeModel>> episodes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    webtoonDetail = apiService.getWebToonDetailById(widget.id);
    episodes = apiService.getEpisodesById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Hero(
                  tag: widget.id,
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
                      widget.thumb,
                      headers: const {
                        'Referer': 'https://comic.naver.com',
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              FutureBuilder(
                future: webtoonDetail,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    WebtoonDetailModel webtoonDetail = snapshot.data!;
                    return Column(
                      children: [
                        Text(
                          '${webtoonDetail.genre!} / ${webtoonDetail.age!}',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          webtoonDetail.about!,
                        ),
                      ],
                    );
                  } else {
                    return const Text('...');
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder(
                  future: episodes,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<EpisodeModel> episodes = snapshot.data!;
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            for (var episode in episodes.reversed)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(episode.title!),
                                          const IconButton(
                                            onPressed: null,
                                            icon: Icon(Icons.chevron_right),
                                          )
                                        ]),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
