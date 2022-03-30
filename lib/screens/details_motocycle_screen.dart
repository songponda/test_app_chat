import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:photo_view/photo_view.dart';
import 'package:readmore/readmore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../widgets/button_widgets.dart';
import 'index_screen.dart';
import 'package:aicp/component/appBar.dart';
import 'package:aicp/themes/app_colors.dart';
import 'package:aicp/widgets/sizebox_widgets.dart';
import 'package:aicp/models/car_detail_model.dart';
import 'package:aicp/provider/car_detail_provider.dart';
import 'package:aicp/models/car_image_list.dart';
import 'package:aicp/models/car_image_model.dart';
import 'package:aicp/provider/car_image_provider.dart';
import 'package:aicp/const/end_point.dart';
import 'package:aicp/const/secure_data.dart';
import 'package:aicp/service/http_service.dart';
import 'package:aicp/widgets/alert.dart';
import 'package:aicp/widgets/push_page_transition.dart';
import 'package:aicp/service/logout_service.dart';
import 'package:aicp/widgets/loader.dart';

class DetailsMotorScreen extends StatefulWidget {
  final carId;
  final carImageId;

  DetailsMotorScreen(this.carId, this.carImageId);

  @override
  _DetailsMotorScreenState createState() =>
      _DetailsMotorScreenState(this.carId, this.carImageId);
}

class _DetailsMotorScreenState extends State<DetailsMotorScreen> {
  _DetailsMotorScreenState(this.carId, this.carImageId);

  late int carId;
  late int carImageId;
  late Future<CarDetailModel?> _value;
  late Future<CarImageList?> _valueImage;

  CarImageProvider? carImageProvider;

  CarDetailProvider? carDetailProvider;
  CarDetailModel? carDetail;

  CarImageList? carImageList;

  CarImageModel? carImageModel;

  late int activeSlide = 0;
  CarouselController slideController = CarouselController();

  animateToSlide(int index) => slideController.jumpToPage(index);

  late bool registerStatus;

  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();

    // print(carId);
    // print(carImageId);
    // print('*************');

    carDetailProvider = Provider.of<CarDetailProvider>(context, listen: false);
    carImageProvider = Provider.of<CarImageProvider>(context, listen: false);

    _value = loadData();
    _valueImage = loadDataCarImage();
  }

  Future<CarDetailModel?> loadData() async {
    carDetail = await Provider.of<CarDetailProvider>(context, listen: false)
        .getCarDetail(context, carId);
    return carDetail;
  }

  Future<CarImageList?> loadDataCarImage() async {
    carImageList = await Provider.of<CarImageProvider>(context, listen: false)
        .getCarImageDetail(context, carImageId);
    // print(carImageList!.data!.length);

    return carImageList;
  }

  void checkBeforeSendData() async {
    Loader.show(context);

    try {
      const storage = FlutterSecureStorage();
      String? accessTokenStorage =
          await storage.read(key: SecureData.accessToken);
      String? userIdStorage = await storage.read(key: SecureData.userId);

      Map data = {"userId": userIdStorage, "accessToken": accessTokenStorage};

      final response = await HttpService.post(Endpoints.getInterestUser, data);
      print(response);

      int status = response["statusCode"];
      var res = response["data"][0];
      var msg = response["message"];

      if (status == 200) {
        Map data3 = {
          "userId": userIdStorage,
          "accessToken": accessTokenStorage,
          "fullNameCustomer": res['fullname'],
          "phoneFirebase": res['phone_firebase'],
          "linkCarFromWeb":
              'https://aicpmotor.web.app/AddCar?CarData=${carId.toString()}&carImageID=${carImageId.toString()}',
          "carID": carId
        };
        print(data3);

        final response3 =
            await HttpService.post(Endpoints.saveInterestUser, data3);
        int status3 = response3["statusCode"];

        print(response3);

        if (status3 == 200) {
          Map data2 = {
            "message":
                "ลูกค้าสนใจซื้อรถ \n🔔App AICP Motor\n⭕️ชื่อลูกค้า : ${res['fullname']}\n📱เบอร์โทรศัพท์ : ${res['phone']}\n⭕️สาขา : ${res['branch_en']}\n⭕Link รถ : https://aicpmotor.web.app/Interest?CarData=${carId.toString()}&carImageID=${carImageId.toString()}\n🕐 เวลา : ${now.toString()}",
          };
          print(data2);

          final response2 =
              await HttpService.post(Endpoints.sendNotificationTelegram, data2);
          int status2 = response2["statusCode"];

          print(response2);

          if (status2 == 200) {
            Loader.hide(context);

            _buildPopupAlertSuccess(res['fullname'], res['phone']);
          } else {
            Loader.hide(context);
            Alert.popupAlertErrorContactAdmin(context);
            print("Error!");
          }
        } else {
          Loader.hide(context);
          Alert.popupAlertErrorContactAdmin(context);
          print("Error!");
        }
      } else if (status == 401) {
        LogoutService.logout(context);
        print("Unauthorized -> Logout!");
        // return null;
      } else if (status == 404) {
        Loader.hide(context);
        Alert.popupAlertErrorContactAdmin(context);
      } else {
        print("Error อื่น ๆ ติดต่อ Admin , และ ส่งข้อมูล Error ");
        return null;
      }
    } catch (e) {
      Loader.hide(context);
      Alert.popupAlertErrorContactAdmin(context);
      print("Error! From Server");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                // alignment: AlignmentDirectional.topCenter,
                children: [
                  headerAppBar(context),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      top: 40,
                    ),
                    child: Button.backPopPage(context),
                  )
                ],
              ),
              Stack(
                children: [
                  _buildMotorDetail(),
                  _buildButtons(),
                ],
              ),
              S.h(10.0),
              _buildImagesSelector(context),
              // S.h(20.1),
              _buildShowOtherDetail(context),
              S.h(25.0),
              _buildContactButton(),
              S.h(50.0.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactButton() {
    return FutureBuilder(
        future: _value,
        builder:
            (BuildContext context, AsyncSnapshot<CarDetailModel?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container();
            default:
              if (snapshot.hasData) {
                return Center(
                  child: InkWell(
                    onTap: () {
                      popupAlertConfirmContactBuy(context);
                    },
                    child: Container(
                      height: 54,
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                          color: const Color(0xFFC70000),
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Center(
                        child: Text(
                          "contact_buy".tr(),
                          style: const TextStyle(
                              fontFamily: 'Prompt',
                              fontSize: 16,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
          }
        });
  }

  Widget _buildShowOtherDetail(context) {
    return FutureBuilder(
        future: _value,
        builder:
            (BuildContext context, AsyncSnapshot<CarDetailModel?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return SpinKitThreeBounce(
                size: 20.h,
                color: AppColors.indigoPrimary,
              );
            default:
              if (snapshot.hasData) {
                return Consumer<CarDetailProvider>(
                    builder: (context, car, child) => Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    // "HONDA - Zoomer X",
                                    car.carDetailModel!.carBrandName! +
                                        ' - ' +
                                        car.carDetailModel!.carModel!,
                                    style: const TextStyle(
                                      fontFamily: 'Prompt',
                                      fontSize: 22,
                                      color: Color(0xFF032D54),
                                    ),
                                  )
                                ],
                              ),
                              S.h(10.0),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.room,
                                    color: Color(0xFF032D54),
                                    size: 20.0,
                                  ),
                                  S.w(10.0),
                                  Text(
                                    // "AICP MOTOR PhnomPenh",
                                    car.carDetailModel!.carBranchName!,
                                    style: const TextStyle(
                                        fontFamily: 'Prompt',
                                        fontSize: 14,
                                        color: Color(0x99212121)),
                                  )
                                ],
                              ),
                              _buildDivider(),
                              S.h(11.0),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.theaters,
                                    color: AppColors.indigoPrimary,
                                    size: 20.0,
                                  ),
                                  S.w(10.0),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Text(
                                      // '20,000 km',
                                      car.carDetailModel!.carMileage!
                                              .toString() +
                                          ' km',
                                      style: const TextStyle(
                                          fontFamily: 'Prompt',
                                          fontSize: 16,
                                          color: Color(0x99212121)),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.event_available,
                                    color: AppColors.indigoPrimary,
                                    size: 20.0,
                                  ),
                                  S.w(12.0),
                                  Text(
                                    car.carDetailModel!.carYear!.toString(),
                                    style: const TextStyle(
                                      fontFamily: 'Prompt',
                                      fontSize: 16,
                                      color: Color(0x99212121),
                                    ),
                                  )
                                ],
                              ),
                              S.h(11.0),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.local_gas_station,
                                    color: AppColors.indigoPrimary,
                                    size: 20.0,
                                  ),
                                  S.w(10.0),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Text(
                                      car.carDetailModel!.carFuelName!,
                                      style: const TextStyle(
                                          fontFamily: 'Prompt',
                                          fontSize: 16,
                                          color: Color(0x99212121)),
                                    ),
                                  ),
                                  const FaIcon(
                                    FontAwesomeIcons.motorcycle,
                                    color: AppColors.indigoPrimary,
                                    size: 20.0,
                                  ),
                                  S.w(7.0),
                                  Text(
                                    // '110' ' CC',
                                    car.carDetailModel!.carCC!.toString() +
                                        ' CC',
                                    style: const TextStyle(
                                        fontFamily: 'Prompt',
                                        fontSize: 16,
                                        color: Color(0x99212121)),
                                  ),
                                ],
                              ),
                              S.h(20.0.h),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: ReadMoreText(
                                  car.carDetailModel!.carDetails!.toString(),
                                  trimLines: 3,
                                  colorClickableText: AppColors.indigoPrimary,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: '...Show more',
                                  trimExpandedText: ' show less',
                                  style: const TextStyle(
                                    fontFamily: 'Prompt',
                                    fontSize: 16,
                                    color: Color(0x99212121),
                                  ),
                                ),
                              ),
                              S.h(20.0.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  S.w(1.0),
                                  Row(
                                    children: [
                                      Text(
                                        car.carDetailModel!.carPrice!
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 22,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      S.w(8.0),
                                      const Text(
                                        "USD",
                                        style: TextStyle(
                                            fontFamily: 'Prompt',
                                            fontSize: 22,
                                            color: Color(0xFF636363),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      S.w(6.0),
                                    ],
                                  ),
                                ],
                              ),
                              _buildDivider(),
                            ],
                          ),
                        ));
              } else {
                return Container();
              }
          }
        });
  }

  Widget _buildDivider() {
    return Divider(
      thickness: 1,
      color: AppColors.black.withOpacity(0.2),
    );
  }

  Widget _buildImagesSelector(context) {
    return FutureBuilder(
        future: _valueImage,
        builder: (BuildContext context, AsyncSnapshot<CarImageList?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container();
            default:
              if (snapshot.hasData) {
                return SizedBox(
                  height: 75.h,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: carImageList!.data!.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Stack(
                          children: [
                            i == activeSlide
                                ? GestureDetector(
                                    onTap: () => animateToSlide(i),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 2, right: 2),
                                      child: Container(
                                        color: const Color(0xFF4D7CA7),
                                        height: 60,
                                        width: 60,
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            height: 60,
                                            width: 60,
                                            imageUrl: carImageList!
                                                .data![i].linkCarImage
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
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () => animateToSlide(i),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 2, right: 2),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        height: 60,
                                        width: 60,
                                        imageUrl: carImageList!
                                            .data![i].linkCarImage
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
                          ],
                        );
                      }),
                );
              } else {
                return Container();
              }
          }
        });
  }

  Widget _buildButtons() {
    return SizedBox(
      height: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: InkWell(
              onTap: () => slideController.previousPage(),
              child: Container(
                clipBehavior: Clip.hardEdge,
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: AppColors.black.withOpacity(0.1),
                    shape: BoxShape.circle),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 8.0,
                    sigmaY: 8.0,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [_buildIndicator()],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => slideController.nextPage(),
              child: Container(
                clipBehavior: Clip.hardEdge,
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: AppColors.black.withOpacity(0.1),
                    shape: BoxShape.circle),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 8.0,
                    sigmaY: 8.0,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator() {
    return FutureBuilder(
        future: _valueImage,
        builder: (BuildContext context, AsyncSnapshot<CarImageList?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container();
            default:
              if (snapshot.hasData) {
                return Consumer<CarImageProvider>(
                    builder: (context, image, child) => AnimatedSmoothIndicator(
                          activeIndex: activeSlide,
                          count: image.carImageList!.data!.length,
                          effect: const WormEffect(
                            dotWidth: 8,
                            dotHeight: 8,
                            activeDotColor: Color(0xFF48EAFF),
                            dotColor: Colors.white,
                          ),
                          onDotClicked: animateToSlide,
                        ));
              } else {
                return Container();
              }
          }
        });
  }

  Widget _buildMotorDetail() {
    return FutureBuilder(
        future: _valueImage,
        builder: (BuildContext context, AsyncSnapshot<CarImageList?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Padding(
                padding: const EdgeInsets.only(top: 140),
                child: SpinKitThreeBounce(
                  size: 20.h,
                  color: AppColors.indigoPrimary,
                ),
              );
            default:
              if (snapshot.hasData) {
                return Consumer<CarImageProvider>(
                    builder: (context, image, child) => CarouselSlider(
                          carouselController: slideController,
                          options: CarouselOptions(
                            enlargeCenterPage: true,
                            enableInfiniteScroll: true,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            height: 300,
                            viewportFraction: 1,
                            onPageChanged: (index, reason) =>
                                setState(() => activeSlide = index),
                          ),
                          items: image.carImageList!.data!
                              .map(
                                (e) =>
                                    // ClipRRect(
                                    //       child: Stack(
                                    //         fit: StackFit.expand,
                                    //         children: [
                                    //           CachedNetworkImage(
                                    //             fit: BoxFit.cover,
                                    //             imageUrl: e.linkCarImage.toString(),
                                    //             placeholder: (context, url) =>
                                    //                 const Center(
                                    //                     child:
                                    //                         CircularProgressIndicator()),
                                    //             errorWidget: (context, url, error) =>
                                    //                 const Icon(Icons.error),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    InkWell(
                                  onTap: () {
                                    _buildFullPic(
                                        context, e.linkCarImage.toString());
                                  },
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: e.linkCarImage.toString(),
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              )
                              .toList(),
                        ));
              } else {
                return Container();
              }
          }
        });
  }

  _buildFullPic(context, ImgURL) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 3),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: PhotoView(
                    backgroundDecoration:
                        const BoxDecoration(color: Colors.transparent),
                    imageProvider: CachedNetworkImageProvider(ImgURL),
                  ),
                ),
              ),
            ),
          );
        });
  }

  popupAlertConfirmContactBuy(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 3),
              child: Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(25.0)), //this right here
                  child: SizedBox(
                      width: 358,
                      height: 250.h,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            S.h(90.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "alertBuy".tr(),
                                  style: const TextStyle(
                                    fontFamily: 'Prompt',
                                    fontSize: 15,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w800,
                                    height: 1.263157894736842,
                                  ),
                                  textHeightBehavior: const TextHeightBehavior(
                                      applyHeightToFirstAscent: false),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            S.h(45.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () => checkBeforeSendData(),
                                  child: Container(
                                      width: 100,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        color: const Color(0xff022D54),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'ok'.tr(),
                                            style: const TextStyle(
                                              fontFamily: 'Prompt',
                                              fontSize: 17,
                                              color: Color(0xffffffff),
                                              letterSpacing: 0.51,
                                              height: 1.3529411764705883,
                                            ),
                                            textHeightBehavior:
                                                const TextHeightBehavior(
                                                    applyHeightToFirstAscent:
                                                        false),
                                            textAlign: TextAlign.left,
                                          )
                                        ],
                                      )),
                                ),
                                S.w(8.0),
                                InkWell(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                      width: 100,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        color: const Color(0xff022D54),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'cancel'.tr(),
                                            style: const TextStyle(
                                              fontFamily: 'Prompt',
                                              fontSize: 17,
                                              color: Color(0xffffffff),
                                              letterSpacing: 0.51,
                                              height: 1.3529411764705883,
                                            ),
                                            textHeightBehavior:
                                                const TextHeightBehavior(
                                                    applyHeightToFirstAscent:
                                                        false),
                                            textAlign: TextAlign.left,
                                          )
                                        ],
                                      )),
                                ),
                              ],
                            ),
                          ]))));
        });
  }

  _buildPopupAlertSuccess(String name, String phone) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 3),
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)), //this right here
              child: SizedBox(
                width: 358,
                height: 348,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    S.h(51.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'received_data'.tr(),
                          style: const TextStyle(
                            fontFamily: 'Prompt',
                            fontSize: 20,
                            color: AppColors.black,
                            fontWeight: FontWeight.w800,
                            height: 1.263157894736842,
                          ),
                          textHeightBehavior: const TextHeightBehavior(
                              applyHeightToFirstAscent: false),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    S.h(15.9),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${name}\n${'phoneNumber'.tr()} ${phone}',
                          style: const TextStyle(
                            fontFamily: 'Prompt',
                            fontSize: 15,
                            color: AppColors.black,
                            fontWeight: FontWeight.w500,
                            height: 1.263157894736842,
                          ),
                          textHeightBehavior: const TextHeightBehavior(
                              applyHeightToFirstAscent: false),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    S.h(20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${'thank_buying'.tr()}\n${'staff'.tr()}',
                          style: const TextStyle(
                            fontFamily: 'Prompt',
                            fontSize: 14,
                            color: AppColors.black,
                            fontWeight: FontWeight.w500,
                            height: 1.263157894736842,
                          ),
                          textHeightBehavior: const TextHeightBehavior(
                              applyHeightToFirstAscent: false),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    S.h(30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => PushPageTran.pushReplacement(
                              context, const IndexScreen()),
                          child: Container(
                              width: 181,
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: const Color(0xff022D54),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.check,
                                    color: AppColors.white,
                                    size: 27.0,
                                  ),
                                  S.w(5.0),
                                  Text(
                                    'done'.tr(),
                                    style: const TextStyle(
                                      fontFamily: 'Prompt',
                                      fontSize: 17,
                                      color: Color(0xffffffff),
                                      letterSpacing: 0.51,
                                      height: 1.3529411764705883,
                                    ),
                                    textHeightBehavior:
                                        const TextHeightBehavior(
                                            applyHeightToFirstAscent: false),
                                    textAlign: TextAlign.left,
                                  )
                                ],
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
