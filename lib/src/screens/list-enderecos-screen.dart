import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_food_br/src/app-settings.dart';
import 'package:go_food_br/src/components/show-error.dart';
import 'package:go_food_br/src/model/endereco-model.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app-bloc.dart';

class ListEnderecosScreen extends StatefulWidget {
  @override
  _ListEnderecosScreenState createState() => _ListEnderecosScreenState();
}

class _ListEnderecosScreenState extends State<ListEnderecosScreen> {
  final appBloc = BlocProvider.getBloc<AppBloc>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext contextPai) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/register_endereco")
              .then((result) async {
            if (result != null) {
              appBloc.loadIn(100);
              await appBloc.getEndereco().then((bool success) {
                if (success) {
                  appBloc.loadIn(0);
                  Navigator.pushNamed(contextPai, "/home");
                } else {
                  appBloc.loadIn(1);
                }
              });
            }
          });
        },
        backgroundColor: primaryColor,
        child: Text(
          "+",
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: ScreenUtil().setSp(40)),
        ),
      ),
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          "Meus endereços",
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: ScreenUtil().setSp(34)),
        ),
      ),
      body: StreamBuilder<int>(
          stream: appBloc.loadOut,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == 100) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              );
            }
            if (snapshot.data == 1) {
              Future.delayed(Duration(microseconds: 500)).then((_) {
                showError(
                    message: "Erro ao obter enderecos",
                    color: primaryColor,
                    scaffoldKey: _scaffoldKey);
                appBloc.loadIn(0);
              });
            }
            if (snapshot.data == 2) {
              Future.delayed(Duration(microseconds: 500)).then((_) {
                showError(
                    message: "Erro ao alterar enderecos",
                    color: primaryColor,
                    scaffoldKey: _scaffoldKey);
                appBloc.loadIn(0);
              });
            }
            if (snapshot.data == 5) {
              Future.delayed(Duration(microseconds: 500)).then((_) {
                showError(
                    message: "Erro ao deletar endereco",
                    color: primaryColor,
                    scaffoldKey: _scaffoldKey);
                appBloc.loadIn(0);
              });
            }
            if (snapshot.data == 6) {
              Future.delayed(Duration(microseconds: 500)).then((_) {
                showError(
                    message: "O endereço selecionado não pode ser apagado",
                    color: primaryColor,
                    scaffoldKey: _scaffoldKey);
                appBloc.loadIn(0);
              });
            }
            return Container(
              child: StreamBuilder<List<EnderecoModel>>(
                stream: appBloc.enderecosOut,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return enderecoTile(contextPai, snapshot.data[index],
                          selected: index == 0, appBloc: appBloc, index: index);
                    },
                  );
                },
              ),
            );
          }),
    );
  }
}

Widget enderecoTile(BuildContext context, EnderecoModel enderecoModel,
    {bool selected, AppBloc appBloc, int index}) {
  return GestureDetector(
    onTap: () {
      appBloc.loadIn(100);
      appBloc.setEndereco(enderecoModel).then((success) {
        if (success) {
          appBloc.loadIn(0);
          Navigator.pushNamed(context, "/home");
        } else
          appBloc.loadIn(2);
      });
    },
    child: Container(
      padding: EdgeInsets.only(
        top: ScreenUtil().setWidth(10),
        left: ScreenUtil().setHeight(20),
      ),
      margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(30),
          vertical: ScreenUtil().setHeight(15)),
      height: ScreenUtil().setHeight(210),
      decoration: BoxDecoration(
          border: Border.all(color: selected ? primaryColor : Colors.grey),
          borderRadius: BorderRadius.circular(15),
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                enderecoModel.identificacao,
                style: GoogleFonts.poppins(
                  color: Colors.black54,
                  fontSize: ScreenUtil().setSp(30),
                ),
              ),
              Expanded(child: Container()),
              selected
                  ? Icon(
                      Icons.star,
                      color: primaryColor,
                      size: ScreenUtil().setHeight(30),
                    )
                  : Container(),
              PopupMenuButton<String>(
                onSelected: (value) {
                  print("object");
                  if (index != 0) {
                    appBloc.loadIn(100);
                    appBloc.deleteEndereco(enderecoModel.enderecoId).then((va) {
                      if (va) {
                        appBloc.loadIn(0);
                      } else
                        appBloc.loadIn(6);
                    });
                  } else {
                    appBloc.loadIn(5);
                  }
                },
                enabled: true,
                child: IconButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: primaryColor,
                    ),
                    onPressed: null),
                itemBuilder: (context) {
                  List<PopupMenuEntry<String>> popups = [];
                  popups.add(PopupMenuItem(
                    child: Text("Deletar endereço"),
                    value: "a",
                  ));
                  return popups;
                },
              ),
            ],
          ),
          Text(
            "${enderecoModel.logradouro}, ${enderecoModel.numero} - ${enderecoModel.bairro}, ${enderecoModel.cidade} - ${enderecoModel.uf.toUpperCase()}",
            style: GoogleFonts.poppins(color: Colors.black54),
          )
        ],
      ),
    ),
  );
}
