import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_food_br/src/app-settings.dart';
import 'package:go_food_br/src/blocs/company-screen-bloc.dart';
import 'package:go_food_br/src/components/navigation.dart';
import 'package:go_food_br/src/model/FormaPagamentoDelivery.dart';
import 'package:go_food_br/src/model/complemento-model.dart';
import 'package:go_food_br/src/model/endereco-model.dart';
import 'package:go_food_br/src/model/opcional.dart';
import 'package:go_food_br/src/model/product-model.dart';
import 'package:go_food_br/src/model/sabor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rounded_modal/rounded_modal.dart';

import '../app-bloc.dart';

class CarrinhoScreen extends StatefulWidget {
  @override
  _CarrinhoScreenState createState() => _CarrinhoScreenState();
}

class _CarrinhoScreenState extends State<CarrinhoScreen> {
  final appBloc = BlocProvider.getBloc<AppBloc>();
  final companyScreenBloc = BlocProvider.getBloc<CompanyScreenBloc>();

  @override
  void initState() {
    super.initState();
  }

  int paymentSelect = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double total = 0;
    for (Product product in appBloc.getCarrinho()) {
      if (product != null) {
        total += getValorProduto(product);
      }
    }

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: _scaffoldKey,
          bottomNavigationBar: bottomNavigation(appBloc, context),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: primaryColor,
            title: Text(
              "Finalizar pedido",
              style: TextStyle(color: Colors.white),
            ),
          ),
          bottomSheet: StreamBuilder<FormaPagamentoDelivery>(
              stream: appBloc.formapagamentoOut,
              builder: (context, snapshot) {
                return Material(
                  child: Container(
                    color: Colors.white,
                    height: ScreenUtil().setHeight(150),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          if (appBloc.convidado) {
                            return;
                          }

                          double valorTotal = 0;
                          for (Product product in appBloc.getCarrinho()) {
                            valorTotal += product.toCarrinho()["ValorTotal"];
                          }

                          double valorDesconto = 0;
                          if (appBloc.cupom != null) {
                            valorDesconto =
                                (double.parse(appBloc.cupom.descontoPremiacao) /
                                        100) *
                                    valorTotal;
                          }

                          if (appBloc.getPayment().formaPagamentoDeliveryId ==
                                  2 &&
                              valorTotal +
                                      double.parse(appBloc
                                          .getCarrinho()[0]
                                          .company
                                          .valorFrete) -
                                      valorDesconto -
                                      appBloc.cashback >
                                  appBloc.troco) {
                            showRoundedModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    padding: EdgeInsets.all(
                                        ScreenUtil().setHeight(30)),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          "O troco deve ser maior que o valor total",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                              fontSize: ScreenUtil().setSp(34)),
                                        ),
                                        SizedBox(
                                          height: ScreenUtil().setHeight(20),
                                        ),
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            color: primaryColor,
                                            child: Text(
                                              "Ok",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                      ],
                                    ),
                                  );
                                });
                          } else
                            showRoundedModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    padding: EdgeInsets.all(
                                        ScreenUtil().setHeight(30)),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Confirmar pedido",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                              fontSize: ScreenUtil().setSp(34)),
                                        ),
                                        SizedBox(
                                          height: ScreenUtil().setHeight(20),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.pin_drop,
                                              color: Colors.grey.shade400,
                                              size: ScreenUtil().setHeight(80),
                                            ),
                                            SizedBox(
                                              width: ScreenUtil().setWidth(20),
                                            ),
                                            StreamBuilder(
                                              stream: appBloc.enderecosOut,
                                              builder: (context, snapshot) {
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      snapshot.data[0]
                                                          .identificacao,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: ScreenUtil()
                                                              .setSp(32)),
                                                    ),
                                                    Text(
                                                      "${snapshot.data[0].logradouro}, ${snapshot.data[0].numero}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: ScreenUtil()
                                                              .setSp(32)),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                            Expanded(child: Container()),
                                          ],
                                        ),
                                        SizedBox(
                                          height: ScreenUtil().setHeight(20),
                                        ),
                                        StreamBuilder(
                                          stream: appBloc.formapagamentoOut,
                                          builder: (context, snapshot) {
                                            return Row(
                                              children: <Widget>[
                                                Container(
                                                  width: ScreenUtil()
                                                      .setWidth(100),
                                                  child: Image.network(
                                                      "$urlApi${snapshot.data.imagemUrl}"),
                                                ),
                                                Text(snapshot.data.nome)
                                              ],
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          height: ScreenUtil().setHeight(20),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  appBloc
                                                      .confirmPedido()
                                                      .then((value) {
                                                    if (value != null) {
                                                      showRoundedModalBottomSheet(
                                                          context: context,
                                                          builder: (context) {
                                                            return Container(
                                                              padding: EdgeInsets
                                                                  .all(ScreenUtil()
                                                                      .setHeight(
                                                                          30)),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    value,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize:
                                                                            ScreenUtil().setSp(34)),
                                                                  ),
                                                                  SizedBox(
                                                                    height: ScreenUtil()
                                                                        .setHeight(
                                                                            20),
                                                                  ),
                                                                  FlatButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      color:
                                                                          primaryColor,
                                                                      child:
                                                                          Text(
                                                                        "Ok",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      )),
                                                                ],
                                                              ),
                                                            );
                                                          });
                                                    }
                                                  });
                                                },
                                                color: primaryColor,
                                                child: Text(
                                                  "Ok",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                });
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: snapshot.hasData
                                    ? primaryColor
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                appBloc.convidado
                                    ? "Entre com alguma conta"
                                    : "Finalizar pedido",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(32)),
                              ),
                            ),
                            height: ScreenUtil().setHeight(90),
                            width: ScreenUtil.screenWidthDp -
                                ScreenUtil().setWidth(50)),
                      ),
                    ),
                  ),
                );
              }),
          body: StreamBuilder<int>(
              stream: appBloc.loadOut,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    height: ScreenUtil().setHeight(200),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    ),
                  );
                }
                if (snapshot.data == 1) {
                  Future.delayed(Duration(microseconds: 500)).then((value) {
                    Navigator.pop(context);
                    appBloc.clearCarrinho();
                    Navigator.pushNamed(context, "/pedidos_screen");
                  });
                  appBloc.loadIn(0);
                }
                return appBloc.getCarrinho().length == 0
                    ? Container()
                    : ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                bottom: ScreenUtil().setHeight(20)),
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(20),
                                vertical: ScreenUtil().setHeight(30)),
                            color: Colors.white,
                            width: ScreenUtil.screenWidthDp,
                            child: StreamBuilder<List<EnderecoModel>>(
                                stream: appBloc.enderecosOut,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Entregar em",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: ScreenUtil().setSp(30)),
                                      ),
                                      SizedBox(
                                        height: ScreenUtil().setHeight(20),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, "/list_enderecos");
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.pin_drop,
                                              color: Colors.grey.shade400,
                                              size: ScreenUtil().setHeight(80),
                                            ),
                                            SizedBox(
                                              width: ScreenUtil().setWidth(20),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  snapshot
                                                      .data[0].identificacao,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: ScreenUtil()
                                                          .setSp(32)),
                                                ),
                                                Text(
                                                  "${snapshot.data[0].logradouro}, ${snapshot.data[0].numero}",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: ScreenUtil()
                                                          .setSp(32)),
                                                ),
                                              ],
                                            ),
                                            Expanded(child: Container()),
                                            IconButton(
                                                icon: Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: primaryColor,
                                                    size: ScreenUtil()
                                                        .setHeight(30)),
                                                onPressed: () {})
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: ScreenUtil().setHeight(30),
                                      ),
                                      Divider(),
                                      SizedBox(
                                        height: ScreenUtil().setHeight(20),
                                      ),
                                      Text(
                                        "Entrega padrão",
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: ScreenUtil().setSp(34)),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            "Agora, ${appBloc.getCarrinho()[0].company.tempoMinimoEntrega} - ${appBloc.getCarrinho()[0].company.tempoMaximoEntrega}",
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize:
                                                    ScreenUtil().setSp(30)),
                                          ),
                                          SizedBox(
                                            width: ScreenUtil().setWidth(20),
                                          ),
                                          Icon(
                                            Icons.brightness_1,
                                            size: ScreenUtil().setHeight(10),
                                            color: Colors.black54,
                                          ),
                                          SizedBox(
                                            width: ScreenUtil().setWidth(20),
                                          ),
                                          Text(
                                            (appBloc.getPayment() != null &&
                                                    appBloc
                                                            .getPayment()
                                                            .formaPagamentoDeliveryId ==
                                                        14)
                                                ? "0,00"
                                                : "${formatPrice(double.parse(appBloc.getCarrinho()[0].company.valorFrete))}",
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize:
                                                    ScreenUtil().setSp(30)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(20),
                                vertical: ScreenUtil().setHeight(30)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  appBloc.getCarrinho()[0].company.empresaNome,
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: ScreenUtil().setSp(40),
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: ScreenUtil().setHeight(15),
                                ),
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: appBloc.getCarrinho().length,
                                  itemBuilder: (context, index) {
                                    Product product =
                                        appBloc.getCarrinho()[index];

                                    double valor = getValorProduto(product);

                                    List<Widget> listaComplementos = [];

                                    for (Complemento complemento
                                        in product.complementos) {
                                      listaComplementos.add(Text(
                                        "${complemento.quantidade}x ${complemento.produtoComplemento.descricaoProduto}",
                                        style: TextStyle(color: Colors.grey),
                                      ));
                                    }

                                    for (Opcional opcional
                                        in product.opcionais) {
                                      listaComplementos.add(Text(
                                        "${opcional.quantidade}x ${opcional.descricao}",
                                        style: TextStyle(color: Colors.grey),
                                      ));
                                    }

                                    for (Sabor sabor in product.sabores) {
                                      listaComplementos.add(Text(
                                        "1x ${sabor.descricao}",
                                        style: TextStyle(color: Colors.grey),
                                      ));
                                    }

                                    return Column(
                                      children: <Widget>[
                                        Divider(),
                                        Container(
                                          width: ScreenUtil.screenWidthDp,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    width: ScreenUtil
                                                            .screenWidthDp -
                                                        ScreenUtil()
                                                            .setWidth(280),
                                                    child: Text(
                                                      "${product.quantidade.toString()}x  ${product.nomeAbreviado}",
                                                      maxLines: 2,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontSize: ScreenUtil()
                                                            .setSp(32),
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: listaComplementos,
                                                  )
                                                ],
                                              ),
                                              Expanded(
                                                child: Container(),
                                              ),
                                              Text(
                                                "${formatPrice(valor)}",
                                                maxLines: 2,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize:
                                                      ScreenUtil().setSp(32),
                                                ),
                                              ),
                                              PopupMenuButton<String>(
                                                onSelected: (value) {
                                                  if (appBloc
                                                          .getCarrinho()
                                                          .length ==
                                                      1) {
                                                    Navigator.pop(context);
                                                  }

                                                  List<Product> listaProdutos =
                                                      appBloc.getCarrinho();

                                                  Product value = listaProdutos
                                                      .firstWhere((produto) =>
                                                          produto.produtoId ==
                                                          product.produtoId);
                                                  listaProdutos.remove(value);

                                                  if (listaProdutos.length ==
                                                      0) {
                                                    appBloc.clearCarrinho();
                                                  }

                                                  setState(() {});
                                                },
                                                enabled: true,
                                                child: IconButton(
                                                    icon: Icon(
                                                      Icons.more_vert,
                                                      color: primaryColor,
                                                    ),
                                                    onPressed: null),
                                                itemBuilder: (context) {
                                                  List<PopupMenuEntry<String>>
                                                      popups = [];
                                                  popups.add(PopupMenuItem(
                                                    child: Text("Deletar item"),
                                                    value: "a",
                                                  ));
                                                  return popups;
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                Column(
                                  children: <Widget>[
                                    Divider(),
                                    SizedBox(
                                      height: ScreenUtil().setHeight(10),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        companyScreenBloc.addCompany(
                                            appBloc.getCarrinho()[0].company);
                                        Navigator.popAndPushNamed(
                                            context, "/company_screen");
                                      },
                                      child: Text(
                                        "Adicionar mais itens",
                                        style: GoogleFonts.poppins(
                                          color: primaryColor,
                                          fontSize: ScreenUtil().setSp(32),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: ScreenUtil().setHeight(10),
                                    ),
                                    Divider(),
                                    SizedBox(
                                      height: ScreenUtil().setHeight(10),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Sub total",
                                              style: GoogleFonts.poppins(
                                                color: Colors.grey,
                                                fontSize:
                                                    ScreenUtil().setSp(29),
                                              ),
                                            ),
                                            Text(
                                              formatPrice(total),
                                              style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize:
                                                    ScreenUtil().setSp(29),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Frete",
                                              style: GoogleFonts.poppins(
                                                color: Colors.grey,
                                                fontSize:
                                                    ScreenUtil().setSp(29),
                                              ),
                                            ),
                                            Text(
                                              (appBloc.getPayment() != null &&
                                                      appBloc
                                                              .getPayment()
                                                              .formaPagamentoDeliveryId ==
                                                          14)
                                                  ? "0,00"
                                                  : formatPrice(double.parse(
                                                      appBloc
                                                          .getCarrinho()[0]
                                                          .company
                                                          .valorFrete)),
                                              style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize:
                                                    ScreenUtil().setSp(29),
                                              ),
                                            ),
                                          ],
                                        ),
                                        appBloc.cupom == null
                                            ? Container()
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    "Cupom ${appBloc.cupom.codigoCupom}",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.grey,
                                                      fontSize: ScreenUtil()
                                                          .setSp(29),
                                                    ),
                                                  ),
                                                  Text(
                                                    "-${double.parse(appBloc.cupom.descontoPremiacao).truncate()}%",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: ScreenUtil()
                                                          .setSp(29),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        appBloc.cashback == 0
                                            ? Container()
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    "Cashback",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.grey,
                                                      fontSize: ScreenUtil()
                                                          .setSp(29),
                                                    ),
                                                  ),
                                                  Text(
                                                    "- ${formatPrice(appBloc.cashback)}",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: ScreenUtil()
                                                          .setSp(29),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        appBloc
                                                    .getCarrinho()[0]
                                                    .company
                                                    .descontoGofood ==
                                                null
                                            ? Container()
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    "Desconto da loja",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.grey,
                                                      fontSize: ScreenUtil()
                                                          .setSp(29),
                                                    ),
                                                  ),
                                                  appBloc
                                                              .getCarrinho()[0]
                                                              .company
                                                              .descontoGofood !=
                                                          "null"
                                                      ? Text(
                                                          "- ${appBloc.getCarrinho()[0].company.descontoGofood}%",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            color: Colors.black,
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(29),
                                                          ),
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                        SizedBox(
                                          height: ScreenUtil().setHeight(40),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Total",
                                              style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize:
                                                    ScreenUtil().setSp(33),
                                              ),
                                            ),
                                            Text(
                                              formatPrice(appBloc.getTotal(
                                                subtotal: total,
                                                cashBack: appBloc.cashback,
                                                descontoCupom: double.parse(appBloc
                                                            .cupom
                                                            ?.descontoPremiacao ??
                                                        "0") /
                                                    100,
                                                descontoLoja: double.parse(appBloc
                                                                .getCarrinho()[
                                                                    0]
                                                                .company
                                                                .descontoGofood ==
                                                            "null"
                                                        ? "0"
                                                        : appBloc
                                                            .getCarrinho()[0]
                                                            .company
                                                            .descontoGofood) /
                                                    100,
                                                frete: (appBloc.getPayment() !=
                                                            null &&
                                                        appBloc
                                                                .getPayment()
                                                                .formaPagamentoDeliveryId ==
                                                            14)
                                                    ? 0
                                                    : double.parse(appBloc
                                                        .getCarrinho()[0]
                                                        .company
                                                        .valorFrete),
                                              )),
                                              style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize:
                                                    ScreenUtil().setSp(33),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                            width: ScreenUtil.screenWidthDp,
                            color: Colors.white,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, "/cupom_screen")
                                  .then((_) {
                                setState(() {});
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setWidth(30)),
                              color: Colors.white,
                              margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(30),
                              ),
                              height: ScreenUtil().setHeight(130),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.confirmation_number,
                                      color: Colors.grey,
                                      size: ScreenUtil().setHeight(55)),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(30),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Cupom",
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: ScreenUtil().setSp(35)),
                                      ),
                                      Text(
                                        "Insira um código",
                                        style: GoogleFonts.poppins(
                                            color: Colors.grey,
                                            fontSize: ScreenUtil().setSp(27)),
                                      ),
                                    ],
                                  ),
                                  Expanded(child: Container()),
                                  appBloc.cupom == null
                                      ? Container()
                                      : IconButton(
                                          onPressed: () {
                                            appBloc.cupom = null;
                                            setState(() {});
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            size: ScreenUtil().setHeight(50),
                                            color: Colors.black45,
                                          ),
                                        )
                                ],
                              ),
                            ),
                          ),
                          /*GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, "/cashback_screen")
                                  .then((_) {
                                setState(() {});
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setWidth(30)),
                              color: Colors.white,
                              margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(30),
                              ),
                              height: ScreenUtil().setHeight(130),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.card_membership,
                                      color: Colors.grey,
                                      size: ScreenUtil().setHeight(55)),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(30),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "CashBack",
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: ScreenUtil().setSp(35)),
                                      ),
                                      Text(
                                        "Usar cashback na compra",
                                        style: GoogleFonts.poppins(
                                            color: Colors.grey,
                                            fontSize: ScreenUtil().setSp(27)),
                                      ),
                                    ],
                                  ),
                                  Expanded(child: Container()),
                                  appBloc.cashback == 0
                                      ? Container()
                                      : IconButton(
                                          onPressed: () {
                                            appBloc.cashback = 0;
                                            setState(() {});
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            size: ScreenUtil().setHeight(50),
                                            color: Colors.black45,
                                          ),
                                        )
                                ],
                              ),
                            ),
                          ),*/
                          StreamBuilder<FormaPagamentoDelivery>(
                              stream: appBloc.formapagamentoOut,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData ||
                                    snapshot.data.formaPagamentoDeliveryId !=
                                        2) {
                                  return Container();
                                }
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                            context, "/troco_screen")
                                        .then((_) {
                                      setState(() {});
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: ScreenUtil().setWidth(30)),
                                    color: Colors.white,
                                    margin: EdgeInsets.only(
                                      top: ScreenUtil().setHeight(30),
                                    ),
                                    height: ScreenUtil().setHeight(130),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.attach_money,
                                            color: Colors.grey,
                                            size: ScreenUtil().setHeight(55)),
                                        SizedBox(
                                          width: ScreenUtil().setWidth(30),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Troco para: ${formatPrice(appBloc.troco)}",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize:
                                                      ScreenUtil().setSp(35)),
                                            ),
                                            Text(
                                              "Insira um valor",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.grey,
                                                  fontSize:
                                                      ScreenUtil().setSp(27)),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                          Container(
                            margin: EdgeInsets.only(
                                top: ScreenUtil().setHeight(30),
                                bottom: ScreenUtil().setHeight(200)),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(20),
                                      top: ScreenUtil().setHeight(30)),
                                  child: Text(
                                    'Pagamento',
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: ScreenUtil().setSp(40),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(
                                  height: ScreenUtil().setHeight(15),
                                ),
                                StreamBuilder<FormaPagamentoDelivery>(
                                  stream: appBloc.formapagamentoOut,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container(
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, "/payments_screen");
                                          },
                                          title: Text(
                                            "Escolher forma de pagamento",
                                            style: GoogleFonts.poppins(
                                                fontSize:
                                                    ScreenUtil().setSp(30)),
                                          ),
                                          trailing: Icon(
                                            Icons.arrow_forward_ios,
                                            color: primaryColor,
                                            size: ScreenUtil().setHeight(60),
                                          ),
                                        ),
                                      );
                                    }
                                    return Container(
                                      child: ListView(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        children: <Widget>[
                                          ListTile(
                                            subtitle: Text(snapshot.data
                                                        .pagamentoEntrega ==
                                                    true
                                                ? "Pagamento pelo estabelecimento"
                                                : "Crédito pelo Gofood"),
                                            onTap: () {},
                                            leading: Container(
                                              width: ScreenUtil().setWidth(100),
                                              child: Image.network(
                                                  "$urlApi${snapshot.data.imagemUrl}"),
                                            ),
                                            title: Text(
                                              snapshot.data.pagamentoEntrega ==
                                                      true
                                                  ? snapshot.data.nome
                                                  : appBloc
                                                      .getCardSelected()
                                                      .numeroCartao,
                                              style: GoogleFonts.poppins(
                                                  fontSize:
                                                      ScreenUtil().setSp(35)),
                                            ),
                                          ),
                                          ListTile(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, "/payments_screen");
                                            },
                                            title: Text(
                                              "Escolher forma de pagamento",
                                              style: GoogleFonts.poppins(
                                                  fontSize:
                                                      ScreenUtil().setSp(30)),
                                            ),
                                            trailing: Icon(
                                              Icons.arrow_forward_ios,
                                              color: primaryColor,
                                              size: ScreenUtil().setHeight(60),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
              }),
        ));
  }
}
