// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:glassmorphism/glassmorphism.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:weather_app/constants/climatecode.dart';
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
  Future<dynamic> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

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
    lat = position.latitude.toString();
    long = position.longitude.toString();
    dynamic data;
    var headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Credentials': 'true',
      'Access-Control-Allow-Headers': 'Content-Type',
      'Access-Control-Allow-Methods': 'GET,PUT,POST,DELETE'
    };
    try {
      var response = await http.get(Uri.parse(url), headers: headers);
      data = jsonDecode(response.body);
    } on Error catch (e) {
      print('Failed host lookup: $e');
    }

    return data;
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
      data = jsonDecode(response.body);
    } on Error catch (e) {
      print('Failed host lookup: $e');
    }
    return data;
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
                                  CachedNetworkImage(
                                    height: MediaQuery.of(context).size.height,
                                    fit: BoxFit.cover,
                                    imageUrl: getWeatherConditionImageUrl(
                                        snapshot.data["weather"][0]["icon"]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 60, left: 30, right: 30),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Text(
                                            index == 0
                                                ? snapshot.data['name']
                                                : locations[index],
                                            style: poppins(Colors.white, 20,
                                                FontWeight.bold),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            "${(snapshot.data!["main"]["temp"] - 273).toStringAsFixed(1)}°C",
                                            style: poppins(Colors.white, 90,
                                                FontWeight.w900),
                                          ),
                                        ),
                                        Center(
                                          child: GlassmorphicContainer(
                                              width: 200,
                                              height: 40,
                                              borderRadius: 20,
                                              blur: 15,
                                              border: 2,
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
                                                  padding:
                                                      const EdgeInsets.all(3),
                                                  child: Text(
                                                      "  Feels like ${(snapshot.data!["main"]["feels_like"] - 273).toStringAsFixed(1)}°C",
                                                      style: poppins(
                                                          Colors.white,
                                                          20,
                                                          FontWeight.bold)))),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              GlassmorphicContainer(
                                                  width: 90,
                                                  height: 40,
                                                  borderRadius: 20,
                                                  blur: 15,
                                                  border: 2,
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
                                                          width: 30,
                                                          height: 30,
                                                          color: Colors.white,
                                                        ),
                                                        Text(
                                                          "${snapshot.data["main"]['humidity']}%",
                                                          style: poppins(
                                                              Colors.white,
                                                              20,
                                                              FontWeight.bold),
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                              GlassmorphicContainer(
                                                  width: 160,
                                                  height: 40,
                                                  borderRadius: 20,
                                                  blur: 15,
                                                  border: 2,
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
                                                          "assets/temp.svg",
                                                          width: 30,
                                                          height: 30,
                                                          color: Colors.white,
                                                        ),
                                                        Text(
                                                          "${(snapshot.data!["main"]["temp_min"] - 273).toStringAsFixed(1)}/${(snapshot.data!["main"]["temp_max"] - 273).toStringAsFixed(1)}°C",
                                                          style: poppins(
                                                              Colors.white,
                                                              20,
                                                              FontWeight.bold),
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              GlassmorphicContainer(
                                                  width: 100,
                                                  height: 40,
                                                  borderRadius: 20,
                                                  blur: 15,
                                                  border: 2,
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
                                                            const EdgeInsets
                                                                .all(3),
                                                        child: CloudCoverageRow(
                                                            percentage: snapshot
                                                                        .data[
                                                                    "clouds"]
                                                                ["all"])),
                                                  )),
                                              GlassmorphicContainer(
                                                  width: 210,
                                                  height: 40,
                                                  borderRadius: 20,
                                                  blur: 15,
                                                  border: 2,
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
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Center(
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/wind.svg",
                                                            width: 30,
                                                            height: 30,
                                                            color: Colors.white,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 10),
                                                            child: Text(
                                                              "${snapshot.data!["wind"]["speed"]}m/s ${getCompassDirection(snapshot.data!["wind"]["deg"].toDouble())}",
                                                              style: poppins(
                                                                  Colors.white,
                                                                  20,
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
                                          padding:
                                              const EdgeInsets.only(top: 30),
                                          child: Center(
                                            child: GlassmorphicContainer(
                                                width: 200,
                                                height: 40,
                                                borderRadius: 20,
                                                blur: 15,
                                                border: 2,
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
                                                          const EdgeInsets.all(
                                                              3),
                                                      child: Text(
                                                        snapshot.data["weather"]
                                                            [0]['main'],
                                                        style: poppins(
                                                            Colors.white,
                                                            25,
                                                            FontWeight.w600),
                                                      )),
                                                )),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 30),
                                          child: Center(
                                            child: GlassmorphicContainer(
                                                width: 300,
                                                height: 40,
                                                borderRadius: 20,
                                                blur: 15,
                                                border: 2,
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
                                                          const EdgeInsets.all(
                                                              3),
                                                      child: Text(
                                                        "Visibility: ${snapshot.data["visibility"] / 1000}km",
                                                        style: poppins(
                                                            Colors.white,
                                                            25,
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
            padding: const EdgeInsets.all(40),
            child: Center(
              child: SmoothPageIndicator(
                controller: pageController,
                count: 7,
                effect: const WormEffect(activeDotColor: Colors.white),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
