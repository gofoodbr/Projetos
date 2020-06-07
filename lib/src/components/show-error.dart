import 'package:flutter/material.dart';

void showError({GlobalKey<ScaffoldState> scaffoldKey, String message, Color color}){
  scaffoldKey.currentState.showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
    ),
  );
}

void showErrorBtn({GlobalKey<ScaffoldState> scaffoldKey, String message, Color color, Function onTap}){
  scaffoldKey.currentState.showSnackBar(
    SnackBar(
      content: GestureDetector(
        onTap: onTap,
        child: Text(message)
        ),
      backgroundColor: color,
    ),
  );
}