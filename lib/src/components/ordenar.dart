import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:go_food_br/src/blocs/filter-bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rounded_modal/rounded_modal.dart';

import '../app-settings.dart';

void orderRequest(BuildContext context,
    {FilterBloc filterBloc, bool home = false}) {
  showRoundedModalBottomSheet(
      context: context,
      radius: 20.0, // This is the default
      color: Colors.white, // Also default
      dismissOnTap: false,
      builder: (builder) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(35),
            ),
            height: ScreenUtil().setHeight(450),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Ordenar",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil().setSp(40)),
                    ),
                  ],
                ),
                Expanded(
                    child: StreamBuilder<Map<String, Map<String, dynamic>>>(
                        stream: filterBloc.filterStream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    primaryColor),
                              ),
                            );
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              orderButton(
                                  title: "Padrão",
                                  icon: Icons.add_circle_outline,
                                  onTap: (){
                                    filterBloc.addOrd(
                                      padrao: true
                                    );
                                    if (home) {
                                      Navigator.popAndPushNamed(
                                          context, "/filter_screen");
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  },
                                  selected: snapshot.data.containsKey("ord") && snapshot.data["ord"]["padrao"] != null
                              ),
                              orderButton(
                                title: "Distância",
                                icon: Icons.person_pin,
                                onTap: (){
                                  filterBloc.addOrd(
                                    distancia: true
                                  );
                                  if (home) {
                                    Navigator.popAndPushNamed(
                                        context, "/filter_screen");
                                  } else {
                                    Navigator.pop(context);
                                  }
                                },
                                selected: snapshot.data.containsKey("ord") && snapshot.data["ord"]["distancia"] != null
                              ),
                              orderButton(
                                  title: "Frete",
                                  icon: Icons.attach_money,
                                  onTap: (){
                                    filterBloc.addOrd(
                                      frete: true
                                    );
                                    if (home) {
                                      Navigator.popAndPushNamed(
                                          context, "/filter_screen");
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  },
                                  selected: snapshot.data.containsKey("ord") && snapshot.data["ord"]["frete"] != null
                              ),
                              orderButton(
                                  title: "Tempo de entrega",
                                  icon: Icons.timer,
                                  onTap: (){
                                    filterBloc.addOrd(
                                      time: true
                                    );
                                    if (home) {
                                      Navigator.popAndPushNamed(
                                          context, "/filter_screen");
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  },
                                  selected: snapshot.data.containsKey("ord") && snapshot.data["ord"]["time"] != null
                              ),
                            ],
                          );
                        }))
              ],
            ),
          ),
        );
      });
}

Widget orderButton({
  String title,
  IconData icon,
  Function onTap,
  bool selected
}){
  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          radius: ScreenUtil().setHeight(60),
          backgroundColor: selected ? primaryColor :Colors.grey.shade300,
          child: Icon(
            icon,
            color: selected ? Colors.white :Colors.black54,
            size: ScreenUtil().setHeight(60),
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(10),
        ),
        Container(
          width: ScreenUtil().setHeight(150),
          height: ScreenUtil().setHeight(100),
          child: Text(title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: ScreenUtil().setSp(23),
              fontWeight: FontWeight.w600
            ),
          ),
        )
      ],
    ),
  );
}
