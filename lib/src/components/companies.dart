import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:go_food_br/src/blocs/filter-bloc.dart';
import 'package:go_food_br/src/components/company-card.dart';
import 'package:go_food_br/src/components/filter.dart';
import 'package:go_food_br/src/components/ordenar.dart';
import 'package:go_food_br/src/components/tile-filter.dart';
import 'package:go_food_br/src/model/company-model.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app-bloc.dart';
import '../app-settings.dart';

class Companies extends StatefulWidget {
  @override
  _CompaniesState createState() => _CompaniesState();
}

class _CompaniesState extends State<Companies> {
  final appBloc = BlocProvider.getBloc<AppBloc>();
  final filterBloc = BlocProvider.getBloc<FilterBloc>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, Map<String, dynamic>>>(
      stream: filterBloc.filterStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          );
        }
        return Container(
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),
              bottom: ScreenUtil().setHeight(20)
          ),
          color: Colors.white,
          padding: EdgeInsets.only(
              top: ScreenUtil().setHeight(20),
              left: ScreenUtil().setWidth(20),
            right: ScreenUtil().setWidth(20),
          ),
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(15)),
                child: Text(
                  'Restaurantes',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(36)
                  ),
                ),
              ),
              Container(
                height: ScreenUtil().setHeight(55),
                child: ListView(
                  physics: BouncingScrollPhysics(),
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
                      color: snapshot.data.containsKey("ord") && !snapshot.data["ord"].containsKey("padrao")
                          ? primaryColor
                          : null,
                      textColor: snapshot.data.containsKey("ord") && !snapshot.data["ord"].containsKey("padrao")
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
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              StreamBuilder<List<Company>>(
                stream: appBloc.companiesOut,
                builder: (context, snapshotCompany) {
                  if(!snapshotCompany.hasData){
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
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
                                ? Container(
                                  height: ScreenUtil().setHeight(300),
                                  child: Center(
                                      child: Text(
                                        "Nenhum resultado encontrado",
                                        style: GoogleFonts.poppins(
                                            color: primaryColor,
                                            fontSize: ScreenUtil().setSp(30)),
                                      ),
                                    ),
                                )
                                :  Container(
                    height: ScreenUtil().setHeight(190 * snapshotCompany.data.length),
                    child: ListView.builder(
                      itemCount: lista.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index){
                        return CompanyCard(lista[index]);
                      },
                    )
                  );
                }
              ),
              SizedBox(
                height: ScreenUtil().setHeight(50),
              ),
            ],
          ),
        );
      }
    );
  }
}

