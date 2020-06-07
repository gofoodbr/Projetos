import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app-settings.dart';

class ButtonApp extends StatelessWidget {
  final String title;
  final Function onTap;
  final backgroundColor;
  final borderColor;
  final textColor;

  ButtonApp(this.title, {this.onTap, this.borderColor = Colors.transparent, this.backgroundColor, this.textColor});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: ScreenUtil().setHeight(87),
        width: ScreenUtil().setWidth(600),
        decoration: BoxDecoration(
            color: backgroundColor?? primaryColor,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: borderColor)
        ),
        child: Center(
          child:Text(title,
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: ScreenUtil().setSp(30)
            ),
          ),
        ),
      ),
    );
  }
}
