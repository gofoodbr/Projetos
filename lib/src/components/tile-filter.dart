
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Widget tileFilter(String title, {IconData icon, Function onTap, Color color, Color textColor}){
  return Center(
    child: GestureDetector(
        onTap: onTap,
        child: Container(
        margin: EdgeInsets.only(right: ScreenUtil().setHeight(20)),
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(15)),
        height: ScreenUtil().setHeight(50),
        decoration: BoxDecoration(
            color: color?? Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title,
              style: GoogleFonts.poppins(
                  fontSize: ScreenUtil().setSp(25),
                color: textColor?? Colors.black
              ),
            ),
            SizedBox(width: ScreenUtil().setWidth(25)),
            icon == null ? Container() : Icon(icon,
              size: ScreenUtil().setHeight(30),
              color: textColor?? Colors.black,
            )
          ],
        ),
      ),
    ),
  );
}
