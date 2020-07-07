import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:go_food_br/src/app-settings.dart';
import 'package:go_food_br/src/model/cartao_cliente.dart';
import 'package:go_food_br/src/model/payment.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app-bloc.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final appBloc = BlocProvider.getBloc<AppBloc>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Formas de Pagamento"),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          appBloc.hasPaymentOnline() ? _selectPaymentOnline() : new Container(),
         _selectPaymentLocal()],
      )),
    );
  }

  Widget _selectPaymentLocal() {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
          child: Text("Pague na entrega",
              style: GoogleFonts.poppins(
                  fontSize: ScreenUtil().setSp(35),
                  fontWeight: FontWeight.w500)),
        ),
        StreamBuilder<List<Payment>>(
          stream: appBloc.paymentsOut,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(primaryColor),
                      ));
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    appBloc.formapagamentoIn(
                        snapshot.data[index].formaPagamentoDelivery);
                    //appBloc.paymentIn(snapshot.data[index]);
                    Navigator.pushNamed(context, "/carrinho_screen");
                  },
                  leading: Container(
                    width: ScreenUtil().setWidth(100),
                    child: Image.network(
                        "$urlApi${snapshot.data[index].formaPagamentoDelivery.imagemUrl}"),
                  ),
                  title: Text(snapshot.data[index].formaPagamentoDelivery.nome),
                );
              },
            );
          },
        ),
      ],
    ));
  }

  Widget _selectPaymentOnline() {
    return SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          Padding(
            padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
            child: Text("Pague pelo gofood",
                style: GoogleFonts.poppins(
                    fontSize: ScreenUtil().setSp(35),
                    fontWeight: FontWeight.w500)),
          ),
          StreamBuilder<List<CartaoCliente>>(
            stream: appBloc.cardsOut,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                 return Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(primaryColor),
                      ));
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      appBloc.formapagamentoIn(
                          snapshot.data[index].formaPagamentoDelivery);
                      appBloc.cardIn(snapshot.data[index]);
                      Navigator.pushNamed(context, "/carrinho_screen");
                    },
                    leading: Container(
                      width: ScreenUtil().setWidth(100),
                      child: Image.network(
                          "$urlApi${snapshot.data[index].formaPagamentoDelivery.imagemUrl}"),
                    ),
                    title: Text(snapshot.data[index].numeroCartao,
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(35),
                            fontWeight: FontWeight.w500)),
                  );
                },
              );
            },
          ),
          Padding(
              padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
              child: Row(children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Adiconar Cartão de Crédito",
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(30),
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Expanded(child: Container()),
                CircleAvatar(
                    radius: 25,
                    backgroundColor: primaryColor,
                    child: IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: ScreenUtil().setHeight(60),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, "/register_card_screen");
                        })),
              ]))
        ]));
  }
}
