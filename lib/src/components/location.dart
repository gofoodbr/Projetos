import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:go_food_br/src/model/endereco-model.dart';

import '../app-settings.dart';

class Location extends StatelessWidget {
  final EnderecoModel enderecoModel;
  final Function setState;
  Location(this.enderecoModel, this.setState);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(22),
          vertical: ScreenUtil().setHeight(25),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset("assets/images/logo_pink.png",
              height: ScreenUtil().setHeight(70),
            ),
            GestureDetector(
              onTap: (){
                if(enderecoModel.identificacao != null) Navigator.pushNamed(context, "/list_enderecos").then((value){
                  setState();
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'ENTREGAR EM',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w700,
                      fontSize: ScreenUtil().setSp(33),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: primaryColor,
                      ),
                      Text(
                        enderecoModel.identificacao == null ? "Modo Convidado" :
                        '${enderecoModel.logradouro}, ${enderecoModel.numero}',
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil().setSp(30),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
