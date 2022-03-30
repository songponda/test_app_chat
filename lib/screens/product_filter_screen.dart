import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:aicp/themes/app_colors.dart';
import 'package:aicp/widgets/sizebox_widgets.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List<dynamic> Brand = ["Honda", "Yamaha", "Suzuki", "Bajaj"];
  List<dynamic> Year = [
    "below 1950",
    "1950 - 1960",
    "1960 - 1970",
    "1980 - 1990",
    "1990 - 2000",
    "2000 - 2010",
    "2010 - 2020",
    "above 2020",
  ];
  List<dynamic> YearsV2 = [
    "below 1950",
    "1950",
    "1970",
    "1990",
    "2000",
    "2010",
    "2020",
    "above 2020",
  ];
  SfRangeValues typeScrollRange = SfRangeValues(0.0, 10.0);
  SfRangeValues Price = SfRangeValues(0.0, 100.0);
  SfRangeValues YearsV3 = SfRangeValues(1900.0, 2000.0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          color: AppColors.indigoPrimary,
          width: MediaQuery.of(context).size.width * 1,
          child: Column(
            children: [
              S.h(60.0),
              Container(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 1 - 60,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF345776).withOpacity(0.6),
                        Color(0xFFF0F3F5).withOpacity(0.1),
                      ],
                      begin: Alignment.bottomRight,
                      end: Alignment(1.8, -1.85),
                    ),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Expanded(
                    child: ListView(
                      padding: EdgeInsets.only(top: 0.0),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 18, right: 18),
                          child: Column(
                            children: [
                              S.h(30.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Filter Search",
                                    style: TextStyle(
                                      fontFamily: 'Prompt',
                                      fontSize: 19,
                                      color: Color(0xFF1C466E),
                                    ),
                                  ),
                                ],
                              ),
                              S.h(25.0),
                              _buildDivider(),
                              _componentFilter("Brand"),
                              _buildDivider(),
                              _componentFilter("Price"),
                              _buildDivider(),
                              _componentFilter("Year"),
                              _buildDivider(),
                              _componentFilter("YearV2"),
                              _buildDivider(),
                              _componentFilter("YearV3"),
                              _buildDivider(),
                              _componentFilter("Brand"),
                              _buildDivider(),
                              _componentFilter("Price"),
                              _buildDivider(),
                              _componentFilter("Year"),
                              _buildDivider(),
                              _componentFilter("Brand"),
                              _buildDivider(),
                              _componentFilter("Brand"),
                              _buildDivider(),
                              S.h(25.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      print("confirm");
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: AppColors.indigoPrimary,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x40000000),
                                            offset: Offset(4, 3),
                                            blurRadius: 9,
                                          ),
                                        ],
                                      ),
                                      height: 35,
                                      width: 75,
                                      child: const Center(
                                        child: Text(
                                          "Confirm",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Prompt',
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  S.w(15.0),
                                  InkWell(
                                    onTap: () => Navigator.pop(context),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: Color(0xFFEFEFEF),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x40000000),
                                            offset: Offset(4, 3),
                                            blurRadius: 9,
                                          ),
                                        ],
                                      ),
                                      height: 35,
                                      width: 75,
                                      child: const Center(
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                            fontFamily: 'Prompt',
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              S.h(20.0),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      // height: 40,
      color: AppColors.black.withOpacity(0.4),
    );
  }

  Widget _componentFilter(nameText) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 6),
      child: InkWell(
        onTap: () {
          // print("work!");
          _buildBottomSheetPutParam(nameText);
        },
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                nameText,
                style: TextStyle(
                  fontFamily: 'Prompt',
                  fontSize: 17,
                  color: Color(0xFF022D54).withOpacity(0.45),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.black.withOpacity(0.45),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> _buildBottomSheetPutParam(type) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(18.0),
          ),
        ),
        builder: (context) {
          return Stack(
            children: [
              Positioned(
                  top: 150,
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                  child: Container(
                    height: 54,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color(0x99E8E8E8)),
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 42,
                            height: 3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.0),
                              color: const Color(0xff9aabbb),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            bottom: 10.0, left: 2.0, right: 2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 80,
                                height: 30,
                                child: const Center(
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontFamily: 'Prompt',
                                      fontSize: 14,
                                      color: Color(0xFF022D54),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                print("Done!!");
                              },
                              child: Container(
                                width: 80,
                                height: 30,
                                child: const Center(
                                  child: Text(
                                    'Done',
                                    style: TextStyle(
                                      fontFamily: 'Prompt',
                                      fontSize: 14,
                                      color: Color(0xFF022D54),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                    Container(
                      height: 1.0,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1.25,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                    selectType(type),
                  ],
                ),
              )
            ],
          );
        });
  }

  Widget selectType(type) {
    if (type == "Brand" || type == "Year") {
      List<dynamic> typeScroll = [];
      if (type == "Brand") {
        typeScroll = Brand;
      }
      if (type == "Year") {
        typeScroll = Year;
      }
      return scrollFilter(typeScroll);
    } else if (type == "Price") {
      if (type == "Price") {
        typeScrollRange = Price;
      }
      return _amoutSlider(type, typeScrollRange);
    } else if (type == "YearV2") {
      return scrollFilterV2(YearsV2);
    } else {
      return scrollFilterV3("YearV3", YearsV3);
    }
  }

  Widget scrollFilter(type) {
    return Expanded(
      child: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 0),
          child: ListWheelScrollView(
            onSelectedItemChanged: (itemsChange) {
              print("itemsChange : $itemsChange");
            },
            squeeze: 0.8, // ช่องว่างระหว่างลิส
            diameterRatio: 3.5,
            perspective: 0.01,
            itemExtent: 42,
            physics: FixedExtentScrollPhysics(),
            children: List.generate(type.length, (index) {
              // print(index);
              return SizedBox(
                width: 300,
                child: Text(
                  type[index],
                  style: const TextStyle(
                    fontFamily: 'Prompt',
                    fontSize: 24,
                    color: Color(0xFF022D54),
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }),
          )),
    );
  }

  Widget _amoutSlider(type, _value) {
    return StatefulBuilder(builder: (context, state) {
      return Container(
        child: Column(
          children: [
            S.h(30.0),
            Align(
              alignment: Alignment.center,
              child: Text(
                _value.start.round().toString() +
                    " - " +
                    _value.end.round().toString(),
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            SfRangeSlider(
              values: _value,
              onChanged: (dynamic newValue) {
                _value = newValue;
                state(() {});
                setState(() {});
                if (type == "Price") {
                  setState(() {
                    Price = newValue;
                  });
                }
              },
              activeColor: AppColors.indigoPrimary,
              inactiveColor: AppColors.indigoTran,
              stepSize: 10,
              interval: 100,
              showTicks: true,
              showLabels: true,
              enableTooltip: false,
              min: 0.0,
              max: 500.0,
              minorTicksPerInterval: 1,
            ),
          ],
        ),
      );
    });
  }

  Widget scrollFilterV2(type) {
    return Expanded(
      child: Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.only(top: 20),
        child: Row(
          children: [
            Expanded(
              child: ListWheelScrollView(
                diameterRatio: 50,
                squeeze: 0.8,
                // ช่องว่างระหว่างลิส
                onSelectedItemChanged: (itemsChange) {
                  print("itemsChange : $itemsChange");
                },
                itemExtent: 42,
                children: List.generate(type.length, (index) {
                  // print(index);
                  return SizedBox(
                    width: 300,
                    child: Text(
                      type[index],
                      style: const TextStyle(
                        fontFamily: 'Prompt',
                        fontSize: 16,
                        color: Color(0xFF022D54),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }),
                perspective: 0.01,
                useMagnifier: true,
                magnification: 1.7, // ขนาดของค่าที่เลือก
              ),
            ),
            Expanded(
              child: ListWheelScrollView(
                diameterRatio: 50,
                squeeze: 0.8,
                // ช่องว่างระหว่างลิส
                onSelectedItemChanged: (itemsChange) {
                  print("itemsChange : $itemsChange");
                },
                itemExtent: 42,
                children: List.generate(type.length, (index) {
                  // print(index);
                  return SizedBox(
                    width: 300,
                    child: Text(
                      type[index],
                      style: const TextStyle(
                        fontFamily: 'Prompt',
                        fontSize: 16,
                        color: Color(0xFF022D54),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }),
                perspective: 0.01,
                useMagnifier: true,
                magnification: 1.7, // ขนาดของค่าที่เลือก
              ),
            )
          ],
        ),
      ),
    );

    //   Row(
    //   children: [
    //     Expanded(
    //       child: Container(
    //           alignment: Alignment.topCenter,
    //           margin: const EdgeInsets.only(top: 20),
    //           child: ListWheelScrollView(
    //             diameterRatio: 50,
    //             squeeze: 0.8,
    //             // ช่องว่างระหว่างลิส
    //             onSelectedItemChanged: (itemsChange) {
    //               print("itemsChange : $itemsChange");
    //             },
    //             itemExtent: 42,
    //             children: List.generate(type.length, (index) {
    //               // print(index);
    //               return SizedBox(
    //                 width: 300,
    //                 child: Text(
    //                   type[index],
    //                   style: const TextStyle(
    //                     fontFamily: 'Prompt',
    //                     fontSize: 16,
    //                     color: Color(0xFF022D54),
    //                   ),
    //                   textAlign: TextAlign.center,
    //                 ),
    //               );
    //             }),
    //             perspective: 0.01,
    //             useMagnifier: true,
    //             magnification: 1.7, // ขนาดของค่าที่เลือก
    //           )),
    //     ),
    //     Expanded(
    //       child: Container(
    //           alignment: Alignment.topCenter,
    //           margin: const EdgeInsets.only(top: 20),
    //           child: ListWheelScrollView(
    //             diameterRatio: 50,
    //             squeeze: 0.8,
    //             // ช่องว่างระหว่างลิส
    //             onSelectedItemChanged: (itemsChange) {
    //               print("itemsChange : $itemsChange");
    //             },
    //             itemExtent: 42,
    //             children: List.generate(type.length, (index) {
    //               // print(index);
    //               return SizedBox(
    //                 width: 300,
    //                 child: Text(
    //                   type[index],
    //                   style: const TextStyle(
    //                     fontFamily: 'Prompt',
    //                     fontSize: 16,
    //                     color: Color(0xFF022D54),
    //                   ),
    //                   textAlign: TextAlign.center,
    //                 ),
    //               );
    //             }),
    //             perspective: 0.01,
    //             useMagnifier: true,
    //             magnification: 1.7, // ขนาดของค่าที่เลือก
    //           )),
    //     ),
    //   ],
    // );
  }

  Widget scrollFilterV3(type, _value) {
    return StatefulBuilder(builder: (context, state) {
      return Container(
        child: Column(
          children: [
            S.h(30.0),
            Align(
              alignment: Alignment.center,
              child: Text(
                _value.start.round().toString() +
                    " - " +
                    _value.end.round().toString(),
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            SfRangeSlider(
              values: _value,
              onChanged: (dynamic newValue) {
                _value = newValue;
                state(() {});
                setState(() {});
                setState(() {
                  YearsV3 = newValue;
                });
              },
              activeColor: AppColors.indigoPrimary,
              inactiveColor: AppColors.indigoTran,
              stepSize: 10,
              interval: 100,
              showTicks: true,
              showLabels: true,
              enableTooltip: false,
              min: 1800.0,
              max: 2020.0,
              minorTicksPerInterval: 1,
            ),
          ],
        ),
      );
    });
  }
}
