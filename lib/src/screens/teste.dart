import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Teste extends StatefulWidget {
  @override
  _TesteState createState() => _TesteState();
}

class _TesteState extends State<Teste> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Colcoar sua appbar aqui"),),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: ScreenUtil().setHeight(600)
        ),
        itemBuilder: (context, index){
          return Container(
            margin: EdgeInsets.all(
              ScreenUtil().setHeight(20)
            ),
            height: 50,
            color: Colors.red,
          );
        },
      ),
    );
  }
}