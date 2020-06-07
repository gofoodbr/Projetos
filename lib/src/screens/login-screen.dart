import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:go_food_br/src/app-bloc.dart';
import 'package:go_food_br/src/components/button-app.dart';
import 'package:go_food_br/src/components/show-error.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app-settings.dart';
import 'package:flutter_screenutil/screenutil.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final appBloc = BlocProvider.getBloc<AppBloc>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: StreamBuilder<int>(
        stream: appBloc.loadOut,
        builder: (context, snapshot) {
          if(!snapshot.hasData || snapshot.data == 100){
            return Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            );
          }
          if(snapshot.data == 2){
            Future.delayed(Duration(microseconds: 500)).then((_){
              Navigator.pushReplacementNamed(context, "/home");
            });
            appBloc.loadIn(0);
          }
          if(snapshot.data == 3){
            Future.delayed(Duration(microseconds: 500)).then((_){
              showError(
                  scaffoldKey: _scaffoldKey,
                  color: primaryColor,
                  message: "Erro ao conectar com Google"
              );
            });
            appBloc.loadIn(0);
          }
          if(snapshot.data == 4){
           Future.delayed(Duration(microseconds: 500)).then((_){
              Navigator.pushNamed(context, "/register").then((value){
                if(value != null){
                  appBloc.loadData();
                }
              });
            });
            appBloc.loadIn(0);
          }
          if(snapshot.data == 5){
           Future.delayed(Duration(microseconds: 500)).then((_){
              Navigator.pushNamed(context, "/register_endereco").then((value){
                if(value != null){
                  appBloc.loadData();
                }
              });
            });
            appBloc.loadIn(0);
          }
          if(snapshot.data == 6){
            Future.delayed(Duration(microseconds: 500)).then((_){
              showError(
                  scaffoldKey: _scaffoldKey,
                  color: primaryColor,
                  message: "Erro ao obter endereços"
              );
            });
            appBloc.loadIn(0);
          }
          if(snapshot.data == 7){
            Future.delayed(Duration(microseconds: 500)).then((_){
              showError(
                  scaffoldKey: _scaffoldKey,
                  color: primaryColor,
                  message: "Erro ao obter categorias"
              );
            });
            appBloc.loadIn(0);
          }
          if(snapshot.data == 8){
            Future.delayed(Duration(microseconds: 500)).then((_){
              showError(
                  scaffoldKey: _scaffoldKey,
                  color: primaryColor,
                  message: "Erro ao obter lojas"
              );
            });
            appBloc.loadIn(0);
          }
          return Stack(
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset("assets/images/logo_pink.png",
                      height: ScreenUtil().setHeight(300),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(200),
                    )
                  ],
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text("Como deseja continuar?",
                      style: GoogleFonts.poppins(
                          color: Color(0xff5F5F5F),
                          fontSize: ScreenUtil().setSp(27)
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    ButtonApp("Entrar com Google",
                      backgroundColor: primaryColor,
                      borderColor: Colors.transparent,
                      textColor: Colors.white,
                      onTap: appBloc.login
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    ButtonApp("Entrar como convidado",
                      backgroundColor: Colors.transparent,
                      borderColor: Color(0xffBEBEBE),
                      textColor: primaryColor,
                      onTap: (){
                        appBloc.modoConvidado();
                      },
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(70),
                    )
                  ],
                ),
              )
            ],
          );
        }
      ),
    );
  }
}
