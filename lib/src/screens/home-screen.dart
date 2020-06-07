import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:go_food_br/src/app-settings.dart';
import 'package:go_food_br/src/blocs/filter-bloc.dart';
import 'package:go_food_br/src/components/banner_slide.dart';
import 'package:go_food_br/src/components/bottom-bar-carrinho.dart';
import 'package:go_food_br/src/components/categories.dart';
import 'package:go_food_br/src/components/companie_promo.dart';
import 'package:go_food_br/src/components/companies.dart';
import 'package:go_food_br/src/components/location.dart';
import 'package:go_food_br/src/components/search.dart';
import 'package:go_food_br/src/model/banner_card.dart';
import 'package:go_food_br/src/model/bottom_navigator_item.dart';
import 'package:go_food_br/src/model/company-model.dart';
import '../app-bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final appBloc = BlocProvider.getBloc<AppBloc>();
  final filterBloc = BlocProvider.getBloc<FilterBloc>();
  final controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final List<CardImageItem> banners = [
    CardImageItem(image: 'assets/images/restaurantes-0.png', text: 'Confira sua entrega grátis na sacola'),
    CardImageItem(image: 'assets/images/restaurantes-1.png', text: 'A taxa é corterisa para voce'),
    CardImageItem(image: 'assets/images/restaurantes-2.png', text: 'Comida gostosa e sem taxas'),
    CardImageItem(image: 'assets/images/retirar.png', text: 'Peça e retira no restaurante'),
  ];

  final List<BottomNavigatorItem> menus = [
    BottomNavigatorItem(icon: Icons.home, text: 'Início', ),
    BottomNavigatorItem(icon: Icons.search, text: 'Busca', ),
    BottomNavigatorItem(icon: Icons.receipt, text: 'Pedidos'),
    BottomNavigatorItem(icon: Icons.person_outline, text: 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {

    List<BottomNavigationBarItem> _buildBottomIcon() => menus
        .map((menu) => BottomNavigationBarItem(
      icon: Icon(menu.icon, color: Colors.black),
      title: Text(menu.text, style: TextStyle(color: Colors.black)),
    ))
        .toList();


    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: ListView(
        children: <Widget>[
          Location(appBloc.getListEnderecos()[0], (){
            setState(() {
              
            });
          }),
          Search(controller),
          appBloc.banners.length > 0 ? BannerSlide(items: appBloc.banners) : Container(),
          StreamBuilder(
            stream: appBloc.companiesOut,
            builder: (context, snapshot){
              if(!snapshot.hasData || snapshot.data == 100){
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                );
              }
              List<Company> companiesPromo = [];
              companiesPromo.addAll(snapshot.data);
              companiesPromo.retainWhere((a) => a.descontoGofood != "null");
              companiesPromo.sort((a, b)=> double.parse(b.descontoGofood).compareTo(double.parse(a.descontoGofood)));

              return companiesPromo.length == 0 ? Container() : CompaniesPromo(companiesPromo);
            },
          ),

          Categories(
            items: appBloc.listCategories,
            filterBloc: filterBloc,
            onTapCard: (){
              Navigator.pushNamed(context, "/filter_screen");
            },
          ),
          Companies()
        ],
      ),
      bottomSheet: bottomBarCarrinho(appBloc, context),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 20,
        onTap: (value){
          if(value == 1) Navigator.pushNamed(context, '/filter_screen');
          if(!appBloc.convidado){
            if(value == 3) Navigator.pushNamed(context, '/profile_screen');
            if(value == 2) Navigator.pushNamed(context, "/pedidos_screen");
          }
        },
        items: _buildBottomIcon(),
      ),
    );
  }
}

