import 'package:aicp/widgets/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:aicp/component/appBar.dart';
import 'package:aicp/screens/details_motocycle_screen.dart';
import 'package:aicp/themes/app_colors.dart';
import 'package:aicp/widgets/sizebox_widgets.dart';
import 'package:aicp/models/news_model.dart';
import 'package:aicp/provider/news_provider.dart';
import 'package:aicp/models/car_model.dart';
import 'package:aicp/provider/car_provider.dart';
import 'package:aicp/models/car_list.dart';
import 'package:aicp/screens/promotion_all_screen.dart';
import 'package:aicp/themes/app_images.dart';
import 'package:aicp/models/news_list.dart';
import 'package:aicp/models/car_offer_list.dart';
import 'package:aicp/models/car_offer_model.dart';
import 'package:aicp/provider/car_offer_provider.dart';
import 'package:aicp/const/end_point.dart';
import 'package:aicp/service/http_service.dart';
import 'package:aicp/screens/promotion_detail_screen.dart';
import '../const/pref_data.dart';
import '../const/secure_data.dart';
import '../utils/share_pref.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // var refreshKey = GlobalKey<RefreshIndicatorState>();

  late FirebaseMessaging _firebaseMessaging;
  NewsProvider? newsProvider;

  late Future<CarsList?> _value;
  late Future<CarsOfferList?> _valueCarsOffer;
  late Future<NewsList?> _valueNews;

  CarsList? carsList;
  CarsOfferList? carsOfferList;
  NewsList? newsList;

  CarsProvider? carsProvider;
  CarsOfferProvider? carsOfferProvider;

  CarsModel? carsModel;
  CarsOfferModel? carsOfferModel;
  NewsModel? newsModel;

  late int activeSlide = 0;
  CarouselController slideController = CarouselController();

  late bool registerStatus;

  @override
  void initState() {
    super.initState();

    carsProvider = Provider.of<CarsProvider>(context, listen: false);
    carsOfferProvider = Provider.of<CarsOfferProvider>(context, listen: false);
    newsProvider = Provider.of<NewsProvider>(context, listen: false);

    _value = loadData();
    _valueCarsOffer = loadDataCarsOffer();
    _valueNews = loadDataNews();

    checkDeviceToken();
    _removeBadge();
  }

  Future<CarsList?> loadData() async {
    CarsProvider carsProvider =
        Provider.of<CarsProvider>(context, listen: false);

    if (carsProvider.carsList == null) {
      // print('loading first');
      carsList = await Provider.of<CarsProvider>(context, listen: false)
          .getCarAll(context);
      // print(carsList!.data![0].carMileage);
      return carsList;
    } else {
      // print('have data');
      return carsProvider.carsList;
    }
  }

  Future<CarsOfferList?> loadDataCarsOffer() async {
    CarsOfferProvider carsOfferProvider =
        Provider.of<CarsOfferProvider>(context, listen: false);

    if (carsOfferProvider.carsOfferList == null) {
      // print('loading first');
      carsOfferList =
          await Provider.of<CarsOfferProvider>(context, listen: false)
              .getCarOffer(context);

      // print(carsOfferList!.data!.length);
      return carsOfferList;
    } else {
      // print('have data');
      carsOfferProvider.carsOfferModel;
      return carsOfferProvider.carsOfferList;
    }
  }

  Future<NewsList?> loadDataNews() async {
    NewsProvider newsProvider =
        Provider.of<NewsProvider>(context, listen: false);

    if (newsProvider.newsModel == null) {
      newsList = await Provider.of<NewsProvider>(context, listen: false)
          .getNews(context);

      return newsList;
    } else {
      return newsProvider.newsList;
    }
  }

  Future<dynamic> _onRefresh() async {
    debugPrint(' onRefresh...');
    await Future.delayed(const Duration(milliseconds: 1000));

    carsList = await Provider.of<CarsProvider>(context, listen: false)
        .getCarAll(context);

    carsOfferList = await Provider.of<CarsOfferProvider>(context, listen: false)
        .getCarOffer(context);

    newsList = await Provider.of<NewsProvider>(context, listen: false)
        .getNews(context);

    return true;
  }

  Future<dynamic> checkDeviceToken() async {
    try {
      String? deviceTokenPref =
          await SharedPref.readValue('string', Preferences.deviceTokenFirebase);
      if (deviceTokenPref == null || deviceTokenPref == "") {
        /// Get Token from firebase messaging
        _firebaseMessaging = FirebaseMessaging.instance;
        _firebaseMessaging.getToken().then((String? token) async {
          // print("token is : ${token} ");
          assert(token != null);

          Map data = {"device_token": token};

          final response =
              await HttpService.post(Endpoints.checkTokenDuplicate, data);
          int statusCode = response["statusCode"];

          // print(response);

          if (statusCode == 200) {
            /// มีเลข Token ในฐานข้อมูลแล้ว ถ้ามีให้นำไปอัพเดต ด้วยเบอร์

            const storage = FlutterSecureStorage();
            String? accessTokenStorage =
                await storage.read(key: SecureData.accessToken);
            String? userIdStorage = await storage.read(key: SecureData.userId);

            Map data1 = {
              "userId": userIdStorage,
              "accessToken": accessTokenStorage,
              "device_token": token
            };

            final response =
                await HttpService.post(Endpoints.updateToken, data1);

            int statusCode = response["statusCode"];

            if (statusCode == 200) {
              // print('Update Token success');
              await SharedPref.setValue(
                  'string', Preferences.deviceTokenFirebase, token);
            } else {
              // print(' Update Token Error');
            }
          } else {
            // print('Insert Token data!');

            const storage = FlutterSecureStorage();
            String? accessTokenStorage =
                await storage.read(key: SecureData.accessToken);
            String? userIdStorage = await storage.read(key: SecureData.userId);

            Map data2 = {
              "userId": userIdStorage,
              "accessToken": accessTokenStorage,
              "device_token": token
            };

            final response = await HttpService.post(Endpoints.saveToken, data2);

            int statusCode = response["statusCode"];

            if (statusCode == 200) {
              // print(' Insert Token success');
              await SharedPref.setValue(
                  'string', Preferences.deviceTokenFirebase, token);
            } else {
              // print(' Insert Token Error');
            }
          }
        });
      } else {
        // print('Have Data deviceTokenPref');
      }
    } catch (e) {
      // print(e.toString());
      throw Exception("Error on server");
    }
  }

  void _removeBadge() {
    FlutterAppBadger.removeBadge();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      // key: refreshKey,
      color: AppColors.indigoPrimary,
      onRefresh: _onRefresh,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF345776).withOpacity(0.6),
                const Color(0xFFF0F3F5).withOpacity(0.1),
              ],
              begin: Alignment.bottomRight,
              end: const Alignment(1.2, -1.25),
            ),
          ),
          child: Column(
            children: [
              headerAppBar(context),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 0),
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          // height: 310.h,
                          decoration: const BoxDecoration(
                              color: AppColors.indigoBgSlide,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16.0),
                              )),
                          child: Column(
                            children: [
                              FutureBuilder(
                                  future: _valueNews,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<NewsList?> snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return Container();
                                      default:
                                        if (snapshot.hasData) {
                                          return Consumer<NewsProvider>(
                                              builder: (context, news, child) =>
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 13, right: 15),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const PromotionAllScreen()),
                                                          );
                                                        },
                                                        child: Text(
                                                          'see_all'.tr(),
                                                          style:
                                                              const TextStyle(
                                                            fontFamily:
                                                                'Prompt',
                                                            fontSize: 15,
                                                            color: Color(
                                                                0xbfffffff),
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                          ),
                                                          textAlign:
                                                              TextAlign.right,
                                                        ),
                                                      ),
                                                    ),
                                                  ));
                                        } else {
                                          return Container();
                                        }
                                    }
                                  }),
                              _buildAdsSlide(),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      top: 25.0, right: 20),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: _buildIndicator(),
                                  )),
                              S.h(20.h)
                            ],
                          ),
                        ),
                      ],
                    ),
                    S.h(20.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        "hot_deal".tr(),
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    _buildCarOffer(),
                    S.h(10.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        "new_product_list".tr(),
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    _buildCarNew(),
                    S.h(8.0),
                    Container(
                      width: MediaQuery.of(context).size.width * 1,
                      color: const Color(0x998D9EAD),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "other_product_list".tr(),
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                                // InkWell(
                                //   onTap: () {},
                                //   child: const Text(
                                //     "See More",
                                //     style: TextStyle(
                                //         decoration: TextDecoration.underline,
                                //         fontSize: 14,
                                //         color: Colors.white),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          _buildCarAll(),
                          S.h(15.0),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdsSlide() {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: FutureBuilder(
          future: _valueNews,
          builder: (BuildContext context, AsyncSnapshot<NewsList?> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return SpinKitThreeBounce(
                  size: 20.h,
                  color: AppColors.indigoPrimary,
                );
              default:
                if (snapshot.hasData) {
                  return Consumer<NewsProvider>(
                      builder: (context, news, child) => InkWell(
                            child: CarouselSlider(
                              carouselController: slideController,
                              options: CarouselOptions(
                                disableCenter: false,
                                viewportFraction: 0.7,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                aspectRatio: 1.5,
                                autoPlayInterval: const Duration(seconds: 3),
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 1500),
                                onPageChanged: (index, reason) =>
                                    setState(() => activeSlide = index),
                              ),
                              items: news.newsList!.data!
                                  .map((e) => ClipRRect(
                                          child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PromotionDetailScreen(
                                                        e.linkImage,
                                                        e.title,
                                                        e.Detail,
                                                        e.date_news),
                                              ));
                                        },
                                        child: CachedNetworkImage(
                                          fit: BoxFit.contain,
                                          imageUrl: e.linkImage.toString(),
                                          placeholder: (context, url) =>
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      )))
                                  .toList(),
                            ),
                          ));
                } else {
                  return Container();
                }
            }
          }),
    );
  }

  Widget _buildIndicator() => FutureBuilder(
      future: _valueNews,
      builder: (BuildContext context, AsyncSnapshot<NewsList?> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container();
          default:
            if (snapshot.hasData) {
              return Consumer<NewsProvider>(
                  builder: (context, news, child) => AnimatedSmoothIndicator(
                        activeIndex: activeSlide,
                        count: news.newsList!.data!.length,
                        effect: const WormEffect(
                            dotWidth: 10,
                            dotHeight: 10,
                            activeDotColor: Color(0xFF48EAFF)),
                        onDotClicked: animateToSlide,
                      ));
            } else {
              return Container();
            }
        }
      });

  animateToSlide(int index) => slideController.jumpToPage(index);

  Widget _buildCarOffer() {
    return FutureBuilder(
        future: _valueCarsOffer,
        builder:
            (BuildContext context, AsyncSnapshot<CarsOfferList?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return SpinKitThreeBounce(
                size: 20.h,
                color: AppColors.indigoPrimary,
              );
            default:
              if (snapshot.hasData) {
                // print(snapshot.data);

                return Container(
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: SizedBox(
                    height: 300.h,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
                            children: [
                              Positioned(
                                  top: 45.1,
                                  left: 5,
                                  child: SvgPicture.asset(
                                    ImagesThemes.triangle,
                                    height: 12.5,
                                    width: 27,
                                  )),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                child: InkWell(
                                  onTap: () async {
                                    registerStatus = await SharedPref.readValue(
                                        'bool', Preferences.registerStatus);
                                    // print(registerStatus);

                                    if (registerStatus == true) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailsMotorScreen(
                                                    snapshot.data!.data![index]
                                                        .carID,
                                                    snapshot.data!.data![index]
                                                        .carImageID)),
                                      );
                                    } else {
                                      Alert.popupAlertWarningForRegister(
                                          context);
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    height: 265.h,
                                    width: 200.w,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                  top: Radius.circular(15.0)),
                                          child: CachedNetworkImage(
                                            width: 240,
                                            height: 175,
                                            fit: BoxFit.cover,
                                            imageUrl: snapshot.data!
                                                .data![index].carImageBanner
                                                .toString(),
                                            placeholder: (context, url) =>
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Align(
                                            alignment: AlignmentDirectional
                                                .centerStart,
                                            child: Text(
                                              snapshot
                                                  .data!.data![index].carTitle
                                                  .toString(),
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Color(0xFF212121)),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.room,
                                                color: Color(0xFF032D54),
                                                size: 20.0,
                                              ),
                                              S.w(4.0),
                                              Text(
                                                snapshot.data!.data![index]
                                                    .carBranchName
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                    fontFamily: 'Prompt',
                                                    fontSize: 12,
                                                    color: Color(0xFF707070)),
                                              )
                                            ],
                                          ),
                                        ),
                                        const Divider(
                                          indent: 10,
                                          endIndent: 10,
                                          thickness: 1,
                                          color: Color(0xFFDBDBDB),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.event_available,
                                                        color: AppColors
                                                            .indigoPrimary,
                                                        size: 20.0,
                                                      ),
                                                      S.w(4.0),
                                                      Text(
                                                        snapshot
                                                            .data!
                                                            .data![index]
                                                            .carYear
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'Prompt',
                                                            fontSize: 10,
                                                            color: Color(
                                                                0xFF707070)),
                                                      )
                                                    ],
                                                  ),
                                                  S.w(1.0)
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.local_movies,
                                                        color: AppColors
                                                            .indigoPrimary,
                                                        size: 20.0,
                                                      ),
                                                      S.w(4.0),
                                                      Text(
                                                        snapshot
                                                                .data!
                                                                .data![index]
                                                                .carMileage
                                                                .toString() +
                                                            " KM",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'Prompt',
                                                            fontSize: 10,
                                                            color: Color(
                                                                0xFF707070)),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              S.h(3.0),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 2.0),
                                                    child: Text(
                                                      snapshot.data!
                                                          .data![index].carPrice
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontFamily: 'Prompt',
                                                        fontSize: 16,
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  const Text(
                                                    " USD",
                                                    style: TextStyle(
                                                      fontFamily: 'Prompt',
                                                      fontSize: 14,
                                                      color: Color(0xFF707070),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        S.h(5.0)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: 20,
                                  left: 5,
                                  child: Container(
                                    width: 93,
                                    height: 30,
                                    decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFFdd0126),
                                            Color(0xFFFF4867),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15.0),
                                            topRight: Radius.circular(15.0),
                                            bottomRight:
                                                Radius.circular(15.0))),
                                    child: Center(
                                      child: Text(
                                        'hot_deal'.tr(),
                                        style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontFamily: 'Prompt',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ))
                            ],
                          );
                        }),
                  ),
                );
              } else {
                return Container();
              }
          }
        });
  }

  Widget _buildCarNew() {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: FutureBuilder(
          future: _value,
          builder: (BuildContext context, AsyncSnapshot<CarsList?> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return SpinKitThreeBounce(
                  size: 20.h,
                  color: AppColors.indigoPrimary,
                );
              default:
                if (snapshot.hasData) {
                  return Container(
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: SizedBox(
                      height: 300.h,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.data!.length < 10
                              ? snapshot.data!.data!.length
                              : 10,
                          itemBuilder: (BuildContext context, int index) {
                            return Stack(
                              children: [
                                Positioned(
                                    top: 45.1,
                                    left: 5,
                                    child: SvgPicture.asset(
                                      ImagesThemes.triangle,
                                      height: 12.5,
                                      width: 27,
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: InkWell(
                                    onTap: () async {
                                      registerStatus =
                                          await SharedPref.readValue('bool',
                                              Preferences.registerStatus);

                                      if (registerStatus == true) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailsMotorScreen(
                                                      snapshot.data!
                                                          .data![index].carID,
                                                      snapshot
                                                          .data!
                                                          .data![index]
                                                          .carImageID)),
                                        );
                                      } else {
                                        Alert.popupAlertWarningForRegister(
                                            context);
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      height: 265.h,
                                      width: 200.w,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                    top: Radius.circular(15.0)),
                                            child: CachedNetworkImage(
                                              width: 240,
                                              height: 175,
                                              fit: BoxFit.cover,
                                              imageUrl: snapshot.data!
                                                  .data![index].carImageBanner
                                                  .toString(),
                                              placeholder: (context, url) =>
                                                  const Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Align(
                                              alignment: AlignmentDirectional
                                                  .centerStart,
                                              child: Text(
                                                snapshot
                                                    .data!.data![index].carTitle
                                                    .toString(),
                                                maxLines: 1,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Color(0xFF212121)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.room,
                                                  color: Color(0xFF032D54),
                                                  size: 20.0,
                                                ),
                                                S.w(4.0),
                                                Text(
                                                  snapshot.data!.data![index]
                                                      .carBranchName
                                                      .toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      fontFamily: 'Prompt',
                                                      fontSize: 12,
                                                      color: Color(0xFF707070)),
                                                )
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            indent: 10,
                                            endIndent: 10,
                                            thickness: 1,
                                            color: Color(0xFFDBDBDB),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.event_available,
                                                          color: AppColors
                                                              .indigoPrimary,
                                                          size: 20.0,
                                                        ),
                                                        S.w(4.0),
                                                        Text(
                                                          snapshot
                                                              .data!
                                                              .data![index]
                                                              .carYear
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  'Prompt',
                                                              fontSize: 10,
                                                              color: Color(
                                                                  0xFF707070)),
                                                        )
                                                      ],
                                                    ),
                                                    S.w(1.0)
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.local_movies,
                                                          color: AppColors
                                                              .indigoPrimary,
                                                          size: 20.0,
                                                        ),
                                                        S.w(4.0),
                                                        Text(
                                                          snapshot
                                                                  .data!
                                                                  .data![index]
                                                                  .carMileage
                                                                  .toString() +
                                                              " KM",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  'Prompt',
                                                              fontSize: 10,
                                                              color: Color(
                                                                  0xFF707070)),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                S.h(3.0),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 2.0),
                                                      child: Text(
                                                        snapshot
                                                            .data!
                                                            .data![index]
                                                            .carPrice
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontFamily: 'Prompt',
                                                          fontSize: 16,
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    const Text(
                                                      " USD",
                                                      style: TextStyle(
                                                        fontFamily: 'Prompt',
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xFF707070),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          S.h(5.0)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    top: 20,
                                    left: 5,
                                    child: Container(
                                      width: 93,
                                      height: 30,
                                      decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFFDD0126),
                                              Color(0xFFFF4867),
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15.0),
                                              topRight: Radius.circular(15.0),
                                              bottomRight:
                                                  Radius.circular(15.0))),
                                      child: const Center(
                                        child: Text(
                                          "New",
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontFamily: 'Prompt',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ))
                              ],
                            );
                          }),
                    ),
                  );
                } else {
                  return Container();
                }
            }
          }),
    );
  }

  Widget _buildCarAll() {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: FutureBuilder(
          future: _value,
          builder: (BuildContext context, AsyncSnapshot<CarsList?> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return SpinKitThreeBounce(
                  size: 20.h,
                  color: AppColors.indigoPrimary,
                );
              default:
                if (snapshot.hasData) {
                  return Container(
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: SizedBox(
                      height: 300.h,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: InkWell(
                                    onTap: () async {
                                      registerStatus =
                                          await SharedPref.readValue('bool',
                                              Preferences.registerStatus);
                                      // print(registerStatus);

                                      if (registerStatus == true) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailsMotorScreen(
                                                      snapshot.data!
                                                          .data![index].carID,
                                                      snapshot
                                                          .data!
                                                          .data![index]
                                                          .carImageID)),
                                        );
                                      } else {
                                        Alert.popupAlertWarningForRegister(
                                            context);
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      height: 265.h,
                                      width: 200.w,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                    top: Radius.circular(15.0)),
                                            child: CachedNetworkImage(
                                              width: 240,
                                              height: 175,
                                              fit: BoxFit.cover,
                                              imageUrl: snapshot.data!
                                                  .data![index].carImageBanner
                                                  .toString(),
                                              placeholder: (context, url) =>
                                                  const Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Align(
                                              alignment: AlignmentDirectional
                                                  .centerStart,
                                              child: Text(
                                                snapshot
                                                    .data!.data![index].carTitle
                                                    .toString(),
                                                maxLines: 1,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Color(0xFF212121)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.room,
                                                  color: Color(0xFF032D54),
                                                  size: 20.0,
                                                ),
                                                S.w(4.0),
                                                Text(
                                                  snapshot.data!.data![index]
                                                      .carBranchName
                                                      .toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      fontFamily: 'Prompt',
                                                      fontSize: 12,
                                                      color: Color(0xFF707070)),
                                                )
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            indent: 10,
                                            endIndent: 10,
                                            thickness: 1,
                                            color: Color(0xFFDBDBDB),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.event_available,
                                                          color: AppColors
                                                              .indigoPrimary,
                                                          size: 20.0,
                                                        ),
                                                        S.w(4.0),
                                                        Text(
                                                          snapshot
                                                              .data!
                                                              .data![index]
                                                              .carYear
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  'Prompt',
                                                              fontSize: 10,
                                                              color: Color(
                                                                  0xFF707070)),
                                                        )
                                                      ],
                                                    ),
                                                    S.w(1.0)
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.local_movies,
                                                          color: AppColors
                                                              .indigoPrimary,
                                                          size: 20.0,
                                                        ),
                                                        S.w(4.0),
                                                        Text(
                                                          snapshot
                                                                  .data!
                                                                  .data![index]
                                                                  .carMileage
                                                                  .toString() +
                                                              " KM",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  'Prompt',
                                                              fontSize: 10,
                                                              color: Color(
                                                                  0xFF707070)),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                S.h(3.0),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 2.0),
                                                      child: Text(
                                                        snapshot
                                                            .data!
                                                            .data![index]
                                                            .carPrice
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontFamily: 'Prompt',
                                                          fontSize: 16,
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    const Text(
                                                      " USD",
                                                      style: TextStyle(
                                                        fontFamily: 'Prompt',
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xFF707070),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          S.h(5.0)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                    ),
                  );
                } else {
                  return Container();
                }
            }
          }),
    );
  }
}
