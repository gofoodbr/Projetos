import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_food_br/src/app-settings.dart';

import '../app-services.dart';

class OffGeolocatoPage extends StatefulWidget {
  @override
  _OffGeolocatoPageState createState() => _OffGeolocatoPageState();
}

class _OffGeolocatoPageState extends State<OffGeolocatoPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isProcessing;

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
                      onPressed: (){
                        Navigator.pushReplacementNamed(context, "/");
                      },
                      child: Text(
                        "Tentar Novamente",
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                  ],
                )
                    : null),
            Container(
              child: isProcessing ? CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
              ) : null,
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> _verificaAcessoIntenet() async {
    setState(() {
      isProcessing = true;
    });
    var intenet = await checkInternetAccess();
    if (intenet) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Sucesso ao conectar na internet!"),
        backgroundColor: primaryColor,
        duration: Duration(seconds: 2),
      ));
      Future.delayed(Duration(seconds: 1)).then((_) {
        Navigator.pushReplacementNamed(
            context, "/"
        );
      });
    } else {
      setState(() {
        isProcessing = false;
      });
      print('not connected');
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Falha ao conectar na internet!"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
    }
  }
}
