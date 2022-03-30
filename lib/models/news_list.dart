import 'package:aicp/models/news_model.dart';

class NewsList {
  final List<NewsModel>? data;

  NewsList({this.data});

  factory NewsList.fromJson(List<dynamic> parsedJson) {
    List<NewsModel> data = <NewsModel>[];
    data = parsedJson.map((i) => NewsModel.fromJson(i)).toList();
    return NewsList(data: data);
  }
}
