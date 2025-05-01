import 'package:easycut/controller/rating/rating_controller.dart';
import 'package:easycut/core/class/handling_data_view.dart';
import 'package:easycut/core/constant/color.dart';
import 'package:easycut/view/widget/auth/custom_button_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DetailedRatingView extends StatelessWidget {
  final String bookingId;

  const DetailedRatingView({Key? key, required this.bookingId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RatingController());
    controller.init(newBookingId: bookingId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Rate Your Experience'.tr),
        backgroundColor: AppColor.selectedColor,
        elevation: 0,
      ),
      body: GetBuilder<RatingController>(
        builder: (controller) {
          return HandlingDataView(
            statusRequest: controller.statusRequest,
            widget: controller.hasRated
                ? _buildAlreadyRatedView(controller)
                : _buildRatingForm(controller),
          );
        },
      ),
    );
  }

  Widget _buildAlreadyRatedView(RatingController controller) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80.r,
            ),
            SizedBox(height: 20.h),
            Text(
              'You have already rated this booking'.tr,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            Text(
              'Thank you for your feedback!'.tr,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
            CustomButtonAuth(
              onPressed: () => Get.back(),
              text: 'Back'.tr,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingForm(RatingController controller) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.star_rate_rounded,
                  color: AppColor.selectedColor,
                  size: 60.r,
                ),
                SizedBox(height: 10.h),
                Text(
                  'How was your experience?'.tr,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  'Your feedback helps us improve our service'.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          SizedBox(height: 40.h),

          // Service Quality Rating
          _buildRatingSection(
            title: 'Service Quality'.tr,
            initialRating: controller.serviceQualityRating.value,
            onRatingUpdate: (rating) => controller.setServiceQualityRating(rating),
          ),

          SizedBox(height: 25.h),

          // Cleanliness Rating
          _buildRatingSection(
            title: 'Cleanliness'.tr,
            initialRating: controller.cleanlinessRating.value,
            onRatingUpdate: (rating) => controller.setCleanlinessRating(rating),
          ),

          SizedBox(height: 25.h),

          // Customer Service Rating
          _buildRatingSection(
            title: 'Customer Service'.tr,
            initialRating: controller.customerServiceRating.value,
            onRatingUpdate: (rating) => controller.setCustomerServiceRating(rating),
          ),

          SizedBox(height: 30.h),

          // Additional Comment
          Text(
            'Additional Comments (Optional)'.tr,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          TextField(
            controller: controller.commentController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Tell us more about your experience...'.tr,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColor.selectedColor, width: 2),
              ),
            ),
          ),

          SizedBox(height: 40.h),

          // Submit Button
          CustomButtonAuth(
            onPressed: () => controller.submitDetailedRating(),
            text: 'Submit Rating'.tr,
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection({
    required String title,
    required double initialRating,
    required Function(double) onRatingUpdate,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            RatingBar.builder(
              initialRating: initialRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemSize: 36.r,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.r),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: onRatingUpdate,
            ),
            SizedBox(width: 15.w),
            Text(
              initialRating.toStringAsFixed(0),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}