import 'package:flutter/material.dart';
import 'package:go_food_br/src/model/product-model.dart';
import 'package:intl/intl.dart';

import 'model/complemento-model.dart';
import 'model/sabor.dart';

String appName = "GoFood";

final double screenHeightBase = 1280; //1334;
final double screenWidthBase = 720; //750

final Color primaryColor = Color(0xff850284);
final Color errorColor = Color(0xff990000);

String urlApi = "https://www.gofood.com.br/AppGofood";

String firstName(String name){
  return name.split(" ")[0];
}

final oCcy = new NumberFormat("#,##0.00", "pt_BR");
String formatPrice(double value){
  return "R\$ ${oCcy.format(value)}";
}

double getValorProduto(Product product){
  double valorProduto = 0;
  if(product.precoVendaPromocional != "null" && double.parse(product.precoVendaPromocional) > 0){
    valorProduto += double.parse(product.precoVendaPromocional);
  }else{
    valorProduto += double.parse(product.precoVenda);
  }

  if(product.company.preferenciaMaiorPrecoSabor && product.sabores.length > 0){
    double maiorPrecoSabor = 0;
    for(Sabor sabor in product.sabores){
      if(double.parse(sabor.valorTotal) > maiorPrecoSabor) maiorPrecoSabor = double.parse(sabor.valorTotal);
    }
    valorProduto = maiorPrecoSabor;
  }else if(!product.company.preferenciaMaiorPrecoSabor && product.sabores.length > 0){
    double preco = 0;
    for(Sabor sabor in product.sabores){
      preco += double.parse(sabor.valorTotal) / product.sabores.length;
    }
    valorProduto = preco;
  }

  for(Complemento c in product.complementos){
    valorProduto += double.parse(c.produtoComplemento.precoVenda);
  }
  double valor = 0;
  valor += valorProduto*product.quantidade;

  return valor;
}

getTotal({double subtotal, double frete = 0, double descontoLoja = 1, double descontoCupom = 1, double cashBack = 0}){
  print(subtotal);
  double valorDescontoLoja = subtotal * descontoLoja;
  print(valorDescontoLoja);
  double valorDescontoCupom = subtotal * descontoCupom;
  print(valorDescontoCupom);
  print(frete);
  return subtotal - valorDescontoLoja - valorDescontoCupom - cashBack + frete;
}

Map<String, dynamic> getDateString({
  DateTime dateTime
}){
  Map<String,dynamic> result = {};
  List<String> days= [
    "Seg",
    "Ter",
    "Qua",
    "Qui",
    "Sex",
    "Sab",
    "Dom",
  ];

  List<String> months= [
    "Janeiro",
    "Fevereiro",
    "Março",
    "Abril",
    "Maio",
    "Junho",
    "Julho",
    "Agosto",
    "Setembro",
    "Outubro",
    "Novembro",
    "Dezembro",
  ];
  print(DateTime.now().weekday);
  result["dayWeek"] = days[dateTime.weekday-1];
  result["day"] = dateTime.day;
  result["month"] = months[dateTime.month-1];
  result["year"] = dateTime.year;
  return result;
}

String getStatusPedido(int status){
  switch (status) {
    case 1:
      return "Pedido Enviado";
      break;
    case 2:
      return "Pedido em prepado";
      break;
    case 3:
      return "Pedido cancelado";
      break;
    case 5:
      return "Pedido despachado";
      break;
    case 6:
      return "Pedido recebido";
      break;
    default:
      return "StatusNulo";
        break;
  }
}