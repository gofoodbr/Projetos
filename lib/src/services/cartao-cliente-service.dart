import 'package:dio/dio.dart';
import 'package:go_food_br/src/model/FormaPagamentoDelivery.dart';
import 'package:go_food_br/src/model/cartao_cliente.dart';
import '../app-bloc.dart';
import '../app-settings.dart';



Future<bool> getPaymentsOnlineService(AppBloc appBloc, int empresaId) async {
  Dio dio = Dio();

  try {
    Response response = await dio.get(
        "$urlApi/Pedido/obter-formaPagamento-online?empresaId=$empresaId",
          options: Options(
              followRedirects: false,
              validateStatus: (status) {
                return status < 500;
              })
    ).timeout(Duration(seconds: 40)).catchError((e) {
      throw e;
    });
    if (response.statusCode == 200) {
      print(response.data);
      List<FormaPagamentoDelivery> list = [];
      for(var a in response.data){
        list.add(FormaPagamentoDelivery.fromJson(a));
      }
      print(list.length);
      appBloc.paymentsOnlineIn(list);
      return true;
    } else {
      print(response.data);
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> getCardsService(AppBloc appBloc, int clienteId) async {
  Dio dio = Dio();

  try {
    Response response = await dio.get(
        "$urlApi/Pedido/obter-cartoes_cliente?clienteId=$clienteId",
          options: Options(
              followRedirects: false,
              validateStatus: (status) {
                return status < 500;
              })
    ).timeout(Duration(seconds: 40)).catchError((e) {
      throw e;
    });
    if (response.statusCode == 200) {
      print(response.data);
      List<CartaoCliente> list = [];
      for(var a in response.data){
        list.add(CartaoCliente.fromJson(a));
      }
      print(list.length);
      appBloc.cardsIn(list);
      return true;
    } else {
      print(response.data);
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> registerCardService({
  int formaPagamentoDeliveryId,
  int empresaId,
  int clienteDeliveryId,
  String numeroCartao,
  String nomeTitular,
  String cpf,
  String ano,
  String mes,
  String cvv
}) async {
  Dio dio = Dio();
  try {
    Response response = await dio.post(
        "$urlApi/Pedido/registrar-cartao-cliente",
          options: Options(
              followRedirects: false,
              validateStatus: (status) {
                return status < 500;
              }),
        data: {
          "ClienteDeliveryId": clienteDeliveryId,
          "FormaPagamentoDeliveryId": formaPagamentoDeliveryId,
          "EmpresaId": empresaId,
          "NumeroCartao": numeroCartao,
          "NomeTitular": nomeTitular,
          "CPF": cpf,
          "Ano": ano,
          "Mes": mes,
          "CVV": cvv
        }
    ).timeout(Duration(seconds: 20)).catchError((e) {
      throw e;
    });
    if (response.statusCode == 200) {
      print(response.data);
      return true;
    } else {
      print(response.data);
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}