import 'package:dio/dio.dart';
import 'package:go_food_br/src/model/pedido.dart';

import '../app-settings.dart';

Future<List<Pedido>> getPedidosService({String userId}) async {
  Dio dio = Dio();
  print(userId);
  try {
    Response response = await dio.get(
        "$urlApi/Pedido/obter-pedido-cliente?ClienteDeliveryId=$userId",
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }));
    if (response.statusCode == 200) {
      print(response.data);
      List<Pedido> listPedidos = [];
      for (var a in response.data) {
        listPedidos.add(Pedido.fromJson(a));
      }
      return listPedidos;
    } else {
      print(response.data);
      return null;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future<Pedido> getPedidoService({String id}) async {
  Dio dio = Dio();
  try {
    Response response =
        await dio.get("$urlApi/Pedido/detalhe-pedido?pedidoId=$id",
            options: Options(
                followRedirects: false,
                validateStatus: (status) {
                  return status < 500;
                }));
    if (response.statusCode == 200) {
      print(response.data);
      return Pedido.fromJson(response.data);
    } else {
      print(response.data);
      return null;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future<List<HistoricoStatusPedidos>> getHistoricoService({String id}) async {
  Dio dio = Dio();
  try {
    Response response =
        await dio.get("$urlApi/Pedido/status-pedido?pedidoId=$id",
            options: Options(
                followRedirects: false,
                validateStatus: (status) {
                  return status < 500;
                }));
    if (response.statusCode == 200) {
      print(response.data);
      return (response.data as List)
          .map((item) => HistoricoStatusPedidos.fromJson(item))
          .toList();
    } else {
      print(response.data);
      return null;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future<bool> setExcluirPedido({String id}) async {
  Dio dio = Dio();
  try {
    Response response =
        await dio.put("$urlApi/Pedido/cancelar-pedido-cliente?pedidoId=$id",
            options: Options(
                followRedirects: false,
                validateStatus: (status) {
                  return status < 500;
                }));
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

Future<bool> receberPedidoService({String id}) async {
  Dio dio = Dio();
  try {
    Response response = await dio.put(
        "$urlApi/Pedido/confirmar-recebimento-pedido?pedidoId=$id",
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }));
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

Future<bool> avaliarPedidoService({String id, int stars, String desc}) async {
  Dio dio = Dio();

  print({
    "Descricao": "$desc",
    "Avaliação": stars,
    "PedidoId": id,
    "DataAvalicacao": DateTime.now().toIso8601String()
  });
  try {
    Response response = await dio.post("$urlApi/Pedido/salvar-comentario",
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
        data: {
          "Descricao": desc,
          "Avaliacao": stars,
          "PedidoId": id,
          "DataAvalicacao": DateTime.now().toIso8601String()
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
