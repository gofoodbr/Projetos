import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:go_food_br/src/app-settings.dart';

import '../app-services.dart';

class OffInternetPage extends StatefulWidget {
  @override
  _OffInternetPageState createState() => _OffInternetPageState();
}

class _OffInternetPageState extends State<OffInternetPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var _connectionStatus = 'Unknown';
  final Connectivity connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> subscription;

  bool isProcessing;

  @override
  void initState() {
    isProcessing = false;
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          setState(() => _connectionStatus = result.toString());
          print(_connectionStatus);
        });

    // Verificando o estado atual da conectividade
    connectivity.checkConnectivity().then((result) {
      setState(() => _connectionStatus = result.toString());
      print("result=$result");
    });

    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: primaryColor,
        actions: <Widget>[
          IconButton(
            icon: _connectionStatus == "ConnectivityResult.wifi"
                ? Icon(Icons.wifi)
                : _connectionStatus == "ConnectivityResult.mobile"
                ? Icon(Icons.signal_wifi_4_bar)
                : Icon(Icons.signal_wifi_off),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.portable_wifi_off,
              color: primaryColor,
              size: 80.0,
            ),
            SizedBox(height: 10.0),
            Text(
              "Não é possível conectar",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.0),
            Text(
              "Verifique a sua rede e tente novamente.",
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
                      onPressed: _verificaAcessoIntenet,
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
