import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_food_br/src/model/banner.dart';

import '../app-settings.dart';
import 'card_image.dart';


class BannerSlide extends StatelessWidget {
  final List<BannerModel> items;

  const BannerSlide({@required this.items});

  List<Widget> _buildBanners() => items
      .map((banner) => CardImage(
            image: "$urlApi${banner.urlBanner}",
            text: banner.descricao,
            format: CardImageType.banner,
            textAlign: CrossAxisAlignment.start,
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(20), top: ScreenUtil().setHeight(30)),
        child: Container(
          height: ScreenUtil().setHeight(300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
            scrollDirection: Axis.horizontal,
            children: _buildBanners(),
          ),
        ),
      ),
    );
  }
}
