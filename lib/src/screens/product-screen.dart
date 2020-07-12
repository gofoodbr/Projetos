import 'dart:convert';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_food_br/src/app-settings.dart';
import 'package:go_food_br/src/blocs/item-bloc.dart';
import 'package:go_food_br/src/components/show-error.dart';
import 'package:go_food_br/src/model/complemento-model.dart';
import 'package:go_food_br/src/model/opcional.dart';
import 'package:go_food_br/src/model/product-model.dart';
import 'package:go_food_br/src/model/sabor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:rounded_modal/rounded_modal.dart';

import '../app-bloc.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final itemBloc = BlocProvider.getBloc<ItemBloc>();
  final appBloc = BlocProvider.getBloc<AppBloc>();
  final obsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    itemBloc.getComplemento();
    itemBloc.getOpcionais();
    itemBloc.getSabores();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        itemBloc.clear();
        return true;
      },
      child: StreamBuilder<Product>(
          stream: itemBloc.productsOut,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              );
            }
            Image image;
            if (snapshot.data.contentType == "image/jpeg" ||
                snapshot.data.contentType == "image/png") {
              image = Image.memory(base64Decode(snapshot.data.content),
                  fit: BoxFit.fitWidth);
            }
            return Scaffold(
                key: _scaffoldKey,
                bottomNavigationBar: _bottomTab(snapshot.data),
                appBar: AppBar(
                  backgroundColor: primaryColor,
                  title: Text(
                    "Detalhes do item",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _headImage(image),
                      _title(snapshot.data),
                      _selectOpcionais(product: snapshot.data),
                      _selectSabores(product: snapshot.data),
                      _selectComplemento(product: snapshot.data),
                      observacao()
                    ],
                  ),
                ));
          }),
    );
  }

  Widget observacao() {
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
      height: ScreenUtil().setHeight(250),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
          margin: EdgeInsets.all(ScreenUtil().setHeight(30)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(color: primaryColor),
          ),
          child: TextField(
            controller: obsController,
            maxLines: 4,
            decoration: InputDecoration(
                hintText: "ex: Sem cebola", border: InputBorder.none),
          ),
        ),
      ),
    );
  }

  Widget _selectSabores({Product product}) {
    return StreamBuilder<List<Sabor>>(
        stream: itemBloc.saboresOut,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                height: ScreenUtil().setHeight(300),
                color: Colors.grey.shade200,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ));
          } else {
            if (snapshot.data.length == 0) {
              return Container();
            }
            return StreamBuilder<int>(
                stream: itemBloc.qntSaboresOut,
                builder: (context, snapshotQnt) {
                  if (!snapshot.hasData) {
                    return Container(
                        margin:
                            EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                        height: ScreenUtil().setHeight(300),
                        color: Colors.grey.shade200,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(primaryColor),
                          ),
                        ));
                  }

                  return Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: ScreenUtil().setWidth(40),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Sabores",
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: ScreenUtil().setSp(35),
                                      fontWeight: FontWeight.w500),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      "Marque os sabores que deseja",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: ScreenUtil().setSp(23),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Text(
                              "${product.sabores.length}/${product.maximoSabores}",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(26),
                              ),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(40),
                            ),
                          ],
                        ),
                        margin:
                            EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                        color: Colors.grey.shade200,
                        height: ScreenUtil().setHeight(150),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              color: Colors.white,
                              height: ScreenUtil().setHeight(120),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: ScreenUtil().setWidth(40),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Escolha quantos sabores deseja",
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: ScreenUtil().setSp(26),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(child: Container()),
                                  IconButton(
                                      icon: Icon(
                                        Icons.remove,
                                        color: primaryColor,
                                        size: ScreenUtil().setHeight(30),
                                      ),
                                      onPressed: () {
                                        itemBloc.subQntSabores();
                                      }),
                                  StreamBuilder<int>(
                                      stream: itemBloc.qntSaboresOut,
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Text("0");
                                        }
                                        return Text(snapshot.data.toString());
                                      }),
                                  IconButton(
                                      icon: Icon(
                                        Icons.add,
                                        color: primaryColor,
                                        size: ScreenUtil().setHeight(30),
                                      ),
                                      onPressed: () {
                                        itemBloc.addQntSabores();
                                      }),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(20),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.grey.shade300,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(bottom: ScreenUtil().setHeight(40)),
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            int quantidade = product.sabores
                                .where((opcional) =>
                                    snapshot.data[index].saborProdutoId ==
                                    opcional.saborProdutoId)
                                .length;
                            double precoSabor = 0;
                            if (double.parse(snapshot.data[index].valorTotal) >
                                0) {
                              precoSabor =
                                  double.parse(snapshot.data[index].valorTotal);

                              if (!product.company.preferenciaMaiorPrecoSabor) {
                                precoSabor = precoSabor / snapshotQnt.data;
                              }
                            } else {
                              product.precoVenda =
                                  (double.parse(product.precoVendaPromocional) >
                                              0
                                          ? double.parse(
                                              product.precoVendaPromocional)
                                          : double.parse(product.precoVenda))
                                      .toString();
                            }
                            return GestureDetector(
                              onTap: () {
                                itemBloc.addSabor(snapshot.data[index]);
                              },
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    color: Colors.white,
                                    height: ScreenUtil().setHeight(120),
                                    child: Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: ScreenUtil().setWidth(40),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              snapshot.data[index].descricao,
                                              style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize:
                                                    ScreenUtil().setSp(30),
                                              ),
                                            ),
                                            Text(
                                              precoSabor > 0
                                                  ? formatPrice(precoSabor)
                                                  : '',
                                              style: GoogleFonts.poppins(
                                                color: Colors.grey,
                                                fontSize:
                                                    ScreenUtil().setSp(27),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Expanded(child: Container()),
                                        quantidade > 0
                                            ? CircleAvatar(
                                                backgroundColor: primaryColor,
                                                radius:
                                                    ScreenUtil().setHeight(25),
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.grey.shade200,
                                                  radius: ScreenUtil()
                                                      .setHeight(15),
                                                ),
                                              )
                                            : CircleAvatar(
                                                backgroundColor:
                                                    Colors.grey.shade200,
                                                radius:
                                                    ScreenUtil().setHeight(25),
                                              ),
                                        SizedBox(
                                          width: ScreenUtil().setWidth(20),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.grey.shade300,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                });
          }
        });
  }

  var _groupAtual = 0;

  void setGrupoAtual(int categoriaOpcionalProdutoId) {
    _groupAtual = categoriaOpcionalProdutoId;
  }

  Widget _selectOpcionais({Product product}) {
    return StreamBuilder<List<Opcional>>(
        stream: itemBloc.opcionaisOut,
        builder: (context, snapshot) {
          var categorias = new List<CategoriaOpcional>();
          if (snapshot.hasData) {
            for (var item in snapshot.data) {
              if (categorias
                      .where((e) =>
                          e.categoriaOpcionalProdutoId ==
                          item.categoriaOpcionalProdutoId)
                      .length ==
                  0) categorias.add(item.categoria);
            }
          }
          if (!snapshot.hasData) {
            return Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                height: ScreenUtil().setHeight(300),
                color: Colors.grey.shade200,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ));
          } else {
            if (snapshot.data.length == 0) {
              return Container();
            }
            return Column(children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: ScreenUtil().setWidth(40),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Selecione os opcionais",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(35),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(40),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                color: Colors.grey.shade200,
                height: ScreenUtil().setHeight(150),
              ),
              Container(
                  margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(30)),
                  child: GroupListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    sectionsCount: categorias.length,
                    countOfItemInSection: (int section) {
                      var countItens = 0;
                      if (snapshot.hasData) {
                        countItens = snapshot.data
                            .where((e) =>
                                e.categoriaOpcionalProdutoId ==
                                categorias[section].categoriaOpcionalProdutoId)
                            .length;
                      }
                      return countItens;
                    },
                    itemBuilder: (BuildContext context, IndexPath index) {
                      var opcionaisCatList = new List<Opcional>();
                      if (snapshot.hasData) {
                        opcionaisCatList = snapshot.data
                            .where((e) =>
                                e.categoriaOpcionalProdutoId == _groupAtual)
                            .toList();
                      }

                      return Container(
                          child: Column(
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  color: Colors.white,
                                  height: ScreenUtil().setHeight(120),
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: ScreenUtil().setWidth(40),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                opcionaisCatList[index.index]
                                                    .descricao,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize:
                                                      ScreenUtil().setSp(30),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              double.parse(opcionaisCatList[
                                                              index.index]
                                                          .valorTotal) >
                                                      0
                                                  ? Text(
                                                      "+ ${formatPrice(double.parse(opcionaisCatList[index.index].valorTotal))}  ",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.grey,
                                                        fontSize: ScreenUtil()
                                                            .setSp(27),
                                                      ),
                                                    )
                                                  : Text(""),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Expanded(child: Container()),
                                      itemBloc.obterQuantidadeItensOpcional(
                                                  opcionaisCatList[index.index]
                                                      .categoriaOpcionalProdutoId,
                                                  opcionaisCatList[index.index]
                                                      .composicaoProdutoId) ==
                                              0
                                          ? Container()
                                          : IconButton(
                                              icon: Icon(
                                                Icons.remove,
                                                color: primaryColor,
                                                size:
                                                    ScreenUtil().setHeight(30),
                                              ),
                                              onPressed: () {
                                                itemBloc.removeOpcionais(
                                                    opcionaisCatList[
                                                        index.index]);
                                              }),
                                      itemBloc.obterQuantidadeItensOpcional(
                                                  opcionaisCatList[index.index]
                                                      .categoriaOpcionalProdutoId,
                                                  opcionaisCatList[index.index]
                                                      .composicaoProdutoId) ==
                                              0
                                          ? Container()
                                          : Text((itemBloc
                                                  .obterQuantidadeItensOpcional(
                                                      opcionaisCatList[
                                                              index.index]
                                                          .categoriaOpcionalProdutoId,
                                                      opcionaisCatList[
                                                              index.index]
                                                          .composicaoProdutoId))
                                              .toString()),
                                      IconButton(
                                          icon: Icon(
                                            Icons.add,
                                            color: primaryColor,
                                            size: ScreenUtil().setHeight(30),
                                          ),
                                          onPressed: () {
                                            Opcional opcional =
                                                opcionaisCatList[index.index];
                                            itemBloc.addOpcionais(opcional);
                                          }),
                                      SizedBox(
                                        width: ScreenUtil().setWidth(20),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.grey.shade300,
                                ),
                              ],
                            ),
                          )
                        ],
                      ));
                    },
                    groupHeaderBuilder: (BuildContext context, int section) {
                      setGrupoAtual(
                          categorias[section].categoriaOpcionalProdutoId);
                      return Container(
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: ScreenUtil().setWidth(40),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  categorias[section].nomeCategoria,
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: ScreenUtil().setSp(35),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Text(
                              "${itemBloc.obterQtdTotalCategoria(categorias[section].categoriaOpcionalProdutoId)}/${categorias[section].maximoOpcionais}",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(26),
                              ),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(40),
                            ),
                          ],
                        ),
                        margin: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
                        color: Colors.grey.shade200,
                        height: ScreenUtil().setHeight(100),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 3),
                  ))
            ]);
          }
        });
  }

  Widget _selectComplemento({Product product}) {
    return StreamBuilder<List<Complemento>>(
        stream: itemBloc.complementoOut,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                height: ScreenUtil().setHeight(300),
                color: Colors.grey.shade200,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ));
          } else {
            if (snapshot.data.length == 0) {
              return Container();
            }
            return Column(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: ScreenUtil().setWidth(40),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Complementos",
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(35),
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Marque o complemento que deseja",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(23),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                  color: Colors.grey.shade200,
                  height: ScreenUtil().setHeight(150),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(40)),
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      int quantidade = 0;
                      var complementos = product.complementos.where(
                          (complemento) =>
                              snapshot.data[index].complementoProdutoId ==
                              complemento.complementoProdutoId);
                      if (complementos.length > 0) {
                        quantidade = complementos.first.quantidade;
                      }

                      return Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              color: Colors.white,
                              height: ScreenUtil().setHeight(120),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: ScreenUtil().setWidth(40),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            snapshot
                                                .data[index]
                                                .produtoComplemento
                                                .nomeAbreviado,
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: ScreenUtil().setSp(30),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            "+ ${formatPrice(double.parse(snapshot.data[index].produtoComplemento.precoVenda))}  ",
                                            style: GoogleFonts.poppins(
                                              color: Colors.grey,
                                              fontSize: ScreenUtil().setSp(27),
                                            ),
                                          ),
                                          snapshot.data[index].obrigatorio
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                      color: primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100)),
                                                  child: Text(
                                                    "  Obrigatório  ",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: ScreenUtil()
                                                          .setSp(17),
                                                    ),
                                                  ),
                                                )
                                              : Container()
                                        ],
                                      ),
                                    ],
                                  ),
                                  Expanded(child: Container()),
                                  quantidade == 0
                                      ? Container()
                                      : IconButton(
                                          icon: Icon(
                                            Icons.remove,
                                            color: primaryColor,
                                            size: ScreenUtil().setHeight(30),
                                          ),
                                          onPressed: () {
                                            itemBloc.removeComplemento(
                                                snapshot.data[index]);
                                          }),
                                  quantidade == 0
                                      ? Container()
                                      : Text("${quantidade.toString()}"),
                                  IconButton(
                                      icon: Icon(
                                        Icons.add,
                                        color: primaryColor,
                                        size: ScreenUtil().setHeight(30),
                                      ),
                                      onPressed: () {
                                        Complemento complemento =
                                            snapshot.data[index];
                                        complemento.quantidade = quantidade + 1;
                                        itemBloc.addComplemento(complemento);
                                      }),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(20),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.grey.shade300,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        });
  }

  Widget _bottomTab(Product product) {
    return StreamBuilder<int>(
        stream: itemBloc.qntSaboresOut,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          double precoProduto = double.parse(product.precoVendaPromocional) == 0
              ? double.parse(product.precoVenda)
              : double.parse(product.precoVendaPromocional);

          if (product.company.preferenciaMaiorPrecoSabor &&
              product.sabores.length > 0) {
            double maiorPrecoSabor = 0;
            for (Sabor sabor in product.sabores) {
              if (double.parse(sabor.valorTotal) > 0) {
                if (double.parse(sabor.valorTotal) > maiorPrecoSabor)
                  maiorPrecoSabor = double.parse(sabor.valorTotal);
              }
            }
            if (maiorPrecoSabor > 0) precoProduto = maiorPrecoSabor;
          } else if (!product.company.preferenciaMaiorPrecoSabor &&
              product.sabores.length > 0) {
            double proporcionalPrecoSabor = 0;
            for (Sabor sabor in product.sabores) {
              if (double.parse(sabor.valorTotal) > 0)
                proporcionalPrecoSabor +=
                    double.parse(sabor.valorTotal) / snapshot.data;
            }
            if (proporcionalPrecoSabor > 0)
              precoProduto = proporcionalPrecoSabor;
          }

          List<Complemento> complementos = product.complementos;
          double valorComplementos = 0;
          if (complementos != null) {
            complementos.forEach((f) {
              valorComplementos = valorComplementos +
                  (double.parse(f.produtoComplemento.precoVenda) *
                      f.quantidade);
            });
          }

          List<Opcional> opcionais = product.opcionais;
          double valorOpcional = 0;
          if (opcionais != null) {
            opcionais.forEach((f) {
              valorOpcional =
                  valorOpcional + (double.parse(f.valorTotal) * f.quantidade);
            });
          }

          return Container(
            height: ScreenUtil().setHeight(130),
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300))),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: ScreenUtil().setWidth(30),
                ),
                Container(
                  height: ScreenUtil().setHeight(90),
                  width: ScreenUtil().setWidth(200),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400)),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                itemBloc.addQnt(remove: true);
                              }),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Center(
                            child: Text(
                              product.quantidade.toString(),
                              style:
                                  TextStyle(fontSize: ScreenUtil().setSp(30)),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                itemBloc.addQnt();
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(20),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      String result =
                          itemBloc.addCarrinho(appBloc, obsController.text);
                      if (result == null) {
                        Navigator.pushNamed(context, "/company_screen");
                      } else {
                        if (result == "modal") {
                          showRoundedModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  padding: EdgeInsets.all(
                                      ScreenUtil().setHeight(30)),
                                  height: ScreenUtil().setHeight(400),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Você possui produtos de outra empresa no carrinho",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                            fontSize: ScreenUtil().setSp(34)),
                                      ),
                                      SizedBox(
                                        height: ScreenUtil().setHeight(20),
                                      ),
                                      FlatButton(
                                          onPressed: () {
                                            appBloc.clearCarrinho();
                                            Navigator.pop(context);
                                            showError(
                                                scaffoldKey: _scaffoldKey,
                                                message: "Carrinho Limpo",
                                                color: primaryColor);
                                          },
                                          color: primaryColor,
                                          child: Text(
                                            "Limpar Carrinho",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    ],
                                  ),
                                );
                              });
                        } else
                          showErrorBtn(
                            onTap: () {
                              if (result ==
                                  "Você possui produtos de outra empresa no carrinho, clique aqui para limpar") {
                                appBloc.carrinhoIn([]);
                                showError(
                                    scaffoldKey: _scaffoldKey,
                                    message: "Carrinho Limpo",
                                    color: primaryColor);
                              } else {}
                            },
                            color: primaryColor,
                            message: result,
                            scaffoldKey: _scaffoldKey,
                          );
                      }
                    },
                    child: Container(
                      height: ScreenUtil().setHeight(90),
                      decoration: BoxDecoration(color: primaryColor),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: ScreenUtil().setWidth(25),
                          ),
                          Text(
                            "Adicionar",
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(30)),
                          ),
                          Expanded(child: Container()),
                          Text(
                            formatPrice((precoProduto +
                                    valorComplementos +
                                    valorOpcional) *
                                product.quantidade),
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(30)),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(25),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(30),
                ),
              ],
            ),
          );
        });
  }

  Widget _headImage(Image image) {
    return image == null
        ? Container(
            height: ScreenUtil().setHeight(30),
          )
        : Container(
            height: ScreenUtil().setHeight(250),
            margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(30),
                vertical: ScreenUtil().setHeight(30)),
            child: Material(
                elevation: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(child: image),
                  ],
                )),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
            ),
          );
  }

  Widget _title(Product product) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: ScreenUtil().setHeight(10),
          horizontal: ScreenUtil().setWidth(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            product.nomeAbreviado,
            style: GoogleFonts.poppins(
                fontSize: ScreenUtil().setSp(37), fontWeight: FontWeight.w500),
          ),
          Text(
            product.descricaoProduto,
            style: GoogleFonts.poppins(
                fontSize: ScreenUtil().setSp(28), color: Colors.grey),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(5),
          ),
          Text(
            double.parse(product.precoVendaPromocional) > 0
                ? formatPrice(double.parse(product.precoVendaPromocional))
                : formatPrice(double.parse(product.precoVenda)),
            style: GoogleFonts.poppins(
                fontSize: ScreenUtil().setSp(31), fontWeight: FontWeight.w500),
          ),
          StreamBuilder<List<Sabor>>(
              stream: itemBloc.saboresOut,
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.data.length == 0 ||
                    !product.company.preferenciaMaiorPrecoSabor) {
                  return Container();
                }
                return Container(
                  padding: EdgeInsets.all(ScreenUtil().setHeight(30)),
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Importante: A pizza de mais de 1 sabor será cobrada pelo preço do valor mais caro",
                    style: GoogleFonts.poppins(
                        color: Colors.black, fontSize: ScreenUtil().setSp(27)),
                  ),
                );
              })
        ],
      ),
    );
  }
}
