import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:go_food_br/src/blocs/register-endereco-bloc.dart';
import 'package:go_food_br/src/components/show-error.dart';
import 'package:go_food_br/src/services/geolocation-service.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app-bloc.dart';
import '../app-settings.dart';

class RegisterEnderecoScreen extends StatefulWidget {
  @override
  _RegisterEnderecoScreenState createState() => _RegisterEnderecoScreenState();
}

class _RegisterEnderecoScreenState extends State<RegisterEnderecoScreen> {
  final appBloc = BlocProvider.getBloc<AppBloc>();
  final bloc = BlocProvider.getBloc<RegisterEnderecoBloc>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool locate = false;
  TextEditingController apelidoController;
  MaskedTextController cepController;
  TextEditingController cidadeController;
  TextEditingController ufController;
  TextEditingController bairroController;
  TextEditingController logradouroController;
  TextEditingController numeroController;
  TextEditingController complementoController;

  @override
  void initState() {
    super.initState();
    getLocation(1, timeOut: 10, appBloc: appBloc).then((value) {
      if (appBloc.location == null) {
        Navigator.pushReplacementNamed(context, "/geolocator_off");
      } else {
        locate = true;
        bloc
            .getEndereco(appBloc.location.latitude.toString(),
                appBloc.location.longitude.toString())
            .then((endereco) {
          if (endereco != null) {
            cepController.text = endereco.cep;
            cidadeController.text = endereco.cidade;
            ufController.text = endereco.uf;
            bairroController.text = endereco.bairro;
            logradouroController.text = endereco.logradouro;
            numeroController.text = endereco.numero;
            complementoController.text = endereco.complemento;
          }
        });
      }
    });

    apelidoController = TextEditingController();
    cepController = MaskedTextController(mask: "00.000-000");
    cidadeController = TextEditingController();
    ufController = TextEditingController();
    bairroController = TextEditingController();
    logradouroController = TextEditingController();
    numeroController = TextEditingController();
    complementoController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: StreamBuilder<int>(
          stream: bloc.loadOut,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == 1 || !locate) {
              return Center(
                  child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
              ));
            }
            if (snapshot.data == 2) {
              Future.delayed(Duration(microseconds: 500)).then((_) {
                Navigator.pop(context, true);
              });
            }
            return ListView(
              children: <Widget>[
                header(firstName(appBloc.userModel?.nome ?? "")),
                dataInput("Ex:Casa ou Trabalho", controller: apelidoController),
                dataInput("CEP",
                    textInputType: TextInputType.number,
                    controller: cepController),
                dataInput("Cidade", controller: cidadeController),
                dataInput("UF",
                    controller: ufController,
                    textCapitalization: TextCapitalization.sentences,
                    maxLength: 2),
                dataInput("Bairro", controller: bairroController),
                dataInput("Logradouro", controller: logradouroController),
                dataInput(
                  "Número",
                  controller: numeroController,
                  textInputType: TextInputType.number,
                ),
                dataInput("Complemento", controller: complementoController),
                Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          bloc
                              .registerEndereco(
                            appBloc: appBloc,
                            numero: numeroController.text,
                            cidade: cidadeController.text,
                            complemento: complementoController.text,
                            cep: cepController.text,
                            uf: ufController.text,
                            bairro: bairroController.text,
                            logradouro: logradouroController.text,
                            apelido: apelidoController.text,
                            lat: appBloc.location.latitude.toString(),
                            lng: appBloc.location.longitude.toString(),
                          )
                              .then((result) {
                            if (result != null) {
                              showError(
                                  color: primaryColor,
                                  message: result,
                                  scaffoldKey: _scaffoldKey);
                            } else {
                              Navigator.pop(context, true);
                            }
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
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(100),
                ),
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
            "Olá, $name. Digite um\nendereço para entrega!",
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

Widget dataInput(String title,
    {TextEditingController controller,
    bool obscureText = false,
    TextInputType textInputType = TextInputType.text,
    int maxLength = 50,
    TextCapitalization textCapitalization = TextCapitalization.none}) {
  return Padding(
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(30),
          right: ScreenUtil().setWidth(30),
          top: ScreenUtil().setHeight(30)),
      child: TextField(
        textCapitalization: textCapitalization,
        maxLength: maxLength,
        keyboardType: textInputType,
        obscureText: obscureText,
        controller: controller,
        style: TextStyle(color: primaryColor, fontSize: ScreenUtil().setSp(33)),
        decoration: InputDecoration(
          counterText: "",
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
