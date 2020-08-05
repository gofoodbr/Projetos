import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../app-bloc.dart';
import '../app-settings.dart';

class FloatingButtonHome extends StatefulWidget {
  @override
  _FloatingButtonHomeState createState() => _FloatingButtonHomeState();
}

class _FloatingButtonHomeState extends State<FloatingButtonHome> {
  final appBloc = BlocProvider.getBloc<AppBloc>();
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: FloatingActionButton(
          backgroundColor: primaryColor,
          child: new Icon(Icons.update),
          onPressed: () {
            appBloc.getCompanies();
          },
        ));
  }
}
