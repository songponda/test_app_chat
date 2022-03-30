import 'package:aicp/provider/news_provider.dart';
import 'package:aicp/widgets/button_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:aicp/component/appBar.dart';
import 'package:aicp/screens/promotion_detail_screen.dart';
import 'package:provider/provider.dart';

class PromotionAllScreen extends StatefulWidget {
  const PromotionAllScreen({Key? key}) : super(key: key);

  @override
  _PromotionAllScreenState createState() => _PromotionAllScreenState();
}

class _PromotionAllScreenState extends State<PromotionAllScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF9AABBB),
                Colors.transparent,
              ],
              begin: Alignment.bottomRight,
              end: Alignment(1.2, -1.25),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  headerAppBar(context),
                  Positioned(
                    top: 40,
                    left: 10,
                    child: Button.backPopPage(context),
                  ),
                ],
              ),
              Consumer<NewsProvider>(
                  builder: (context, news, child) => Expanded(
                          child: ListView(
                        children: List.generate(
                          news.newsList!.data!.length,
                          (index) => Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6.00),
                                child: InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PromotionDetailScreen(
                                                news.newsList!.data![index]
                                                    .linkImage,
                                                news.newsList!.data![index]
                                                    .title,
                                                news.newsList!.data![index]
                                                    .Detail,
                                                news.newsList!.data![index]
                                                    .date_news),
                                      )),
                                  child: ClipRRect(
                                    // borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                    child: CachedNetworkImage(
                                      width: 341,
                                      height: 341,
                                      fit: BoxFit.cover,
                                      imageUrl: news
                                          .newsList!.data![index].linkImage
                                          .toString(),
                                      placeholder: (context, url) =>
                                          const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 292.5,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PromotionDetailScreen(
                                                  news.newsList!.data![index]
                                                      .linkImage,
                                                  news.newsList!.data![index]
                                                      .title,
                                                  news.newsList!.data![index]
                                                      .Detail,
                                                  news.newsList!.data![index]
                                                      .date_news),
                                        ));
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                      color: Colors.black.withOpacity(0.45),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "See More",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Prompt',
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
