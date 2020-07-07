import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:go_food_br/src/app-settings.dart';
import 'package:go_food_br/src/blocs/filter-bloc.dart';
import 'package:go_food_br/src/components/banner_slide.dart';
import 'package:go_food_br/src/components/bottom-bar-carrinho.dart';
import 'package:go_food_br/src/components/categories.dart';
import 'package:go_food_br/src/components/companie_promo.dart';
import 'package:go_food_br/src/components/companies.dart';
import 'package:go_food_br/src/components/floatingButtonHome.dart';
import 'package:go_food_br/src/components/location.dart';
import 'package:go_food_br/src/components/search.dart';
import 'package:go_food_br/src/model/bottom_navigator_item.dart';
import 'package:go_food_br/src/model/company-model.dart';
import '../app-bloc.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title, this.analytics, this.observer})
      : super(key: key);

  final String title;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _HomeScreenState createState() => _HomeScreenState(analytics, observer);
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeScreenState(this.analytics, this.observer);

  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;

  final appBloc = BlocProvider.getBloc<AppBloc>();
  final filterBloc = BlocProvider.getBloc<FilterBloc>();
  final controller = TextEditingController();
  bool loaded = false;
  @override
  void initState() {
    super.initState();
    appBloc.getCompanies().then((value) {
      setState(() {
        loaded = true;
      });
    });
  }

  final List<BottomNavigatorItem> menus = [
    BottomNavigatorItem(
      icon: Icons.home,
      text: 'Início',
    ),
    BottomNavigatorItem(
      icon: Icons.search,
      text: 'Busca',
    ),
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
      floatingActionButton: FloatingButtonHome(),
      backgroundColor: Colors.grey.shade100,
      body: !loaded
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 200,
                ),
                Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(primaryColor),
                    ))
              ],
            )
          : ListView(
              children: <Widget>[
                Location(appBloc.getListEnderecos()[0], () {
                  setState(() {});
                }),
                Search(controller),
                appBloc.banners.length > 0
                    ? BannerSlide(items: appBloc.banners)
                    : Container(),
                StreamBuilder(
                  stream: appBloc.companiesOut,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == 100) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(primaryColor),
                        ),
                      );
                    }
                    List<Company> companiesPromo = [];
                    companiesPromo.addAll(snapshot.data);
                    companiesPromo
                        .retainWhere((a) => a.descontoGofood != "null");
                    companiesPromo.sort((a, b) => double.parse(b.descontoGofood)
                        .compareTo(double.parse(a.descontoGofood)));

                    return companiesPromo.length == 0
                        ? Container()
                        : CompaniesPromo(companiesPromo);
                  },
                ),
                Categories(
                  items: appBloc.listCategories,
                  filterBloc: filterBloc,
                  onTapCard: () {
                    Navigator.pushReplacementNamed(context, "/filter_screen");
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
        onTap: (value) {
          if (value == 1)
            Navigator.pushReplacementNamed(context, '/filter_screen');
          if (!appBloc.convidado) {
            if (value == 3)
              Navigator.pushReplacementNamed(context, '/profile_screen');
            if (value == 2)
              Navigator.pushReplacementNamed(context, "/pedidos_screen");
          }
        },
        items: _buildBottomIcon(),
      ),
    );
  }
}
