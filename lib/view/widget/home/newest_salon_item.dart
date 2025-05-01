import 'package:easycut/core/constant/color.dart';
import 'package:easycut/core/constant/routes.dart';
import 'package:easycut/core/shared/widgets/big_text.dart';
import 'package:easycut/core/shared/widgets/small_text.dart';
import 'package:easycut/data/model/salon_model.dart';
import 'package:easycut/linkapi.dart';
import 'package:easycut/view/widget/home/icon_and_text.dart';
import 'package:easycut/view/widget/home/salon_rate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NewestSalonItem extends StatelessWidget {
  final SalonModel salon;
  const NewestSalonItem({
    super.key,
    required this.salon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 38.w, right: 38.w, bottom: 5.h, top: 5.h),
      child: GestureDetector(
        onTap: () {
          String deepLink = "${AppRoute.salonDetails}?salonid=${salon.id}";
          print("Deep Link: $deepLink");

          Get.toNamed(AppRoute.salonDetails, arguments: {
            "salonid": salon.id,
          });
        },
        child: Container(
          width: 364.w,
          height: 201.h,
          padding: const EdgeInsets.all(10), // Padding applied to all sides
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColor.backgroundicons2, width: 1),
              color: AppColor.backgroundButton),
          child: Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  Container(
                    width: 344.w, // Adjusted width to fit within 364 width
                    height: 126.h, // Adjusted height
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: const Color(0xffA3A5A7),
                          width: 1.5.w), // Border applied to all sides
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          "${AppLink.imageSalons}${salon.image}",
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment:
                          Alignment.bottomRight, // Ensure proper alignment
                      child: FittedBox(
                        // Prevents overflow by resizing dynamically
                        child: SalonRatingWidget(salonId: salon.id!),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: 135.w), // Limit width to 150 pixels(
                      child: BigText(
                        maxLines: 1,
                        text: salon.name!,
                        color: AppColor.backgroundicons,
                        size: 18.sp,
                      ),
                    ),
                    IconAndTextWidget(
                      icon: 'assets/images/icon/call-calling.png',
                      text: salon.phone!,
                      iconColor: AppColor.primaryColor,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/icon/location.png', // Ensure this is a valid image path string
                        height: 25.h, // Adjust size as needed
                        width: 25.w,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: 160.w), // Limit width to 150 pixels
                          child: SmallText(
                            height: 1,
                            fontFamily: 'Cairo',
                            maxline: 2,
                            overFlow: TextOverflow
                                .ellipsis, // Ensure text truncates with "..."
                            text: "${salon.city} | ${salon.address}".trArgs(),
                            color: Colors.black,
                            size: 10.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  //SizedBox(width: 92.w),
                  IconAndTextWidget(
                    icon: salon.categoryId! == 1
                        ? "assets/images/icon/man.png"
                        : "assets/images/icon/woman.png",
                    text: salon.categoryId == 1 ? "Men".tr : "Women".tr,
                    iconColor: AppColor.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
