import 'dart:async';

import 'package:flutter/material.dart';
import 'package:toonflix_app/models/webtoon_model.dart';
import 'package:toonflix_app/services/api_service.dart';
import 'package:toonflix_app/widgets/webtoonCard.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final ApiService apiService = ApiService();
  late final Future<List<WebtoonModel>> webtoons = apiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 2,
        foregroundColor: Colors.green,
        backgroundColor: Colors.white,
        title: const Text(
          '오늘의 웹툰',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: FutureBuilder(
        future: webtoons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return makeWebToonList(snapshot);
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  ListView makeWebToonList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
      padding: const EdgeInsets.all(15),
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        WebtoonModel webtoon = snapshot.data![index];
        return WebtoonCard(
          title: webtoon.title,
          thumb: webtoon.thumb,
          id: webtoon.id,
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(
          width: 20,
        );
      },
    );
  }
}
