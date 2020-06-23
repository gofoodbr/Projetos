import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:go_food_br/src/components/show-error.dart';
import 'package:awesome_card/awesome_card.dart';
import 'package:go_food_br/src/libs/format.dart';
import '../app-bloc.dart';
import '../app-settings.dart';

class CardBackgrounds {
  CardBackgrounds._();

  static Widget roxo = new Container(
    width: double.maxFinite,
    height: double.maxFinite,
    color: Color(0xff850284),
  );
}

class RegisterCardScreen extends StatefulWidget {
  @override
  _RegisterCardScreenState createState() => _RegisterCardScreenState();
}

class _RegisterCardScreenState extends State<RegisterCardScreen> {
  final appBloc = BlocProvider.getBloc<AppBloc>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String cardNumber = "";
  String cardHolderName = "";
  String expiryDate = "";
  String cvv = "";
  bool showBack = false;
  bool isLoading = false;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = new FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _focusNode.hasFocus ? showBack = true : showBack = false;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("CARTÃO DE CRÉDITO"),
      ),
      body: SingleChildScrollView(
        child: isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  CreditCard(
                      cardNumber: cardNumber,
                      cardExpiry: expiryDate,
                      cardHolderName: cardHolderName,
                      cvv: cvv,
                      bankName: "Gofood",
                      showBackSide: showBack,
                      frontBackground: CardBackgrounds.roxo,
                      backBackground: CardBackgrounds.roxo,
                      showShadow: true),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration:
                              InputDecoration(hintText: "Número Cartão"),
                          maxLength: 19,
                          onChanged: (value) {
                            setState(() {
                              cardNumber = value;
                            });
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(hintText: "Validade"),
                          maxLength: 7,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            MaskedTextInputFormatter(
                              mask: 'xx/xxxx',
                              separator: '/',
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              expiryDate = value;
                            });
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: TextFormField(
                          decoration:
                              InputDecoration(hintText: "Nome do Titular"),
                          onChanged: (value) {
                            setState(() {
                              cardHolderName = value;
                            });
                          },
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                        child: TextFormField(
                          decoration: InputDecoration(hintText: "CVV"),
                          maxLength: 3,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              cvv = value;
                            });
                          },
                          focusNode: _focusNode,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });
                            appBloc
                                .registerCardUser(
                                    formaPagamentoDeliveryId: 19,
                                    numeroCartao: cardNumber,
                                    mes: expiryDate.split("/")[0],
                                    ano: expiryDate.split("/")[1],
                                    nomeTitular: cardHolderName,
                                    cvv: cvv)
                                .then((result) {
                              if (result == 6) {
                                setState(() {
                                  isLoading = false;
                                });
                                showError(
                                    color: primaryColor,
                                    message: "Erro ao salvar cartão",
                                    scaffoldKey: _scaffoldKey);
                              } else {
                                Navigator.pushNamed(
                                    context, "/payments_screen");
                              }
                            });
                          },
                          color: primaryColor,
                          child: Text(
                            "Salvar",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(30)),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
