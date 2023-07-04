import 'package:get/get.dart';

class Controller extends GetxController {
  String time = "";
  void updateTime(String newTime) {
    time = newTime;
    update();
  }
}
