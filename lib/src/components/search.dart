import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_food_br/src/app-settings.dart';
import 'package:go_food_br/src/blocs/filter-bloc.dart';

class Search extends StatelessWidget {
  final TextEditingController controller;
  Search(this.controller);

  FilterBloc filterBloc = BlocProvider.getBloc<FilterBloc>();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setHeight(30)),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey.shade100,
                ),
                child: TextField(
                  controller: controller,
                  onEditingComplete: (){
                    controller.text = "";
                    Navigator.pushNamed(context, "/filter_screen");
                  },
                  onChanged: (value){
                    filterBloc.addFilter(name: value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Restaurante ou Categoria',
                    border: InputBorder.none,
                    
                    prefixIcon: Icon(
                      Icons.search,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
