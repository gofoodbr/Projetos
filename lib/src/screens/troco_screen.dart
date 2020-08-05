import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_food_br/src/app-settings.dart';
import '../app-bloc.dart';

class TrocoScreen extends StatefulWidget {
  @override
  _TrocoScreenState createState() => _TrocoScreenState();
}

class _TrocoScreenState extends State<TrocoScreen> {
  MoneyMaskedTextController controller = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.');
  final appBloc = BlocProvider.getBloc<AppBloc>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Escolher troco"),
      ),
      body: loading? Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
        ),
      ) : Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(20),
          vertical: ScreenUtil().setHeight(30)
        ),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
              margin: EdgeInsets.all(ScreenUtil().setHeight(30)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                  color: primaryColor
                ),
              ),
              child: TextField(
                textAlign: TextAlign.center,
                controller: controller,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(39)
                ),
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  prefixText: "R\$",
                  border: InputBorder.none,
                  hintText: "Insira um valor",
                  hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: ScreenUtil().setSp(39)
                ),
                ),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(10),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  onPressed: (){
                    appBloc.addTroco(double.parse(controller.text.replaceAll(",", ".")));
                    Navigator.pop(context, true);
                  },
                  color: primaryColor,
                  child: Text("Inserir",
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}