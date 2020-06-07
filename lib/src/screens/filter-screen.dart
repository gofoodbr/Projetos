import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_food_br/src/app-settings.dart';
import 'package:go_food_br/src/blocs/filter-bloc.dart';
import 'package:go_food_br/src/components/bottom-bar-carrinho.dart';
import 'package:go_food_br/src/components/company-card.dart';
import 'package:go_food_br/src/components/filter.dart';
import 'package:go_food_br/src/components/ordenar.dart';
import 'package:go_food_br/src/components/tile-filter.dart';
import 'package:go_food_br/src/model/company-model.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app-bloc.dart';
import 'package:go_food_br/src/model/bottom_navigator_item.dart';



class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final filterBloc = BlocProvider.getBloc<FilterBloc>();
  final appBloc = BlocProvider.getBloc<AppBloc>();

  @override
  void initState() {
    super.initState();
    filterBloc.companiesIn(appBloc.getListCompanies());
  }

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

    return WillPopScope(
      onWillPop: () async {
        filterBloc.resetFilter();
        return true;
      },
      
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 20,
        onTap: (value){
         
          if(value == 1) Navigator.popAndPushNamed(context, '/filter_screen');
          if(!appBloc.convidado){
            if(value == 3) Navigator.popAndPushNamed(context, '/profile_screen');
            if(value == 2) Navigator.popAndPushNamed(context, "/pedidos_screen");
          }
          if(value == 0) Navigator.pop(context);
        },
        items: _buildBottomIcon(),
      ),
        bottomSheet: bottomBarCarrinho(appBloc, context),
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(
            "Restaurantes",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: StreamBuilder<Map<String, Map<String, dynamic>>>(
            stream: filterBloc.filterStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                );
              }
              print(snapshot.data);
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: ScreenUtil().setHeight(100),
                      padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          tileFilter("Filtros",
                              icon: Icons.filter_list,
                              color: snapshot.data["filter"] != null &&
                                      snapshot.data["filter"].isNotEmpty
                                  ? primaryColor
                                  : null,
                              textColor: snapshot.data["filter"] != null &&
                                      snapshot.data["filter"].isNotEmpty
                                  ? Colors.white
                                  : null, onTap: () {
                            filterRequest(context,
                                items: appBloc.listCategories,
                                filterBloc: filterBloc);
                          }),
                          tileFilter("Ordenar",
                              onTap: (){
                                orderRequest(context,
                                  filterBloc: filterBloc
                                );
                              },
                              icon: Icons.arrow_drop_down,
                              color: snapshot.data.containsKey("ord")
                                  ? primaryColor
                                  : null,
                              textColor: snapshot.data.containsKey("ord")
                                  ? Colors.white
                                  : null),
                          tileFilter("Entrega Grátis",
                              icon: Icons.directions_car,
                              color: snapshot.data["filter"] != null &&
                                      snapshot.data["filter"].isNotEmpty &&
                                      snapshot.data["filter"]["frete"] == 1
                                  ? primaryColor
                                  : null,
                              textColor: snapshot.data["filter"] != null &&
                                      snapshot.data["filter"].isNotEmpty &&
                                      snapshot.data["filter"]["frete"] == 1
                                  ? Colors.white
                                  : null, onTap: () {
                            if (snapshot.data["filter"] != null &&
                                snapshot.data["filter"].isNotEmpty &&
                                snapshot.data["filter"]["frete"] == 1) {
                              filterBloc.resetFilter(frete: true);
                            } else {
                              filterBloc.addFilter(frete: 1);
                            }
                          })
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(20)),
                        child: StreamBuilder<List<Company>>(
                          stream: filterBloc.companiesOut,
                          builder: (context, snapshotCompany) {
                            if (!snapshotCompany.hasData) {
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      primaryColor),
                                ),
                              );
                            }
                            List<Company> lista = [];
                            lista.addAll(snapshotCompany.data);

                            if (snapshot.data.containsKey("filter")) {
                              if (snapshot.data["filter"].containsKey("km")) {
                                lista.retainWhere((company) =>
                                    double.parse(company.distanciaCliente) <=
                                    snapshot.data["filter"]["km"]);
                              }
                              if (snapshot.data["filter"].containsKey("cat")) {
                                lista.retainWhere((company) =>
                                    company.categoria.categoriaId ==
                                    snapshot.data["filter"]["cat"]);
                              }
                              if (snapshot.data["filter"]
                                  .containsKey("frete")) {
                                if (snapshot.data["filter"]["frete"] == 1) {
                                  lista.retainWhere((company) =>
                                      double.parse(company.valorFrete) == 0.0);
                                }
                              }
                              if (snapshot.data["filter"].containsKey("name")) {
                                lista.retainWhere((company) =>
                                    company.empresaNome.toUpperCase().contains( snapshot.data["filter"]["name"].toUpperCase()));
                              }
                            }
                            if (snapshot.data.containsKey("ord")) {
                              if (snapshot.data["ord"].containsKey("frete")) {
                                lista.sort((a, b) => double.parse(a.valorFrete)
                                    .compareTo(double.parse(b.valorFrete)));
                              }
                              if (snapshot.data["ord"].containsKey("time")) {
                                lista.sort((a, b) => double.parse(
                                        a.tempoMaximoEntrega)
                                    .compareTo(
                                        double.parse(b.tempoMaximoEntrega)));
                              }
                              if (snapshot.data["ord"]
                                  .containsKey("distancia")) {
                                lista.sort((a, b) =>
                                    double.parse(a.distanciaCliente).compareTo(
                                        double.parse(b.distanciaCliente)));
                              }
                               if (snapshot.data["ord"]
                                  .containsKey("padrao")) {
                                lista.sort((a, b) =>
                                    double.parse(a.classificao).compareTo(
                                        double.parse(b.classificao)));
                              }
                            }
                            return lista.length == 0
                                ? Center(
                                    child: Text(
                                      "Nenhum resultado encontrado",
                                      style: GoogleFonts.poppins(
                                          color: primaryColor,
                                          fontSize: ScreenUtil().setSp(30)),
                                    ),
                                  )
                                : ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    itemCount: lista.length,
                                    itemBuilder: (context, index) {
                                      return CompanyCard(lista[index]);
                                    },
                                  );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
