import 'package:easycut/controller/main/salon_detail_controller.dart';
import 'package:easycut/core/class/handling_data_view.dart';
import 'package:easycut/core/constant/color.dart';
import 'package:easycut/core/constant/dimensions.dart';
import 'package:easycut/core/constant/routes.dart';
import 'package:easycut/core/shared/widgets/small_text.dart';
import 'package:easycut/view/widget/main/show_products_salon.dart';
import 'package:easycut/view/widget/main/stack_image_detail.dart';
import 'package:easycut/view/widget/main/stack_salon_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SalonDetails extends StatelessWidget {
  const SalonDetails({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SalonDetailControllerImp());
    Get.lazyPut(() => ShowProductsSalonController());

    return Scaffold(body: GetBuilder<SalonDetailControllerImp>(
      builder: (controller) {
        return GetBuilder<ShowProductsSalonController>(
          builder: (productController) {
            bool hasSelection = controller.selectedIndices.isNotEmpty ||
                productController.selectedIndices.isNotEmpty;

            return HandlingDataView(
              statusRequest: controller.statusRequest,
              widget: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        StackImageDetail(
                            salonImage: "${controller.salon.image}"),
                        Positioned(
                          left: Dimensions.width20.w,
                          right: Dimensions.width20.w,
                          top: Dimensions.height45.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  height: 36.h,
                                  width: 36.w,
                                  decoration: BoxDecoration(
                                      color: AppColor.unselectedservies,
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(
                                          width: 1.5,
                                          color: AppColor.backgroundicons)),
                                  child: IconButton(
                                    icon: const ImageIcon(
                                      color: AppColor.backgroundicons,
                                      AssetImage(
                                          'assets/images/icon/back_arrow.png'),
                                    ),
                                    onPressed: () {
                                      Get.offNamed(AppRoute.home);
                                    },
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  // Share Button
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 36.w,
                                      height: 36.h,
                                      decoration: BoxDecoration(
                                        color: AppColor.unselectedservies,
                                        borderRadius: BorderRadius.circular(10.r),
                                        border: Border.all(
                                          width: 1.5,
                                          color: AppColor.backgroundicons,
                                        ),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.share,
                                          size: 18,
                                          color: AppColor.backgroundicons,
                                        ),
                                        onPressed: () {
                                          _showShareOptions(context, controller);
                                        },
                                      ),
                                    ),
                                  ),

                                  // QR Code Button
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 36.w,
                                      height: 36.h,
                                      decoration: BoxDecoration(
                                        color: AppColor.unselectedservies,
                                        borderRadius: BorderRadius.circular(10.r),
                                        border: Border.all(
                                          width: 1.5,
                                          color: AppColor.backgroundicons,
                                        ),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.qr_code,
                                          size: 18,
                                          color: AppColor.backgroundicons,
                                        ),
                                        onPressed: () {
                                          _showQrCode(context, controller);
                                        },
                                      ),
                                    ),
                                  ),

                                  // Favorite Button (Original code)
                                  controller.isLoggedIn
                                      ? GestureDetector(
                                    onTap: () {
                                      controller.changeFavoriteState();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          width: 36.w,
                                          height: 36.h,
                                          decoration: BoxDecoration(
                                            color: AppColor.unselectedservies,
                                            borderRadius: BorderRadius.circular(10.r),
                                            border: Border.all(
                                              width: 1.5,
                                              color: AppColor.backgroundicons,
                                            ),
                                          ),
                                          child: controller.isFavorite!
                                              ? Image.asset(
                                            'assets/images/icon/Vector.png',
                                            height: 18.h,
                                            width: 18.w,
                                          )
                                              : Image.asset(
                                            'assets/images/icon/heart.png',
                                            height: 18.h,
                                            width: 18.w,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                      : Container(),
                                ],
                              ),
                            ],
                          ),
                        ),
                        StackSalonDetails(
                          salon: controller.salon,
                          services: controller.services,
                          products: controller.products,
                          comments: controller.comments,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 406.w,
                    height: 51.h,
                    margin:
                    const EdgeInsets.only(left: 17, bottom: 10, right: 17),
                    decoration: BoxDecoration(
                      color: hasSelection
                          ? AppColor.selectedColor
                          : const Color(0xffB6B8B9),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        if (controller.isLoggedIn) {
                          Get.offNamed(AppRoute.bookSalonView, arguments: {
                            "services": controller.selectedServices,
                            "salon": controller.salon,
                          });
                        } else {
                          _showLoginBottomSheet(context);
                        }
                      },
                      child: SmallText(
                        size: 20.sp,
                        text: "Book Now".tr,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ));
  }

  // Method to show share options
  void _showShareOptions(BuildContext context, SalonDetailControllerImp controller) {
    final String salonName = controller.salon.name ?? 'Our Salon';
    final String salonAddress = controller.salon.address ?? 'Unknown location';
    final String shareText = 'Check out $salonName at $salonAddress! Book your appointment now with Easy Cut app!';

    // Generate a deep link or app URL (this is a placeholder)
    final String salonLink = 'https://easycuteg.com/salon/${controller.salon.id}';

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.r),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Share Salon'.tr,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildShareOption(
                    context,
                    icon: Icons.message,
                    label: 'Message'.tr,
                    onTap: () {
                      Share.share(shareText + '\n' + salonLink);
                      Navigator.pop(context);
                    },
                  ),
                  _buildShareOption(
                    context,
                    icon: Icons.mail,
                    label: 'Email'.tr,
                    onTap: () {
                      final Uri emailUri = Uri(
                        scheme: 'mailto',
                        path: '',
                        queryParameters: {
                          'subject': 'Check out this salon!',
                          'body': shareText + '\n' + salonLink,
                        },
                      );
                      launchUrl(emailUri);
                      Navigator.pop(context);
                    },
                  ),
                  _buildShareOption(
                    context,
                    icon: Icons.content_copy,
                    label: 'Copy Link'.tr,
                    onTap: () {
                      // This would require clipboard package, but we can use Share.share for now
                      Share.share(salonLink);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Link copied to clipboard'.tr)),
                      );
                    },
                  ),
                  _buildShareOption(
                    context,
                    icon: Icons.more_horiz,
                    label: 'More'.tr,
                    onTap: () {
                      Share.share(shareText + '\n' + salonLink);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper method to build share option
  Widget _buildShareOption(
      BuildContext context, {
        required IconData icon,
        required String label,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50.r,
            height: 50.r,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColor.backgroundicons,
              size: 24.r,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  // Method to show QR code
  void _showQrCode(BuildContext context, SalonDetailControllerImp controller) {
    final String salonId = controller.salon.id?.toString() ?? '0';
    final String salonName = controller.salon.name ?? 'Salon';

    // Generate a deep link or app URL (this is a placeholder)
    final String salonLink = 'https://easycuteg.com/salon/$salonId';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Container(
            padding: EdgeInsets.all(20.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Scan to visit $salonName'.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                Container(
                  height: 200.r,
                  width: 200.r,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: QrImageView(
                      data: salonLink,
                      version: QrVersions.auto,
                      size: 180.r,
                      backgroundColor: Colors.white,
                      errorStateBuilder: (context, error) {
                        return Center(
                          child: Text(
                            'Error generating QR code'.tr,
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Close'.tr,
                        style: TextStyle(
                          color: AppColor.backgroundicons,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // This would ideally use a save image package
                        // For now, we'll just close the dialog
                        Share.share('Check out this salon: $salonLink');
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.selectedColor,
                      ),
                      child: Text(
                        'Share QR Code'.tr,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

void _showLoginBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20.0.r),
      ),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.all(20.0.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Login Required".tr,
              style: TextStyle(
                fontSize: 18.0.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0.h),
            Text(
              "You need to log in to continue. Do you want to log in?".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0.sp,
              ),
            ),
            SizedBox(height: 20.0.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed(AppRoute.login);
                  },
                  child: Text("Log In".tr),
                ),
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("Cancel".tr),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}