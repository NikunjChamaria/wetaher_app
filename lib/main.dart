import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:weather_app/contoller/controller.dart';
import 'package:weather_app/pages/home_page.dart';

void main() async {
  await ScreenUtil.ensureScreenSize();
  Get.lazyPut(() => Controller());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        useInheritedMediaQuery: true,
        designSize: const Size(392.72727272727275, 872.7272727272727),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return const MaterialApp(
            title: 'Wethery',
            debugShowCheckedModeBanner: false,
            home: HomePage(),
          );
        });
  }
}
