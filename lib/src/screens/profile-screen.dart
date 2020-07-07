import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_food_br/src/app-settings.dart';
import 'package:go_food_br/src/components/bottom-bar-carrinho.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import '../app-bloc.dart';
import 'package:go_food_br/src/model/bottom_navigator_item.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final appBloc = BlocProvider.getBloc<AppBloc>();


  final List<BottomNavigatorItem> menus = [
    BottomNavigatorItem(icon: Icons.home, text: 'Início', ),
    BottomNavigatorItem(icon: Icons.search, text: 'Busca', ),
    BottomNavigatorItem(icon: Icons.receipt, text: 'Pedidos'),
    BottomNavigatorItem(icon: Icons.person_outline, text: 'Perfil'),
  ];


  @override
  Widget build(BuildContext context) {

    List<BottomNavigationBarItem> _buildBottomIcon() => menus
        .map((menu) => BottomNavigationBarItem(
      icon: Icon(menu.icon, color: Colors.black),
      title: Text(menu.text, style: TextStyle(color: Colors.black)),
    ))
        .toList();

    return Scaffold(
      bottomSheet: bottomBarCarrinho(appBloc, context),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 20,
        onTap: (value){
          if(value == 1) Navigator.pushReplacementNamed(context, '/filter_screen');
          if(!appBloc.convidado){
            if(value == 3) Navigator.pushReplacementNamed(context, '/profile_screen');
            if(value == 2) Navigator.pushReplacementNamed(context, "/pedidos_screen");
          }
          if(value == 0) Navigator.pushReplacementNamed(context, "/home");
        },
        items: _buildBottomIcon(),
      ),
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Meu perfil"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
    
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: ScreenUtil().setHeight(100),
                  child: Center(
                    child: Text("CashBack: ${formatPrice(double.parse(appBloc.userModel.saldoCashBack))}  ",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: ScreenUtil().setSp(35)
                      ),
                    ),
                  ),
                ),
              ],
            ),
            CircleAvatar(
              backgroundColor: Colors.grey.shade400,
              radius: ScreenUtil().setHeight(100),
              child: Center(
                child: Icon(Icons.person,
                  color: Colors.white,
                  size: ScreenUtil().setHeight(100),
                ),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(20),
            ),
            Text(appBloc.userModel.nome,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: ScreenUtil().setSp(33)
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(10),
            ),
            Text(appBloc.userModel.email,
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: ScreenUtil().setSp(33)
              ),
            ),
            Text(appBloc.userModel.celular,
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: ScreenUtil().setSp(33)
              ),
            ),
            Expanded(child: Container()),
            Container(
                  margin: EdgeInsets.only(
                    right: ScreenUtil().setWidth(20)
                  ),
                  height: ScreenUtil().setHeight(150),
                  child: Center(
                    child: Container(
                            padding: EdgeInsets.all(
                              ScreenUtil().setHeight(20)
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: primaryColor,
                                width: 1.5,
                              ) 
                            ),
                            child: Text("Compartilhar meu código:\n${appBloc.userModel.codigoCashBack}",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: ScreenUtil().setSp(30)
                              ),
                            ),
                          ),
                  ),
                ),
                FlatButton(
                  onPressed: (){
                    Clipboard.setData(new ClipboardData(text: appBloc.userModel.codigoCashBack));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Text("Copiar código",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(35)
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                ),
                FlatButton(
                  color: Colors.green,
                  onPressed: (){
                    Share.share(
                      'Baixe o app gofood, insira este codigo *${appBloc.userModel.codigoCashBack}*, e faça como eu, começe a ganhar cashback com indicaçoes, e ganhe 10% na primeira compra. https://play.google.com/store/apps/details?id=br.com.gofoodbr.go_food_br');
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.phone,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(10),
                      ),
                      Center(
                        child: Text("Compartilhar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(35)
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(100),
                ),
            
          ],
        ),
      ),
    );
  }
}