import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:go_food_br/src/app-settings.dart';
import 'package:go_food_br/src/model/complemento-model.dart';
import 'package:go_food_br/src/model/opcional.dart';
import 'package:go_food_br/src/model/sabor.dart';

Dio getDioHttp()
{
  var dio = Dio();
  if (Platform.isAndroid) {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }
  return dio;
}

Future<List<Complemento>> getComplementosService({
  String productId
}) async {
  Dio dio = getDioHttp();

  try {
    Response response = await dio.get(
        "$urlApi/Complemento/obter-por-produto?id=$productId",
          options: Options(
              followRedirects: false,
              validateStatus: (status) {
                return status < 500;
              })
    ).timeout(Duration(seconds: 20)).catchError((e) {
      throw e;
    });
    if (response.statusCode == 200) {
      print(response.data);
      List<Complemento> listComplementos = [];
      for(var a in response.data){
        listComplementos.add(Complemento.fromJson(a));
      }
      return listComplementos;
    } else {
      print(response.data);
      return null;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future<List<Opcional>> getOpcionaisService({
  String productId
}) async {
  Dio dio = getDioHttp();

  try {
    Response response = await dio.get(
        "$urlApi/Composicao/obter-por-produto?id=$productId",
          options: Options(
              followRedirects: false,
              validateStatus: (status) {
                return status < 500;
              })
    ).timeout(Duration(seconds: 60)).catchError((e) {
      throw e;
    });
    if (response.statusCode == 200) {
      print(response.data);
      List<Opcional> listOpcionais = [];
      for(var a in response.data){
        listOpcionais.add(Opcional.fromJson(a));
      }
      return listOpcionais;
    } else {
      print(response.data);
      return null;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future<List<Sabor>> getSaboresService({
  String productId
}) async {
  Dio dio = getDioHttp();

  try {
    Response response = await dio.get(
        "$urlApi/Sabor/obter-por-produto?id=$productId",
          options: Options(
              followRedirects: false,
              validateStatus: (status) {
                return status < 500;
              })
    ).timeout(Duration(seconds: 20)).catchError((e) {
      throw e;
    });
    if (response.statusCode == 200) {
      print(response.data);
      List<Sabor> listSabor = [];
      for(var a in response.data){
          listSabor.add(Sabor.fromJson(a));      
      }
      return listSabor;
    } else {
      print(response.data);
      return null;
    }
  } catch (e) {
    print(e);
    return null;
  }
}