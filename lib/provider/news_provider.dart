import 'package:flutter/material.dart';
import 'package:aicp/const/end_point.dart';
import 'package:aicp/models/news_model.dart';
import 'package:aicp/service/http_service.dart';
import 'package:aicp/models/news_list.dart';
import 'package:aicp/const/pref_data.dart';
import 'package:aicp/utils/share_pref.dart';

class NewsProvider extends ChangeNotifier {
  NewsList? newsList;
  List<NewsModel?>? newsModel;

  late String languageType;

  Future<NewsList?> getNews(BuildContext context) async {
    try {
      var lang =
          await SharedPref.readValue('string', Preferences.languageStatus);

      if (lang == null || lang == 'en') {
        languageType = "en";
      } else {
        languageType = "kh";
      }

      Map data = {"languageType": languageType};

      final response = await HttpService.post(Endpoints.getNews, data);

      int status = response["statusCode"];
      var respData = response["data"];

      if (status == 200) {
        newsList = NewsList.fromJson(respData);
        newsModel = newsList!.data;
        notifyListeners();
        return newsList;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
