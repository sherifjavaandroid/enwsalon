import 'package:easycut/core/constant/dimensions.dart';
import 'package:easycut/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StackImageDetail extends StatelessWidget {
  final String salonImage;
  const StackImageDetail({super.key, required this.salonImage});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: 29.h,
      child: SizedBox(
        width: double.infinity,
        height: 328.h,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: 14.h,
          ),
          child: Image.network(
            "${AppLink.imageSalons}$salonImage",
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
