import 'dart:async';

import 'package:flutter/material.dart';
import 'package:toonflix_app/models/webtoon_model.dart';
import 'package:toonflix_app/services/api_service.dart';

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
            return const Text('has data');
          } else {
            return const Text('Loading...');
          }
        },
      ),
    );
  }
}
