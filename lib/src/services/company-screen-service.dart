import 'package:dio/dio.dart';
import 'package:go_food_br/src/blocs/company-screen-bloc.dart';
import 'package:go_food_br/src/model/company-model.dart';
import 'package:go_food_br/src/model/grupo-model.dart';
import 'package:go_food_br/src/model/product-model.dart';

import '../app-settings.dart';

Future<bool> getGruposCompany({
  Company company,
  CompanyScreenBloc bloc
}) async {
  Dio dio = Dio();
  try {
    Response response = await dio.get(
        "$urlApi/Pedido/obter-grupos?empresaId=${company.empresaId}",
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
      List<GrupoModel> listGrupos = [];
      for(var a in response.data){
        listGrupos.add(GrupoModel.fromJson(a));
      }
      bloc.gruposIn(listGrupos);
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

Future<List<Product>> getProductsCompany({
  Company company,
  CompanyScreenBloc bloc,
}) async {
  Dio dio = Dio();
  try {
    Response response = await dio.get(
        "$urlApi/Pedido/obter-produtos?empresaId=${company.empresaId}",
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
      List<Product> listProducts = [];
      for(var a in response.data){
        print((Product.fromJson(a).grupoProdutoId));
        listProducts.add(Product.fromJson(a));
      }
      return listProducts;
    } else {
      print(response.data);
      return null;
    }
  } catch (e) {
    print(e);
    return null;
  }
}