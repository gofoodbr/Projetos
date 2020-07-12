import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:go_food_br/src/blocs/company-screen-bloc.dart';
import 'package:go_food_br/src/blocs/item-bloc.dart';
import 'package:go_food_br/src/model/product-model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import '../app-bloc.dart';
import '../app-settings.dart';

class ProductsPromo extends StatelessWidget {
  final List<Product> products;
  ProductsPromo(this.products);
  final appBloc = BlocProvider.getBloc<AppBloc>();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(30), left: ScreenUtil().setWidth(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              'Produtos em promoção',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(36)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return cardPromo(products[index], context, appBloc);
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget cardPromo(Product product, BuildContext context, AppBloc appBloc) {
  final companyScreenBloc = BlocProvider.getBloc<CompanyScreenBloc>();
  final itemBloc = BlocProvider.getBloc<ItemBloc>();
  Image image;
  if (product.contentType == "image/jpeg" ||
      product.contentType == "image/png") {
    image = Image.memory(base64Decode(product.content));
  }

  return GestureDetector(
      onTap: () {
        product.company = companyScreenBloc.company;
        itemBloc.productsIn(product);
        Navigator.pushNamed(context, "/item_screen");
      },
      child: Padding(
          padding: const EdgeInsets.all(5),
          child: Stack(children: <Widget>[
            Container(
              width: 300,
              padding:
                  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
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
                              Text(
                                product.nomeAbreviado,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: ScreenUtil().setSp(30)),
                              ),
                              Text(
                                product.descricaoProduto,
                                style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: ScreenUtil().setSp(25)),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(15),
                              ),
                              double.parse(product.precoVendaPromocional ==
                                              "null"
                                          ? "0"
                                          : product.precoVendaPromocional) ==
                                      0
                                  ? Text(
                                      "A partir de ${formatPrice(double.parse(product.precoVenda))}",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontSize: ScreenUtil().setSp(28)),
                                    )
                                  : RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text:
                                              "${formatPrice(double.parse(product.precoVendaPromocional))}  ",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: ScreenUtil().setSp(29),
                                              color: Colors.green),
                                        ),
                                        TextSpan(
                                          text:
                                              "${formatPrice(double.parse(product.precoVenda))}",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w300,
                                              fontSize: ScreenUtil().setSp(26),
                                              color: Colors.grey,
                                              decoration:
                                                  TextDecoration.lineThrough),
                                        )
                                      ]),
                                    ),
                              SizedBox(
                                height: ScreenUtil().setHeight(50),
                              ),
                            ],
                          ),
                        ),
                        image == null
                            ? Container()
                            : Image(
                                image: image.image,
                                width: ScreenUtil().setWidth(180),
                                height: ScreenUtil().setHeight(130),
                                fit: BoxFit.fill,
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
            )
          ])));
}
