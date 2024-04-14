import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutx/widgets/button/button.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:get/get.dart';
import 'package:marcci/theme/app_theme.dart';
import 'package:shimmer/shimmer.dart';

import '../sections/widgets.dart';
import 'AppConfig.dart';
import 'Utils.dart';

Widget title_detail_widget2(String title, String detail) {
  return Container(
    padding: const EdgeInsets.only(left: 15, right: 15, top: 0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        FxText.titleMedium(
          "${title.toUpperCase()} :",
          fontWeight: 800,
          color: Colors.black,
        ),
        const SizedBox(
          width: 5,
        ),
        FxText.bodyMedium(
          detail.isEmpty ? "-" : detail,
          color: Colors.grey.shade600,
        ),
      ],
    ),
  );
}


Widget roundedImage(String url, double w, double h,
    {String no_image= AppConfig.NO_IMAGE, double radius= 10}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: url,
      width: (Get.width / w),
      height: (Get.width / h),
      placeholder: (context, url) => ShimmerLoadingWidget(
        height: double.infinity,
      ),
      errorWidget: (context, url, error) => Image(
        image: AssetImage(no_image),
        fit: BoxFit.cover,
        width: (Get.width / w),
        height: (Get.width / h),
      ),
    ),
  );
}

Widget valueUnitWidget(BuildContext context, dynamic value, dynamic unit,
    {double fontSize= 6,
    double letterSpacing= -1,
    Color color= Colors.grey,
    Color titleColor= Colors.black,
    fontWeight= FontWeight.w500}) {
  return RichText(
    text: TextSpan(
      style: TextStyle(
        height: 1,
        color: Colors.black,
      ),
      children: <TextSpan>[
        TextSpan(
          text: '${value.toString()}',
          style: TextStyle(
              color: titleColor,
              letterSpacing: letterSpacing,
              fontSize: Utils.mediaWidth(context) / fontSize,
              fontWeight: fontWeight),
        ),
        TextSpan(
          text: ' ${unit.toString()}',
          style: TextStyle(
            color: color,
            fontSize: Utils.mediaWidth(context) / (fontSize * 1),
          ),
        ),
      ],
    ),
    textScaleFactor: 0.5,
  );
}

Widget valueUnitWidget2(dynamic title, dynamic value,
    {double fontSize= 6,
    double letterSpacing= -1,
    Color titleColor= Colors.grey,
    Color color= Colors.black,
    fontWeight= FontWeight.w500}) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FxText.bodySmall(
          '${title.toString().toUpperCase()}:',
          height: 0,
          color: titleColor,
        ),
        FxText.bodyLarge(
          value.toString(),
          height: 0,
          color: color,
          letterSpacing: -.5,
        ),
      ],
    ),
  );
}

Widget myListLoaderWidget(BuildContext context) {
  return ListView(
    children: [
      singleLoadingWidget(context),
      singleLoadingWidget(context),
      singleLoadingWidget(context),
      singleLoadingWidget(context),
      singleLoadingWidget(context),
    ],
  );
}

Widget myContainerLoaderWidget(BuildContext context) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade50,
    highlightColor: Colors.grey.shade300,
    child: FxContainer(
      width: Utils.mediaWidth(context) / 4,
      height: Utils.mediaWidth(context) / 4,
      color: Colors.grey,
    ),
  );
}

Widget singleLoadingWidget(BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(
      left: 15,
      right: 10,
      top: 8,
      bottom: 8,
    ),
    child: Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade50,
          highlightColor: Colors.grey.shade300,
          child: FxContainer(
            width: Utils.mediaWidth(context) / 4,
            height: Utils.mediaWidth(context) / 4,
            color: Colors.grey,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
            child: Shimmer.fromColors(
          baseColor: Colors.grey.shade50,
          highlightColor: Colors.grey.shade300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FxContainer(
                color: Colors.grey,
                height: Utils.mediaWidth(context) / 30,
                width: Utils.mediaWidth(context) / 3,
              ),
              SizedBox(
                height: 5,
              ),
              FxContainer(
                height: Utils.mediaWidth(context) / 14,
                color: Colors.grey,
              ),
              SizedBox(
                height: 5,
              ),
              FxContainer(
                height: Utils.mediaWidth(context) / 14,
                color: Colors.grey,
              ),
              SizedBox(
                height: 5,
              ),
              Flex(
                direction: Axis.horizontal,
                children: [
                  FxContainer(
                    color: Colors.grey,
                    height: Utils.mediaWidth(context) / 30,
                    width: Utils.mediaWidth(context) / 6,
                  ),
                  Spacer(),
                  FxContainer(
                    color: Colors.grey,
                    height: Utils.mediaWidth(context) / 30,
                    width: Utils.mediaWidth(context) / 6,
                  ),
                ],
              )
            ],
          ),
        ))
      ],
    ),
  );
}



Widget listLoader() {
  return SingleChildScrollView(
    child: Column(
      children: [
        singleListLoaderWidget(),
        singleListLoaderWidget(),
        singleListLoaderWidget(),
        singleListLoaderWidget(),
        singleListLoaderWidget(),
        singleListLoaderWidget(),
        singleListLoaderWidget(),
        singleListLoaderWidget(),
        singleListLoaderWidget(),
      ],
    ),
  );
}

singleListLoaderWidget() {
  double h = 100;
  return Container(
    height: 90,
    width: Get.width,
    padding: const EdgeInsets.only(
      left: 10,
      right: 10,
    ),
    child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          children: [
            FxContainer.rounded(
              width: h / 1.4,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  FxContainer(
                    height: h / 6,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  FxContainer(
                    height: h / 6,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FxContainer(
                          height: h / 6,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 2,
                        child: FxContainer(
                          height: h / 6,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        )),
  );
}

Widget myTitle(String title) {
  return Row(
    children: [
      const Expanded(
        child: FxContainer(
          width: 5,
          height: 25,
          color: CustomTheme.primary,
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      Center(
        child: FxText.titleLarge(
          title,
          fontWeight: 700,
          color: Colors.black,
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      const Expanded(
        child: FxContainer(
          width: 5,
          height: 25,
          color: CustomTheme.primary,
        ),
      ),
    ],
  );
}

Widget myImg(String url, double w, double h,
    {String no_image = AppConfig.NO_IMAGE, double radius = 10}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: url,
      width: w,
      height: h,
      placeholder: (context, url) => ShimmerLoadingWidget(
        height: h,
      ),
      errorWidget: (context, url, error) => Image(
        image: AssetImage(no_image),
        fit: BoxFit.cover,
        width: (h),
        height: (w),
      ),
    ),
  );
}

Widget ShimmerLoadingWidget(
    {double width = double.infinity,
      double height = 200,
      bool is_circle = false,
      double padding = 0.0}) {
  return Padding(
    padding: EdgeInsets.all(padding),
    child: SizedBox(
      width: width,
      height: height,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade50,
        highlightColor: Colors.grey.shade300,
        child: const FxContainer(),
      ),
    ),
  );
}


Widget taskDetails(String title, String value) {
  return Row(
    children: [
      FxText.bodyLarge(
        "${title.toUpperCase()}: ",
        fontWeight: 600,
        color: Colors.grey[600],
      ),
      const SizedBox(width: 5,),
      Expanded(
        child: FxText.bodyLarge(
          value,
          fontWeight: 800,
          color: Colors.black,
        ),
      ),
    ],
  );
}

Widget noItemWidget(String title, Function onTap,
    {String buttonText = "Reload"}) {
  if (title.isEmpty) {
    title = "😇 No item found.";
  }
  return SizedBox(
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: Get.height / 3),
        FxText(
          title,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Divider(
          indent: Get.width / 5,
          endIndent: Get.width / 5,
          height: 0,
        ),
        FxButton.text(
            onPressed: () {
              onTap();
            },
            child: Text(buttonText))
      ],
    ),
  );
}


