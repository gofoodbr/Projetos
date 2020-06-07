import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:go_food_br/src/app-settings.dart';
import 'package:go_food_br/src/blocs/filter-bloc.dart';
import 'package:go_food_br/src/model/categories.dart';

import 'card_image.dart';


class Categories extends StatelessWidget {
  final List<CategoriesModel> items;
  final Function onTapCard;
  final FilterBloc filterBloc;

  const Categories({@required this.items, this.onTapCard, this.filterBloc});

  List<Widget> _buildCategories() => items
      .map((category) => CardImage(
            onTap: (){
              filterBloc.addFilter(cat: category.categoriaId);
            },
            format: CardImageType.category,
            image: "$urlApi${category.urlImagem}",
            text: category.descricao,
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
      color: Colors.white,
      height: ScreenUtil().setHeight(280),
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(20), left: ScreenUtil().setWidth(20)),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(15)),
            child: Text(
              'Categorias',
              style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: ScreenUtil().setSp(36)
              ),
            ),
          ),
          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: _buildCategories(),
            ),
          ),
        ],
      ),
    );
  }
}
