import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toonflix_app/models/webtoon_detail_model.dart';
import 'package:toonflix_app/services/api_service.dart';
import 'package:toonflix_app/models/episode_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
  late final SharedPreferences prefs;
  late List<String>? likeIDs;
  bool isLike = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    webtoonDetail = apiService.getWebToonDetailById(widget.id);
    episodes = apiService.getEpisodesById(widget.id);
    initPrefs();
  }

  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    likeIDs = prefs.getStringList('likeIDs');

    if (likeIDs != null) {
      // likeIDs 존재
      if (likeIDs!.contains(widget.id)) {
        setState(() {
          isLike = true;
        });
      } else {
        setState(() {
          isLike = false;
        });
      }
    } else {
      // likeIDs 존재하지 않음
      likeIDs = [];
      prefs.setStringList('likeIDs', likeIDs!);
    }
  }

  void tappedLikeButton() {
    setState(() {
      isLike = !isLike;
      if (isLike && likeIDs != null) {
        likeIDs!.add(widget.id);
      } else if (!isLike && likeIDs != null) {
        likeIDs!.remove(widget.id);
      }
    });

    prefs.setStringList('likeIDs', likeIDs!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              tappedLikeButton();
            },
            icon: Icon(isLike ? Icons.favorite : Icons.favorite_border),
          ),
        ],
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
                            for (var episode in episodes)
                              EpisodeButton(
                                webtoonId: widget.id,
                                episode: episode,
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

class EpisodeButton extends StatelessWidget {
  const EpisodeButton({
    super.key,
    required this.episode,
    required this.webtoonId,
  });

  final EpisodeModel episode;
  final String webtoonId;

  void tappedButton() async {
    String url =
        'https://comic.naver.com/webtoon/detail?titleId=$webtoonId&no=${episode.id}';
    launchUrlString(url);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        tappedButton();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      episode.title!,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
