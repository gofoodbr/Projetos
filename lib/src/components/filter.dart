import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:go_food_br/src/blocs/filter-bloc.dart';
import 'package:go_food_br/src/components/tile-filter.dart';
import 'package:go_food_br/src/model/categories.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rounded_modal/rounded_modal.dart';

import '../app-settings.dart';

void filterRequest(BuildContext context,
    {List<CategoriesModel> items, FilterBloc filterBloc, bool home = false}) {


  double distancia = 30;
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
                left: ScreenUtil().setWidth(30)),
            height: ScreenUtil().setHeight(500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Filtrar",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil().setSp(40)),
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                Expanded(
                    child: StreamBuilder<Map<String, Map<String, dynamic>>>(
                        stream: filterBloc.filterStream,
                        builder: (context, snapshot) {
                          if(!snapshot.hasData){
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
                              ),
                            );
                          }
                          distancia = snapshot.data["filter"]['km']?? 30;
                          return ListView(
                            children: <Widget>[
                              Container(
                                height: ScreenUtil().setHeight(100),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Distância",
                                      style: GoogleFonts.poppins(
                                          fontSize: ScreenUtil().setSp(30)),
                                    ),
                                    Expanded(
                                      child: Container(child: KmFilter(
                                        onChanged: (value) {
                                          distancia = value;
                                        },
                                        value: snapshot.data["filter"]['km']?? 30,
                                      )),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(30),
                              ),
                              filter("Frete", tiles: [
                                tileFilter("Frete Grátis",
                                  onTap: () {
                                    filterBloc.addFilter(frete: 1);
                                    if (home) {
                                      Navigator.popAndPushNamed(
                                          context, "/filter_screen");
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  },
                                  color: snapshot.data["filter"]["frete"] == 1 ? primaryColor : null,
                                  textColor: snapshot.data["filter"]["frete"] == 1 ? Colors.white : null,
                                ),
                              ]),
                              SizedBox(
                                height: ScreenUtil().setHeight(30),
                              ),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    FlatButton(
                                      onPressed: (){
                                        filterBloc.resetFilter();
                                        Navigator.pop(context);
                                      },
                                      child: Text("Limpar filtros",
                                        style: TextStyle(
                                          color: Colors.white
                                        ),
                                      ),
                                      color: primaryColor,
                                    ),
                                    SizedBox(
                                      width: ScreenUtil().setWidth(30),
                                    ),
                                    FlatButton(
                                      onPressed: (){
                                        filterBloc.addFilter(km: distancia);
                                        if (home) {
                                          Navigator.popAndPushNamed(
                                              context, "/filter_screen");
                                        } else {
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Text("Aplicar distância",
                                        style: TextStyle(
                                          color: Colors.white
                                        ),
                                      ),
                                      color: primaryColor,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        }))
              ],
            ),
          ),
        );
      });
}

Widget filter(String title, {List<Widget> tiles, bool categories = false}) {
  return Container(
    height: ScreenUtil().setHeight(!categories ? 100 : 200),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(30)),
        ),
        Expanded(
          child: Container(
            child: ListView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: tiles),
          ),
        )
      ],
    ),
  );
}

class KmFilter extends StatefulWidget {
  final ValueChanged<double> onChanged;
  final double value;
  KmFilter({this.onChanged, this.value});

  @override
  _KmFilterState createState() => _KmFilterState();
}

class _KmFilterState extends State<KmFilter> {
  double kmFilter = 30;


  @override
  void initState() {
    super.initState();
    kmFilter = widget.value;
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Slider(
            value: kmFilter,
            divisions: 30,
            onChanged: (va) {
              setState(() {
                kmFilter = va;
              });
            },
            onChangeEnd: (va) {
              widget.onChanged(va);
            },
            min: 0,
            max: 30,
            activeColor: primaryColor,
          ),
        ),
        Container(
          child: Text("${kmFilter.round()}km"),
          width: ScreenUtil().setWidth(100),
        ),
      ],
    );
  }
}
