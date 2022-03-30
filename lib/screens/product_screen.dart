import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'details_motocycle_screen.dart';
import 'package:aicp/screens/product_filter_screen.dart';
import 'package:aicp/component/appBar.dart';
import 'package:aicp/themes/app_colors.dart';
import 'package:aicp/widgets/sizebox_widgets.dart';
import 'package:aicp/themes/app_images.dart';
import 'package:aicp/const/end_point.dart';
import 'package:aicp/const/pref_data.dart';
import 'package:aicp/service/http_service.dart';
import 'package:aicp/utils/share_pref.dart';
import 'package:aicp/widgets/loader.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  TextEditingController searchTextController = TextEditingController();
  Color selectTypeButtonBGActiveAll = AppColors.indigoPrimary;
  Color selectTypeButtonBGActiveMotorcycle = const Color(0xFFEFEFEF);
  Color selectTypeButtonBGActiveThreeVehicle = const Color(0xFFEFEFEF);

  late String languageType;
  var resultData;

  List<Map<String, dynamic>> _foundCars = [];

  List<Map<String, dynamic>> _carsList = [];

  @override
  void initState() {
    super.initState();
    getCarAll().then((result) {
      setState(() {
        resultData = result;
      });
    });
  }

  Future<dynamic> getCarAll() async {
    try {
      var lang =
          await SharedPref.readValue('string', Preferences.languageStatus);

      if (lang == null || lang == 'en') {
        languageType = "en";
      } else {
        languageType = "kh";
      }

      Map data = {"languageType": languageType};

      final response = await HttpService.post(Endpoints.getCarAll, data);

      int status = response["statusCode"];
      var respData = response["data"];
      // print(respData);

      // var carsDataFromJson = respData;
      // List<dynamic> carsData = List<dynamic>.from(carsDataFromJson);

      // print(carsData);

      if (status == 200) {
        // Copy Main List into New List.
        List<Map<String, dynamic>> newDataList = List.from(respData);
        // print(newDataList);

        // _carsList.add(respData);
        // print(_carsList);
        setState(() {
          _carsList = newDataList;

          _foundCars = _carsList;
          // print(_foundCars);
        });
      }
    } catch (e) {
      // print(e);
    }

    return true;
  }

  void _runFilterCar(String enteredKeyword) {
    // print(enteredKeyword);
    List<Map<String, dynamic>> resultsCars = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      resultsCars = _carsList;
    } else {
      // print(enteredKeyword.toLowerCase());
      setState(() {
        resultsCars = _carsList
            .where((car) =>
                car["carBrandName"]
                    .toLowerCase()
                    .contains(enteredKeyword.toLowerCase()) ||
                car["carModel"]
                    .toLowerCase()
                    .contains(enteredKeyword.toLowerCase()))
            .toList();
        // for (var car in resultsCars) {
        //   print(car["carBrandName"]);
        // }
        // print(resultsCars);
        // we use the toLowerCase() method to make it case-insensitive

        _foundCars = resultsCars;
        // print(_foundCars);
      });
    }

    // Refresh the UI
  }

  @override
  Widget build(BuildContext context) {
    if (resultData != true) {
      return Loader.loadSpin();
    }
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              headerAppBar(context),
              Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    _foundCars.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.only(top: 40.h),
                            child: ListView.builder(
                                itemCount: _foundCars.length,
                                itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailsMotorScreen(
                                                          _foundCars[index]
                                                              ["carID"],
                                                          _foundCars[index]
                                                              ["carImageID"])));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          // height: 370.h,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.88,
                                          child: Column(
                                            children: [
                                              Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius
                                                                .vertical(
                                                            top:
                                                                Radius.circular(
                                                                    10.0)),
                                                    child: CachedNetworkImage(
                                                      width: double.infinity,
                                                      height: 265,
                                                      fit: BoxFit.cover,
                                                      imageUrl: _foundCars[
                                                              index]
                                                          ["carImageBanner"],
                                                      placeholder: (context,
                                                              url) =>
                                                          const Center(
                                                              child:
                                                                  CircularProgressIndicator()),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.98,
                                                      height: 90,
                                                      decoration:
                                                          const BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          colors: [
                                                            Color(0xFF345776),
                                                            Colors.transparent,
                                                          ],
                                                          begin: Alignment
                                                              .bottomCenter,
                                                          end: Alignment
                                                              .topCenter,
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 10,
                                                                bottom: 10),
                                                        child: Align(
                                                          alignment:
                                                              AlignmentDirectional
                                                                  .bottomStart,
                                                          child: Text(
                                                            _foundCars[index][
                                                                    "carBrandName"] +
                                                                '-' +
                                                                _foundCars[
                                                                        index][
                                                                    "carModel"],
                                                            style:
                                                                const TextStyle(
                                                                    fontFamily:
                                                                        'Prompt',
                                                                    fontSize:
                                                                        25,
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              S.h(10.0),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.room,
                                                          color: AppColors
                                                              .indigoPrimary,
                                                          size: 20.0,
                                                        ),
                                                        S.w(10.0),
                                                        Text(
                                                          _foundCars[index]
                                                              ["carBranchName"],
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  'Prompt',
                                                              fontSize: 16,
                                                              color: Color(
                                                                  0xFF707070)),
                                                        ),
                                                      ],
                                                    ),
                                                    const Divider(
                                                      height: 10,
                                                      indent: 2,
                                                      endIndent: 2,
                                                      thickness: 1,
                                                      color: Color(0xFFDBDBDB),
                                                    ),
                                                    S.h(5.0),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .event_available,
                                                              color: AppColors
                                                                  .indigoPrimary,
                                                              size: 20.0,
                                                            ),
                                                            S.w(5.0),
                                                            Text(
                                                              _foundCars[index][
                                                                      "carYear"]
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontFamily:
                                                                      'Prompt',
                                                                  fontSize: 14,
                                                                  color: Color(
                                                                      0xFF707070)),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .local_movies,
                                                              color: AppColors
                                                                  .indigoPrimary,
                                                              size: 20.0,
                                                            ),
                                                            S.w(5.0),
                                                            Text(
                                                              _foundCars[index][
                                                                          "carMileage"]
                                                                      .toString() +
                                                                  " km",
                                                              style: const TextStyle(
                                                                  fontFamily:
                                                                      'Prompt',
                                                                  fontSize: 14,
                                                                  color: Color(
                                                                      0xFF707070)),
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Icon(
                                                              Icons
                                                                  .local_gas_station,
                                                              color: AppColors
                                                                  .indigoPrimary,
                                                              size: 20.0,
                                                            ),
                                                            S.w(5.0),
                                                            Text(
                                                              _foundCars[index][
                                                                  "carFuelName"],
                                                              style: const TextStyle(
                                                                  fontFamily:
                                                                      'Prompt',
                                                                  fontSize: 14,
                                                                  color: Color(
                                                                      0xFF707070)),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    S.h(8.0),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "T_detail".tr(),
                                                          style:
                                                              const TextStyle(
                                                            fontFamily:
                                                                'Prompt',
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xFF636363),
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              _foundCars[index][
                                                                      "carPrice"]
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontFamily:
                                                                      'Prompt',
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Color(
                                                                      0xFFFF0000)),
                                                            ),
                                                            S.w(4.0),
                                                            const Text(
                                                              "USD",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Prompt',
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Color(
                                                                      0xFF636363)),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              S.h(10.0)
                                            ],
                                          ),
                                        ),
                                      ),
                                    )),
                          )
                        : const Center(
                            child: Text(
                              'No results found',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                    Positioned(top: 15, child: searchInput(context)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  searchInput(context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEFEFEF).withOpacity(0.8),
              borderRadius: BorderRadius.circular(30.0),
            ),
            width: MediaQuery.of(context).size.width * 0.93,
            height: 45,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      S.w(10.0),
                      Icon(Icons.search,
                          color: AppColors.indigoTran.withOpacity(0.8)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: TextFormField(
                          onChanged: (value) => _runFilterCar(value),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "T_Search".tr(),
                              hintStyle: const TextStyle(
                                color: Color(0xFF9AABBB),
                              )),
                          controller: searchTextController,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FilterScreen()),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.indigoPrimary.withOpacity(0.8),
                        borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(30.0))),
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Center(
                      child: SvgPicture.asset(
                        ImagesThemes.iconSearch,
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        S.h(12.0),
        // Container(
        //   width: MediaQuery.of(context).size.width * 0.93,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: [
        //       selectTypeButton(
        //           "T_Motorcycle".tr(), selectTypeButtonBGActiveMotorcycle),
        //       selectTypeButton(
        //           "T_ThreeVehicle".tr(), selectTypeButtonBGActiveThreeVehicle),
        //       selectTypeButton("T_All".tr(), selectTypeButtonBGActiveAll),
        //     ],
        //   ),
        // )
      ],
    );
  }

  Widget selectTypeButton(typeName, bgActive) {
    Color _color = bgActive;
    Color _textColor = Colors.black;
    if (bgActive == AppColors.indigoPrimary) {
      _textColor = Colors.white;
    }
    return InkWell(
      onTap: () {
        if (typeName == "Motorcycle" || typeName == "ម៉ូតូ") {
          setState(() {
            selectTypeButtonBGActiveMotorcycle = AppColors.indigoPrimary;
            selectTypeButtonBGActiveThreeVehicle = Color(0xFFEFEFEF);
            selectTypeButtonBGActiveAll = Color(0xFFEFEFEF);
          });
          print('Motorcycle');
        }
        if (typeName == "Three Vehicle" || typeName == "Three Vehicle") {
          setState(() {
            selectTypeButtonBGActiveThreeVehicle = AppColors.indigoPrimary;
            selectTypeButtonBGActiveMotorcycle = Color(0xFFEFEFEF);
            selectTypeButtonBGActiveAll = Color(0xFFEFEFEF);
          });
          print('Three Vehicle');
        }
        if (typeName == "All" || typeName == "ទាំងអស់។") {
          setState(() {
            selectTypeButtonBGActiveAll = AppColors.indigoPrimary;
            selectTypeButtonBGActiveThreeVehicle = Color(0xFFEFEFEF);
            selectTypeButtonBGActiveMotorcycle = Color(0xFFEFEFEF);
          });
          print('All');
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: _color,
          boxShadow: const [
            BoxShadow(
              color: Color(0x40000000),
              offset: Offset(4, 3),
              blurRadius: 9,
            ),
          ],
        ),
        height: 30,
        width: 90,
        child: Center(
          child: Text(
            typeName,
            style: TextStyle(
                fontFamily: 'Prompt', fontSize: 12, color: _textColor),
          ),
        ),
      ),
    );
  }

  motorList_Product(context) {
    // List<Widget> data = [];
    // MotoList _dataFromAPI = MotoList.fromJson(dataConvert[0]);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => const DetailsMotorScreen()));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          height: 366,
          width: MediaQuery.of(context).size.width * 0.88,
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10.0)),
                    child: CachedNetworkImage(
                      height: 265,
                      fit: BoxFit.cover,
                      imageUrl:
                          "https://file.chobrod.com/2019/01/04/PWJGPIec/lamborghini-gallardo-4358.jpg",
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: 354,
                      height: 90,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF345776),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 10, bottom: 10),
                        child: Align(
                          alignment: AlignmentDirectional.bottomStart,
                          child: Text(
                            "Honda - Zoomer X",
                            style: TextStyle(
                                fontFamily: 'Prompt',
                                fontSize: 25,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              S.h(10.0),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.room,
                            color: AppColors.indigoPrimary,
                            size: 20.0,
                          ),
                          S.w(10.0),
                          const Text(
                            "AICP MOTOR PhnomPenh",
                            style: TextStyle(
                                fontFamily: 'Prompt',
                                fontSize: 16,
                                color: Color(0xFF707070)),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 10,
                      indent: 2,
                      endIndent: 2,
                      thickness: 1,
                      color: Color(0xFFDBDBDB),
                    ),
                    S.h(5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.event_available,
                              color: AppColors.indigoPrimary,
                              size: 20.0,
                            ),
                            S.w(5.0),
                            const Text(
                              "2017",
                              style: TextStyle(
                                  fontFamily: 'Prompt',
                                  fontSize: 14,
                                  color: Color(0xFF707070)),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.local_movies,
                              color: AppColors.indigoPrimary,
                              size: 20.0,
                            ),
                            S.w(5.0),
                            const Text(
                              "7,000" + " km",
                              style: TextStyle(
                                  fontFamily: 'Prompt',
                                  fontSize: 14,
                                  color: Color(0xFF707070)),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.local_gas_station,
                              color: AppColors.indigoPrimary,
                              size: 20.0,
                            ),
                            S.w(5.0),
                            const Text(
                              "Bensin",
                              style: TextStyle(
                                  fontFamily: 'Prompt',
                                  fontSize: 14,
                                  color: Color(0xFF707070)),
                            )
                          ],
                        ),
                      ],
                    ),
                    S.h(8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "T_detail".tr(),
                          style: const TextStyle(
                            fontFamily: 'Prompt',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF636363),
                          ),
                        ),
                        Row(
                          children: [
                            const Text(
                              "1,800",
                              style: TextStyle(
                                  fontFamily: 'Prompt',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFF0000)),
                            ),
                            S.w(4.0),
                            const Text(
                              "USD",
                              style: TextStyle(
                                  fontFamily: 'Prompt',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF636363)),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
