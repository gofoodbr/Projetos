import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_food_br/src/app-settings.dart';
import 'package:go_food_br/src/components/show-error.dart';

import '../app-bloc.dart';

class CashBackScreen extends StatefulWidget {
  @override
  _CashBackScreenState createState() => _CashBackScreenState();
}

class _CashBackScreenState extends State<CashBackScreen> {
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
        title: Text("Cashback"),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text("Valor disponível: ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: ScreenUtil().setSp(35)
                  ),
                ),
                Text("${formatPrice(double.parse(appBloc.userModel.saldoCashBack))}",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(35)
                  ),
                ),
              ],
            ),
            SizedBox(
              height: ScreenUtil().setHeight(20),
            ),
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
                controller: controller,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(39)
                ),
                textAlign: TextAlign.center,
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
              height: ScreenUtil().setHeight(25),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  onPressed: (){
                    bool value = appBloc.addCashback(double.parse(controller.text.replaceAll(",", ".")));
                    if(value){
                      Navigator.pop(context, true);
                    }else{
                      showError(
                        color: primaryColor,
                        message: "Valor não disponível",
                        scaffoldKey: _scaffoldKey
                      );
                    }
                  },
                  color: primaryColor,
                  child: Text("Transferir",
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