import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardImage extends StatelessWidget {
  final String image;
  final String text;
  final CardImageType format;
  final CrossAxisAlignment textAlign;
  final bool assets;
  final Function onTap;

  const CardImage(
      {@required this.image,
      @required this.text,
      this.format = CardImageType.banner,
      this.textAlign = CrossAxisAlignment.center,
      this.assets = false,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: ScreenUtil().setWidth(18)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: format == CardImageType.banner
                    ? Image(image : AdvancedNetworkImage(
                          image,
                          useDiskCache: true,
                          cacheRule: CacheRule(maxAge: const Duration(days: 1)),
                        ),
                        width: ScreenUtil().setWidth(450))
                    : Image(image : AdvancedNetworkImage(
                          image,
                          useDiskCache: true,
                          cacheRule: CacheRule(maxAge: const Duration(days: 1)),
                        ), width: ScreenUtil().setWidth(170)),
              ),
            ),
            Container(
              width: ScreenUtil()
                  .setWidth(format == CardImageType.category ? 180 : 400),
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                      fontSize: ScreenUtil().setSp(26)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum CardImageType {
  banner,
  category,
}

double handleImageHeight(CardImageType type) {
  final banners = {
    CardImageType.banner: 210.0,
    CardImageType.category: 130.0,
  };
  return banners[type];
}
