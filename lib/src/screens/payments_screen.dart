import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:go_food_br/src/app-settings.dart';
import 'package:go_food_br/src/model/FormaPagamentoDelivery.dart';
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
    appBloc.getPayments();
    appBloc.getCards();
    appBloc.getPaymentsOnline();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Escolher forma de pagamento"),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[          
          _selectPaymentOnline(),
          _selectPaymentLocal()
        ],
      )),
    );
  }

  Widget _selectPaymentLocal() {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(ScreenUtil().setHeight(30)),
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
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                  height: ScreenUtil().setHeight(300),
                  color: Colors.grey.shade200,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  ));
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    appBloc.formapagamentoIn(snapshot.data[index].formaPagamentoDelivery);
                    //appBloc.paymentIn(snapshot.data[index]);
                    Navigator.pop(context);
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
            padding: EdgeInsets.all(ScreenUtil().setHeight(30)),
            child: Text("Pague Online",
                style: GoogleFonts.poppins(
                    fontSize: ScreenUtil().setSp(35),
                    fontWeight: FontWeight.w500)),
          ),
          StreamBuilder<List<CartaoCliente>>(
            stream: appBloc.cardsOut,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
                    height: ScreenUtil().setHeight(300),
                    color: Colors.grey.shade200,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    ));
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {                      
                      appBloc.formapagamentoIn(snapshot.data[index].formaPagamentoDelivery);
                      appBloc.cardIn(snapshot.data[index]);
                      Navigator.pop(context);
                    },
                    leading: Container(
                      width: ScreenUtil().setWidth(100),
                      child: Image.network(
                          "$urlApi${snapshot.data[index].formaPagamentoDelivery.imagemUrl}"),
                    ),
                    title: Text(snapshot.data[index].numeroCartao),
                  );
                },
              );
            },
          ),
        ]));
  }
}
