// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_app/widgets/textstyle.dart';

class CloudCoverageRow extends StatelessWidget {
  final int percentage;

  const CloudCoverageRow({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    String cloudIcon;

    if (percentage < 30) {
      cloudIcon = 'assets/low_cloud.svg';
    } else if (percentage < 70) {
      cloudIcon = 'assets/medium_cloud.svg';
    } else {
      cloudIcon = 'assets/high_cloud.svg';
    }

    return Row(
      children: [
        SvgPicture.asset(
          cloudIcon,
          width: 30,
          height: 30,
          color: Colors.white,
        ),
        const SizedBox(width: 10),
        Text('$percentage%', style: poppins(Colors.white, 20, FontWeight.bold)),
      ],
    );
  }
}
