import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:go_food_br/src/app-bloc.dart';
import 'package:go_food_br/src/model/complemento-model.dart';
import 'package:go_food_br/src/model/opcional.dart';
import 'package:go_food_br/src/model/product-model.dart';
import 'package:go_food_br/src/model/sabor.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app-settings.dart';

Widget bottomBarCarrinho(AppBloc appBloc, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, "/carrinho_screen");
    },
    child: StreamBuilder<List<Product>>(
        stream: appBloc.carrinhoOut,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.length == 0) {
            return Container(
              height: 1,
            );
          }
          int quantidade = 0;
          double valor = 0;

          for (Product product in snapshot.data) {
            quantidade += product.quantidade;
            double valorProduto = 0;
            valorProduto += double.parse(product.precoVenda);
            if (product.company.preferenciaMaiorPrecoSabor &&
                product.sabores.length > 0) {
              double maiorPrecoSabor = 0;
              for (Sabor sabor in product.sabores) {
                if (double.parse(sabor.valorTotal) > 0) {
                  if (double.parse(sabor.valorTotal) > maiorPrecoSabor)
                    maiorPrecoSabor = double.parse(sabor.valorTotal);
                }
              }
              if (maiorPrecoSabor > 0) valorProduto = maiorPrecoSabor;
            } else if (!product.company.preferenciaMaiorPrecoSabor &&
                product.sabores.length > 0) {
              double preco = 0;
              for (Sabor sabor in product.sabores) {
                if (double.parse(sabor.valorTotal) > 0)
                  preco +=
                      double.parse(sabor.valorTotal) / product.sabores.length;
              }
              if (preco > 0) valorProduto = preco;
            }

            for (Complemento c in product.complementos) {
              valorProduto += double.parse(c.produtoComplemento.precoVenda);
            }

            for (Opcional o in product.opcionais) {
              if (o.valorTotal != 'null')
                valorProduto += double.parse(o.valorTotal);
            }

            valor += valorProduto * product.quantidade;
          }

          return Container(
            padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
            color: primaryColor,
            height: ScreenUtil().setHeight(90),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  quantidade.toString(),
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontSize: ScreenUtil().setSp(30)),
                ),
                Text(
                  "Ver Carrinho",
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontSize: ScreenUtil().setSp(28)),
                ),
                Text(
                  formatPrice(valor),
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontSize: ScreenUtil().setSp(28)),
                ),
              ],
            ),
          );
        }),
  );
}
