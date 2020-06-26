import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_food_br/src/app-settings.dart';
import 'package:go_food_br/src/blocs/register-bloc.dart';
import 'package:go_food_br/src/components/show-error.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app-bloc.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final appBloc = BlocProvider.getBloc<AppBloc>();
  final registerBloc = BlocProvider.getBloc<RegisterBloc>();

  final MaskedTextController _cpfController =
      MaskedTextController(mask: '000.000.000-00');
  final MaskedTextController _phoneController =
      MaskedTextController(mask: '00 00000-0000');
  final TextEditingController _codeController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String sexo = "M";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: StreamBuilder<int>(
          stream: registerBloc.loadOut,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              );
            }
            if (snapshot.data == 1) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              );
            }
            return ListView(
              children: <Widget>[
                header(firstName(appBloc.firebaseUser.displayName)),
                dataInput("Celular",
                    controller: _phoneController,
                    textInputAction: TextInputType.number),
                generoInput(sexo, onChanged: (value) {
                  setState(() {
                    sexo = value;
                  });
                }),
                dataInput("CPF (Opcional)",
                    controller: _cpfController,
                    textInputAction: TextInputType.number),
                dataInput("Código Cashback (Opcional)",
                    controller: _codeController,
                    textInputAction: TextInputType.text),
                Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          registerBloc
                              .registerUser(
                                  sexo: sexo,
                                  firebaseUser: appBloc.firebaseUser,
                                  cpf: _cpfController.text,
                                  phone: _phoneController.text,
                                  code: _codeController.text)
                              .then((value) {
                            registerBloc.loadIn(0);
                            Future.delayed(Duration(microseconds: 500))
                                .then((_) {
                              switch (value) {
                                case 1:
                                  showError(
                                      scaffoldKey: _scaffoldKey,
                                      color: primaryColor,
                                      message: "CPF inválido");
                                  break;
                                case 2:
                                  showError(
                                      scaffoldKey: _scaffoldKey,
                                      color: primaryColor,
                                      message: "Número de telefone inválido");
                                  break;
                                case 3:
                                  showError(
                                      scaffoldKey: _scaffoldKey,
                                      color: primaryColor,
                                      message:
                                          "Sua senha não pode conter menos que 3 digitos");
                                  break;
                                case 4:
                                  showError(
                                      scaffoldKey: _scaffoldKey,
                                      color: primaryColor,
                                      message:
                                          "Por favor, verifique se as senhas estão iguais");
                                  break;
                                case 5:
                                  Navigator.pop(context, true);
                                  break;
                                default:
                                  showError(
                                      scaffoldKey: _scaffoldKey,
                                      color: primaryColor,
                                      message: "Erro ao cadastrar usuário");
                                  break;
                              }
                            });
                          });
                        },
                        color: primaryColor,
                        child: Text(
                          "Continuar",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(30)),
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }
}

Widget header(String name) {
  return Container(
    color: Colors.white,
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(22),
        vertical: ScreenUtil().setHeight(25),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset(
            "assets/images/logo_pink.png",
            height: ScreenUtil().setHeight(70),
          ),
          Text(
            "Olá, $name. Precisamos\nsaber mais sobre você!",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: ScreenUtil().setSp(30),
                color: primaryColor),
          ),
          Container()
        ],
      ),
    ),
  );
}

Widget generoInput(String value, {ValueChanged<String> onChanged}) {
  return Row(
    children: <Widget>[
      Radio(
          activeColor: primaryColor,
          focusColor: primaryColor,
          value: value == "M",
          groupValue: true,
          onChanged: (e) {
            onChanged("M");
          }),
      Text(
        "Masculino",
        style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(26)),
      ),
      Radio(
          activeColor: primaryColor,
          focusColor: primaryColor,
          value: value == "F",
          groupValue: true,
          onChanged: (e) {
            onChanged("F");
          }),
      Text(
        "Feminino",
        style: GoogleFonts.poppins(fontSize: ScreenUtil().setSp(26)),
      ),
    ],
  );
}

Widget dataInput(String title,
    {TextEditingController controller,
    bool obscureText = false,
    TextInputType textInputAction = TextInputType.text}) {
  return Padding(
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(30),
          right: ScreenUtil().setWidth(30),
          top: ScreenUtil().setHeight(30)),
      child: TextField(
        keyboardType: textInputAction,
        obscureText: obscureText,
        controller: controller,
        style: TextStyle(color: primaryColor, fontSize: ScreenUtil().setSp(33)),
        decoration: InputDecoration(
          hintStyle:
              TextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(32)),
          hintText: title,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.5))),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.5))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.5))),
        ),
      ));
}
