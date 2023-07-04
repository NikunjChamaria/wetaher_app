// ignore_for_file: deprecated_member_use, avoid_print, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:glassmorphism/glassmorphism.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:weather_app/constants/climatecode.dart';
import 'package:weather_app/contoller/controller.dart';
import 'package:weather_app/server/server.dart';
import 'package:weather_app/widgets/cloudicon.dart';
import 'package:weather_app/widgets/textstyle.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController = PageController();
  Controller controller = Get.find();
  Future<dynamic> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String lat = "";
    String long = "";

    lat = position.latitude.toString();
    long = position.longitude.toString();
    String url =
        'http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=63a3c712c1e9ad55e7b8e38bd4d27e52';
    dynamic data = {};
    var headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Credentials': 'true',
      'Access-Control-Allow-Headers': 'Content-Type',
      'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
    };
    try {
      var response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        data = jsonDecode(response.body);
        sharedPreferences.setString('saveddata', jsonEncode(data));
        sharedPreferences.setString('last_updated', DateTime.now().toString());
        controller.updateTime("Now");
        return data;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      String savedData = sharedPreferences.getString('saveddata') ?? '';
      String savedTime = sharedPreferences.getString('last_updated') ?? '';

      if (savedData.isNotEmpty && savedTime.isNotEmpty) {
        DateTime savedTimeDateTime = DateTime.parse(savedTime);

        controller.updateTime(formatTimeDifference(savedTimeDateTime));

        dynamic saved = jsonDecode(savedData);
        return saved;
      } else {
        throw Exception('No saved data available');
      }
    }
  }

  String getCompassDirection(double degrees) {
    const compassDirections = [
      'N',
      'NNE',
      'NE',
      'ENE',
      'E',
      'ESE',
      'SE',
      'SSE',
      'S',
      'SSW',
      'SW',
      'WSW',
      'W',
      'WNW',
      'NW',
      'NNW'
    ];
    final index = ((degrees + 11.25) % 360 / 22.5).floor();
    return compassDirections[index % 16];
  }

  Future<dynamic> getdata(String location) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String apiUrl =
        'http://api.openweathermap.org/data/2.5/weather?q=$location&appid=63a3c712c1e9ad55e7b8e38bd4d27e52';
    var headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Credentials': 'true',
      'Access-Control-Allow-Headers': 'Content-Type',
      'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
    };
    dynamic data;
    try {
      var response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        data = jsonDecode(response.body);
        sharedPreferences.setString('saveddata$location', jsonEncode(data));
        sharedPreferences.setString('last_updated', DateTime.now().toString());
        controller.updateTime("Now");
        return data;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      String savedData =
          sharedPreferences.getString('saveddata$location') ?? '';
      String savedTime = sharedPreferences.getString('last_updated') ?? '';

      if (savedData.isNotEmpty && savedTime.isNotEmpty) {
        DateTime savedTimeDateTime = DateTime.parse(savedTime);

        controller.updateTime(formatTimeDifference(savedTimeDateTime));

        dynamic saved = jsonDecode(savedData);
        print(saved);
        return saved;
      } else {
        throw Exception('No saved data available');
      }
    }
  }

  String formatTimeDifference(DateTime savedDateTime) {
    Duration difference = DateTime.now().difference(savedDateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: PageView.builder(
                controller: pageController,
                physics: const BouncingScrollPhysics(),
                itemCount: 7,
                itemBuilder: (context, index) {
                  return FutureBuilder(
                      future: index == 0
                          ? getLocation()
                          : getdata(locations[index]),
                      builder: (context, snapshot) {
                        return snapshot.connectionState ==
                                ConnectionState.waiting
                            ? Container()
                            : Stack(
                                children: [
                                  Image.asset(
                                    getWeatherConditionImageasset(
                                        snapshot.data!["weather"][0]["icon"]),
                                    height: MediaQuery.of(context).size.height,
                                    fit: BoxFit.cover,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 60.h, left: 30.w, right: 30.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Text(
                                            index == 0
                                                ? snapshot.data['name']
                                                : locations[index],
                                            style: poppins(Colors.white, 20.sp,
                                                FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(2.h),
                                          child: Center(
                                            child: Stack(children: [
                                              Text(
                                                "${(snapshot.data!["main"]["temp"] - 273).toStringAsFixed(1)}°C",
                                                style: poppins(Colors.black,
                                                    93.sp, FontWeight.w900),
                                              ),
                                              Text(
                                                "${(snapshot.data!["main"]["temp"] - 273).toStringAsFixed(1)}°C",
                                                style: poppins(Colors.white,
                                                    90.sp, FontWeight.w900),
                                              ),
                                            ]),
                                          ),
                                        ),
                                        Center(
                                          child: GlassmorphicContainer(
                                              width: 200.w,
                                              height: 40.h,
                                              borderRadius: 20.h,
                                              blur: 15,
                                              border: 2.h,
                                              linearGradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    const Color(0xFFffffff)
                                                        .withOpacity(0.1),
                                                    const Color(0xFFFFFFFF)
                                                        .withOpacity(0.05),
                                                  ],
                                                  stops: const [
                                                    0.1,
                                                    1,
                                                  ]),
                                              borderGradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  const Color(0xFFffffff)
                                                      .withOpacity(0.5),
                                                  const Color((0xFFFFFFFF))
                                                      .withOpacity(0.5),
                                                ],
                                              ),
                                              child: Padding(
                                                  padding: EdgeInsets.all(3.h),
                                                  child: Text(
                                                      "  Feels like ${(snapshot.data!["main"]["feels_like"] - 273).toStringAsFixed(1)}°C",
                                                      style: poppins(
                                                          Colors.white,
                                                          20.sp,
                                                          FontWeight.bold)))),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 10.h),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              GlassmorphicContainer(
                                                  width: 90.w,
                                                  height: 40.h,
                                                  borderRadius: 20.h,
                                                  blur: 15,
                                                  border: 2.h,
                                                  linearGradient:
                                                      LinearGradient(
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                          colors: [
                                                        const Color(0xFFffffff)
                                                            .withOpacity(0.1),
                                                        const Color(0xFFFFFFFF)
                                                            .withOpacity(0.05),
                                                      ],
                                                          stops: const [
                                                        0.1,
                                                        1,
                                                      ]),
                                                  borderGradient:
                                                      LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      const Color(0xFFffffff)
                                                          .withOpacity(0.5),
                                                      const Color((0xFFFFFFFF))
                                                          .withOpacity(0.5),
                                                    ],
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(3),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        SvgPicture.asset(
                                                          "assets/humid.svg",
                                                          width: 30.h,
                                                          height: 30.h,
                                                          color: Colors.white,
                                                        ),
                                                        Text(
                                                          "${snapshot.data["main"]['humidity']}%",
                                                          style: poppins(
                                                              Colors.white,
                                                              20.sp,
                                                              FontWeight.bold),
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                              GlassmorphicContainer(
                                                  width: 160.h,
                                                  height: 40.h,
                                                  borderRadius: 20.h,
                                                  blur: 15,
                                                  border: 2.h,
                                                  linearGradient:
                                                      LinearGradient(
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                          colors: [
                                                        const Color(0xFFffffff)
                                                            .withOpacity(0.1),
                                                        const Color(0xFFFFFFFF)
                                                            .withOpacity(0.05),
                                                      ],
                                                          stops: const [
                                                        0.1,
                                                        1,
                                                      ]),
                                                  borderGradient:
                                                      LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      const Color(0xFFffffff)
                                                          .withOpacity(0.5),
                                                      const Color((0xFFFFFFFF))
                                                          .withOpacity(0.5),
                                                    ],
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(3.h),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        SvgPicture.asset(
                                                          "assets/temp.svg",
                                                          width: 30.h,
                                                          height: 30.h,
                                                          color: Colors.white,
                                                        ),
                                                        Text(
                                                          "${(snapshot.data!["main"]["temp_min"] - 273).toStringAsFixed(1)}/${(snapshot.data!["main"]["temp_max"] - 273).toStringAsFixed(1)}°C",
                                                          style: poppins(
                                                              Colors.white,
                                                              20.sp,
                                                              FontWeight.bold),
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 10.h),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              GlassmorphicContainer(
                                                  width: 100.h,
                                                  height: 40.h,
                                                  borderRadius: 20.h,
                                                  blur: 15,
                                                  border: 2.h,
                                                  linearGradient:
                                                      LinearGradient(
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                          colors: [
                                                        const Color(0xFFffffff)
                                                            .withOpacity(0.1),
                                                        const Color(0xFFFFFFFF)
                                                            .withOpacity(0.05),
                                                      ],
                                                          stops: const [
                                                        0.1,
                                                        1,
                                                      ]),
                                                  borderGradient:
                                                      LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      const Color(0xFFffffff)
                                                          .withOpacity(0.5),
                                                      const Color((0xFFFFFFFF))
                                                          .withOpacity(0.5),
                                                    ],
                                                  ),
                                                  child: Center(
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.all(3.h),
                                                        child: CloudCoverageRow(
                                                            percentage: snapshot
                                                                        .data[
                                                                    "clouds"]
                                                                ["all"])),
                                                  )),
                                              GlassmorphicContainer(
                                                  width: 210.h,
                                                  height: 40.h,
                                                  borderRadius: 20.h,
                                                  blur: 15,
                                                  border: 2.h,
                                                  linearGradient:
                                                      LinearGradient(
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                          colors: [
                                                        const Color(0xFFffffff)
                                                            .withOpacity(0.1),
                                                        const Color(0xFFFFFFFF)
                                                            .withOpacity(0.05),
                                                      ],
                                                          stops: const [
                                                        0.1,
                                                        1,
                                                      ]),
                                                  borderGradient:
                                                      LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      const Color(0xFFffffff)
                                                          .withOpacity(0.5),
                                                      const Color((0xFFFFFFFF))
                                                          .withOpacity(0.5),
                                                    ],
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0.h),
                                                    child: Center(
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/wind.svg",
                                                            width: 30.h,
                                                            height: 30.h,
                                                            color: Colors.white,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10.h),
                                                            child: Text(
                                                              "${snapshot.data!["wind"]["speed"]}m/s ${getCompassDirection(snapshot.data!["wind"]["deg"].toDouble())}",
                                                              style: poppins(
                                                                  Colors.white,
                                                                  20.sp,
                                                                  FontWeight
                                                                      .bold),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 30.h),
                                          child: Center(
                                            child: GlassmorphicContainer(
                                                width: 200.h,
                                                height: 40.h,
                                                borderRadius: 20.h,
                                                blur: 15,
                                                border: 2.h,
                                                linearGradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      const Color(0xFFffffff)
                                                          .withOpacity(0.1),
                                                      const Color(0xFFFFFFFF)
                                                          .withOpacity(0.05),
                                                    ],
                                                    stops: const [
                                                      0.1,
                                                      1,
                                                    ]),
                                                borderGradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    const Color(0xFFffffff)
                                                        .withOpacity(0.5),
                                                    const Color((0xFFFFFFFF))
                                                        .withOpacity(0.5),
                                                  ],
                                                ),
                                                child: Center(
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.all(3.h),
                                                      child: Text(
                                                        snapshot.data["weather"]
                                                            [0]['main'],
                                                        style: poppins(
                                                            Colors.white,
                                                            25.sp,
                                                            FontWeight.w600),
                                                      )),
                                                )),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 30.h),
                                          child: Center(
                                            child: GlassmorphicContainer(
                                                width: 300.h,
                                                height: 40.h,
                                                borderRadius: 20.h,
                                                blur: 15,
                                                border: 2.h,
                                                linearGradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      const Color(0xFFffffff)
                                                          .withOpacity(0.1),
                                                      const Color(0xFFFFFFFF)
                                                          .withOpacity(0.05),
                                                    ],
                                                    stops: const [
                                                      0.1,
                                                      1,
                                                    ]),
                                                borderGradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    const Color(0xFFffffff)
                                                        .withOpacity(0.5),
                                                    const Color((0xFFFFFFFF))
                                                        .withOpacity(0.5),
                                                  ],
                                                ),
                                                child: Center(
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.all(3.h),
                                                      child: Text(
                                                        "Visibility: ${snapshot.data["visibility"] / 1000}km",
                                                        style: poppins(
                                                            Colors.white,
                                                            25.sp,
                                                            FontWeight.w600),
                                                      )),
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              );
                      });
                }),
          ),
          Padding(
            padding: EdgeInsets.all(40.h),
            child: Center(
              child: SmoothPageIndicator(
                controller: pageController,
                count: 7,
                effect: const WormEffect(activeDotColor: Colors.white),
              ),
            ),
          ),
          GetBuilder<Controller>(builder: (controller1) {
            return Positioned(
              bottom: 20.h,
              left: 20.h,
              child: Text(
                "Last Updated:  ${controller1.time}",
                style: poppins(Colors.white, 18.sp, FontWeight.normal),
              ),
            );
          })
        ]),
      ),
    );
  }
}
