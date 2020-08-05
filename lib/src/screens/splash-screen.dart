import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:go_food_br/src/app-bloc.dart';
import '../app-settings.dart';
import 'package:flutter_screenutil/screenutil.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final appBloc = BlocProvider.getBloc<AppBloc>();

  @override
  void initState() {
    super.initState();
    appBloc.initApp();
  }


  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: screenWidthBase, height: screenHeightBase);

    return Scaffold(
      body: StreamBuilder<int>(
        stream: appBloc.loadOut,
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Container(
              color: primaryColor,
              child: Center(
                child: Image.asset("assets/images/logo.png",
                  height: ScreenUtil().setHeight(300),
                ),
              ),
            );
          }
          if(snapshot.data == 1){
            Future.delayed(Duration(microseconds: 500)).then((_){
              Navigator.pushReplacementNamed(context, "/net");
            });
            appBloc.loadIn(0);
          }
          if(snapshot.data == 2){
            Future.delayed(Duration(microseconds: 500)).then((_){
              Navigator.pushReplacementNamed(context, "/home");
            });
            appBloc.loadIn(0);
          }
          if(snapshot.data == 3 || snapshot.data == 4 || snapshot.data == 6 || snapshot.data == 7 || snapshot.data == 8){
            Future.delayed(Duration(microseconds: 500)).then((_){
              Navigator.pushReplacementNamed(context, "/login");
            });
            appBloc.loadIn(0);
          }
          if(snapshot.data == 5){
            Future.delayed(Duration(microseconds: 500)).then((_){
              Navigator.pushNamed(context, "/register_endereco").then((_){
                Navigator.pushReplacementNamed(context, "/");
              });
            });
            appBloc.loadIn(0);
          }
           if(snapshot.data == 10){
            Future.delayed(Duration(microseconds: 500)).then((_){
              Navigator.pushReplacementNamed(context, "/geolocator_off");
            });
            appBloc.loadIn(0);
          }
          return Container(
            color: primaryColor,
            child: Center(
              child: Image.asset("assets/images/logo.png",
                height: ScreenUtil().setHeight(300),
              ),
            ),
          );
        }
      ),
    );
  }
}
