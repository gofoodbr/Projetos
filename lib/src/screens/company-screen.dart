import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_food_br/src/app-bloc.dart';
import 'package:go_food_br/src/blocs/company-screen-bloc.dart';
import 'package:go_food_br/src/blocs/item-bloc.dart';
import 'package:go_food_br/src/components/bottom-bar-carrinho.dart';
import 'package:go_food_br/src/model/grupo-model.dart';
import 'package:go_food_br/src/model/product-model.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app-settings.dart';

class CompanyScreen extends StatefulWidget {
  @override
  _CompanyScreenState createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  final companyScreenBloc = BlocProvider.getBloc<CompanyScreenBloc>();
  final itemBloc = BlocProvider.getBloc<ItemBloc>();
  final appBloc = BlocProvider.getBloc<AppBloc>();
  @override
  void initState() {
    super.initState();
    companyScreenBloc.getDataCompany();
    companyScreenBloc.gruposSelectIn([]);     
  }

  @override
  Widget build(BuildContext context) {

    Image image;
    if(companyScreenBloc.company.contentType =="image/jpeg" || companyScreenBloc.company.contentType =="image/png"){
      image = Image.memory(base64Decode(companyScreenBloc.company.content), fit: BoxFit.fitWidth,);
    }

    return Scaffold(
      bottomSheet: bottomBarCarrinho(appBloc, context),
      backgroundColor: Colors.grey.shade300,
      body:  CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(companyScreenBloc.company.empresaNome,
              style: TextStyle(
                color: Colors.white
              ),
            ),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  }
              ),
              elevation: 4,
              expandedHeight: 100,
              pinned: true,
              backgroundColor: primaryColor,
              automaticallyImplyLeading: true,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Stack(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: image == null ? Container(
                        child: Image.asset("assets/images/logo_pink.png",
                          fit: BoxFit.contain,
                        ),
                      ) : Image(image: image.image)
                    ),
                    Container(
                      color: primaryColor.withOpacity(0.7),
                    )
                  ],
                )
              )
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(ScreenUtil().setHeight(30)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      child: Text(companyScreenBloc.company.empresaNome,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(35),
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Text(companyScreenBloc.company.categoria.descricao,
                          style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: ScreenUtil().setSp(28),
                          ),
                        ),
                        circleSeparator(),
                        Text("${companyScreenBloc.company.distanciaCliente.replaceAll(".", ",")} km",
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: ScreenUtil().setSp(28),
                          ),
                        ),
                        Expanded(child: Container()),
                        double.parse(companyScreenBloc.company.classificao) == 0 ?
                        Text("Novo",
                          style: GoogleFonts.poppins(
                              color: Colors.amber,
                              fontSize: ScreenUtil().setSp(28)
                          ),
                        )
                            : Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.star,
                                color: Colors.amber,
                                size: ScreenUtil().setHeight(25),
                              ),
                              Text(" ${companyScreenBloc.company.classificao.replaceAll(".", ",")}",
                                style: GoogleFonts.poppins(
                                    color: Colors.amber,
                                    fontSize: ScreenUtil().setSp(28)
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                      height: ScreenUtil().setHeight(100),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Center(
                              child: Icon(Icons.directions_car,
                                color: Colors.grey,
                                size: ScreenUtil().setHeight(40),
                              ),
                            ),
                            width: ScreenUtil().setWidth(100),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Entrega em ${companyScreenBloc.company.tempoMinimoEntrega} - ${companyScreenBloc.company.tempoMaximoEntrega} min",
                                style: GoogleFonts.poppins(
                                  fontSize: ScreenUtil().setSp(25),
                                ),
                              ),
                              Text("Frete ${double.parse(companyScreenBloc.company.valorFrete) == 0 ? "Grátis" : formatPrice(double.parse(companyScreenBloc.company.valorFrete))}",
                                style: GoogleFonts.poppins(
                                  fontSize: ScreenUtil().setSp(25),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(30),
                    ),
                    Text("Pedido Mínimo ${formatPrice(double.parse(companyScreenBloc.company.pedidoMinimo))}",
                      style: GoogleFonts.poppins(
                        color: Colors.black54,
                        fontSize: ScreenUtil().setSp(25),
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<List<GrupoModel>>(
                stream: companyScreenBloc.gruposOut,
                builder: (context, snapshot) {
                  if(!snapshot.hasData || snapshot.data.length == 0){
                    return Container();
                  }
                  return StreamBuilder<List<GrupoModel>>(
                    
                    stream: companyScreenBloc.gruposSelectOut,
                    builder: (context, snapshotSelect) {
                      if(!snapshotSelect.hasData){
                        return Container();
                      }
                      return Container(
                        color: Colors.white,
                        height: ScreenUtil().setHeight(130),
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index){
                            bool selected = snapshotSelect.data.contains(snapshot.data[index]);
                            return GestureDetector(
                              onTap: (){
                                companyScreenBloc.selectGrupo(snapshot.data[index]);
                              },
                              child: Container(
                                height: ScreenUtil().setHeight(130),
                                margin: EdgeInsets.all(ScreenUtil().setHeight(15)),
                                child: Material(
                                  color: selected ? primaryColor : Colors.white,
                                  elevation: 2,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ScreenUtil().setWidth(40)
                                    ),
                                    child: Center(
                                      child: Text(snapshot.data[index].descricao,
                                        style: TextStyle(
                                          color: selected ? Colors.white : Colors.grey,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  );
                }
              ),
              Container(
                margin: EdgeInsets.only(
                  top: ScreenUtil().setHeight(15)
                ),
                color: Colors.white,
                child: StreamBuilder<Map<GrupoModel, List<Product>>>(
                  stream: companyScreenBloc.productsOut,
                  builder: (context, snapshot) {
                    if(!snapshot.hasData || snapshot.data.length == 0){
                      return Container(
                        height: ScreenUtil().setHeight(200),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
                          ),
                        ),
                      );
                    }
                    return StreamBuilder<List<GrupoModel>>(
                      stream: companyScreenBloc.gruposSelectOut,
                      builder: (context, snapshotSelect) {
                        
                        Map<GrupoModel, List<Product>> data = {};

                        if(!snapshotSelect.hasData || snapshotSelect.data.length == 0 ){
                          data = snapshot.data;
                        }else{
                          snapshot.data.forEach((key, value) {
                            if(snapshotSelect.data.where((element) => element.grupoProdutoId == key.grupoProdutoId).length > 0){
                              data[key] = value;
                            }
                          });
                        }

                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index){
                            return grupoTile(
                              companyScreenBloc: companyScreenBloc,
                              itemBloc: itemBloc,
                              title: data.keys.toList()[index].descricao,
                              products: data.values.toList()[index],
                              context: context,
                            );
                          },
                        );
                      }
                    );
                  }
                )
              ),
              SizedBox(
                height: ScreenUtil().setHeight(30),
              )
            ]),
          )
        ],
      ),
    );
  }
}

Widget grupoTile({String title, List<Product> products, BuildContext context, ItemBloc itemBloc, CompanyScreenBloc companyScreenBloc}){
  return Container(
    padding: EdgeInsets.only(
        top: ScreenUtil().setHeight(20)
    ),
    child: Wrap(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
          child: Text(title,
            style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: ScreenUtil().setSp(35),
              fontWeight: FontWeight.w600
            ),
          ),
        ),
        Container(
          height: ScreenUtil().setHeight(20),
        ),
        Container(
          height: 1,
          color: Colors.grey.shade300,
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: products.length,
          itemBuilder: (context, index){
            return productTile(products[index], context, itemBloc, companyScreenBloc);
          },
        )
      ],
    ),
  );
}

Widget productTile(Product product, BuildContext context, ItemBloc itemBloc, CompanyScreenBloc companyScreenBloc){
  Image image;
  if(product.contentType =="image/jpeg" || product.contentType =="image/png"){
    image = Image.memory(base64Decode(product.content), fit: BoxFit.fitHeight, width: ScreenUtil().setHeight(150),);
  }

  return Material(
    color: Colors.white,
    child: InkWell(
      onTap: (){
        product.company = companyScreenBloc.company;
        itemBloc.productsIn(product);
        Navigator.pushNamed(context, "/item_screen");
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(product.nomeAbreviado,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: ScreenUtil().setSp(30)
                          ),
                        ),
                        Text(product.descricaoProduto,
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                              fontSize: ScreenUtil().setSp(25)
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(20),
                        ),
                        double.parse(product.precoVendaPromocional == "null" ? "0" : product.precoVendaPromocional) == 0 ? 
                        Text("A partir de ${formatPrice(double.parse(product.precoVenda))}",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: ScreenUtil().setSp(27)
                          ),
                        ) : RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "${formatPrice(double.parse(product.precoVendaPromocional))}  ",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: ScreenUtil().setSp(29),
                                  color: Colors.green
                                ),
                              ),
                              TextSpan(
                                text: "${formatPrice(double.parse(product.precoVenda))}",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w300,
                                  fontSize: ScreenUtil().setSp(26),
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough
                                ),
                              )
                            ]
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(20),
                        ),
                      ],
                    ),
                  ),
                  image == null ? Container() :
                  Container(
                    margin: EdgeInsets.only(
                      bottom: ScreenUtil().setHeight(20)
                    ),
                    height: ScreenUtil().setHeight(150),
                    width: ScreenUtil().setHeight(150),
                    child: image,
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: Colors.grey.shade300,
            )
          ],
        ),
      ),
    ),
  );
}

Widget circleSeparator(){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(15)),
    child: Icon(
      Icons.brightness_1,
      size: ScreenUtil().setHeight(10),
      color: Colors.grey.shade400,
    ),
  );
}
