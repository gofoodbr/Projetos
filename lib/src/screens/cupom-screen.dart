import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_food_br/src/app-settings.dart';
import 'package:go_food_br/src/components/show-error.dart';

import '../app-bloc.dart';

class CupomScreen extends StatefulWidget {
  @override
  _CupomScreenState createState() => _CupomScreenState();
}

class _CupomScreenState extends State<CupomScreen> {
  TextEditingController controller = TextEditingController();
  final appBloc = BlocProvider.getBloc<AppBloc>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Resgatar cupom"),
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
                controller: controller,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(35)
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Insira um cupom",
                  hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: ScreenUtil().setSp(35)
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
                    setState(() {
                      loading = true;
                    });
                    appBloc.getCupom(controller.text).then((value){
                      if(value){
                        Navigator.pop(context, true);
                      }else{
                        setState(() {
                          loading = false;
                        });
                        showError(
                          color: primaryColor,
                          message: "Cupom inválido",
                          scaffoldKey: _scaffoldKey
                        );
                      }
                    });
                  },
                  color: primaryColor,
                  child: Text("Aplicar",
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