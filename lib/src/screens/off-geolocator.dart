import 'dart:io';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:go_food_br/src/app-settings.dart';
import 'package:go_food_br/src/model/endereco-model.dart';
import 'package:go_food_br/src/services/geolocation-service.dart';
import 'package:location/location.dart';

import '../app-bloc.dart';

class OffGeolocatoPage extends StatefulWidget {
  @override
  _OffGeolocatoPageState createState() => _OffGeolocatoPageState();
}

class _OffGeolocatoPageState extends State<OffGeolocatoPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final appBloc = BlocProvider.getBloc<AppBloc>();
  bool isProcessing;
  LocationData location;
  @override
  void initState() {
    isProcessing = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.zoom_out_map,
              color: primaryColor,
              size: 80.0,
            ),
            SizedBox(height: 10.0),
            Text(
              "Não foi possível obter a localização",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.0),
            Text(
              "Verifique o seu GPS e tente novamente.",
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            Container(
                child: !isProcessing
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () => exit(0),
                            child: Text(
                              "Sair",
                              style: TextStyle(fontSize: 16.0),
                            ),
                            color: Colors.white,
                          ),
                          RaisedButton(
                            color: primaryColor,
                            onPressed: () {
                              getLocation(1, timeOut: 30, appBloc: appBloc)
                                  .then((value) {
                                if (appBloc.location != null) {
                                 Navigator.pop(context);
                                }
                              });
                              
                            },
                            child: Text(
                              "Tentar Novamente",
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    : null),
            Container(
              child: isProcessing
                  ? CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(primaryColor),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
