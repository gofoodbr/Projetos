import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_food_br/src/app-bloc.dart';
import 'package:go_food_br/src/app-settings.dart';
import 'package:go_food_br/src/model/banner.dart';
import 'package:go_food_br/src/model/cartao_cliente.dart';
import 'package:go_food_br/src/model/categories.dart';
import 'package:go_food_br/src/model/company-model.dart';
import 'package:go_food_br/src/model/cupom.dart';
import 'package:go_food_br/src/model/endereco-model.dart';
import 'package:go_food_br/src/model/payment.dart';
import 'package:go_food_br/src/model/user-model.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'model/FormaPagamentoDelivery.dart';
import 'model/product-model.dart';

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

Future<FirebaseUser> signInWithGoogle() async {
  try {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return user;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<bool> signOutFirebase() async {
  try {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    await googleSignIn.signOut();
    await _auth.signOut();

    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<FirebaseUser> loadCurrentUser() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseUser user = await _auth.currentUser();
  if (user != null)
    return user;
  else
    return null;
}

Future<bool> checkInternetAccess() async {
  Dio dio = Dio();
  String url = "https://www.google.com";
  try {
    Response response =
        await dio.get(url).timeout(Duration(seconds: 30)).catchError((e) {
      throw e;
    });
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
//    Tools.print(e);
    return false;
  }
}

Future<bool> getCategories(AppBloc appBloc) async {
  Dio dio = getDioHttp();
   try {
    Response response = await dio
        .get("$urlApi/Pedido/obter-categorias",
            options: Options(
                followRedirects: false,
                validateStatus: (status) {
                  return status < 500;
                }))
        .timeout(Duration(seconds: 30))
        .catchError((e) {
      throw e;
    });
    if (response.statusCode == 200) {
      List<CategoriesModel> listCategories = [];
      for (var item in response.data) {
        CategoriesModel cat = CategoriesModel.fromJson(item);
        listCategories.add(cat);
      }
      appBloc.listCategories = listCategories;
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

Future<bool> getBanner(AppBloc appBloc) async {
  Dio dio = getDioHttp();
  try {
    Response response = await dio
        .get("$urlApi/Pedido/obter-banners",
            options:  Options(
                followRedirects: false,
                validateStatus: (status) {
                  return status < 500;
                }))
        .timeout(Duration(seconds: 30))
        .catchError((e) {
      throw e;
    });
    if (response.statusCode == 200) {
      List<BannerModel> listBanners = [];
      for (var item in response.data) {
        BannerModel banner = BannerModel.fromJson(item);
        listBanners.add(banner);
      }
      appBloc.banners = listBanners;
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

Future<bool> getUser(AppBloc appBloc, {String credential}) async {
  Dio dio = getDioHttp();

  try {
    Response response = await dio
        .get("$urlApi/Cliente/obter-cliente?Credencial=$credential",
            options: Options(
                followRedirects: false,
                validateStatus: (status) {
                  return status < 500;
                }))
        .timeout(Duration(seconds: 30))
        .catchError((e) {
      throw e;
    });
    if (response.statusCode == 200 && response.data != null) {
      print(response.data);
      appBloc.userModel = UserModel.fromJson(response.data);
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

Future<bool> getEnderecosService(AppBloc appBloc) async {
  Dio dio = getDioHttp();
  print(appBloc.userModel.clienteId);
  try {
    Response response = await dio
        .get(
            "$urlApi/Endereco/obter-endereco?clienteId=${appBloc.userModel.clienteId}",
            options: Options(
                followRedirects: false,
                validateStatus: (status) {
                  return status < 500;
                }))
        .timeout(Duration(seconds: 30))
        .catchError((e) {
      print(
          "$urlApi/Endereco/obter-endereco?clienteId=${appBloc.userModel.clienteId}");
      throw e;
    });
    if (response.statusCode == 200) {
      List<EnderecoModel> enderecos = [];
      for (var value in response.data) {
        enderecos.add(EnderecoModel.fromJson(value));
      }
      appBloc.enderecosIn(enderecos);
      return true;
    } else {
      print(response.headers);
      print(response.data);
      print(response.request);
      return false;
    }
  } catch (e) {
    print(e);
    print(e);
    return false;
  }
}

Future<bool> getCompaniesService(AppBloc appBloc,
    {String lat, String lng}) async {
  Dio dio = getDioHttp();

  try {
    Response response = await dio.post("$urlApi/Pedido/obter-lojas",
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
        data: {"Latitude": lat, "Longitude": lng});
    if (response.statusCode == 200 && response.data != null) {
      print(response.data);
      List<Company> list = [];
      for (var a in response.data) {
        list.add(Company.fromJson(a));
      }
      print(list.length);
      appBloc.companiesIn(list);
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

Future<bool> getPaymentsService(AppBloc appBloc, int empresaId) async {
  Dio dio = getDioHttp();

  try {
    Response response = await dio
        .get("$urlApi/Pedido/obter-formaPagamento?empresaId=$empresaId",
            options: Options(
                followRedirects: false,
                validateStatus: (status) {
                  return status < 500;
                }))
        .timeout(Duration(seconds: 60))
        .catchError((e) {
      throw e;
    });
    if (response.statusCode == 200) {
      print(response.data);
      List<Payment> list = [];
      for (var a in response.data) {
        list.add(Payment.fromJson(a));
      }
      print(list.length);
      appBloc.paymentsIn(list);
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

Future<bool> deleteEnderecoService(AppBloc appBloc, int enderecoId) async {
  Dio dio = getDioHttp();

  try {
    Response response = await dio
        .delete("$urlApi/Endereco/deletar-endereco?enderecoId=$enderecoId",
            options: Options(
                followRedirects: false,
                validateStatus: (status) {
                  return status < 500;
                }))
        .timeout(Duration(seconds: 60))
        .catchError((e) {
      throw e;
    });
    if (response.statusCode == 200) {
      print(response.data);
      List<EnderecoModel> enderecos = appBloc.getListEnderecos();
      enderecos.removeWhere((end) => end.enderecoId == enderecoId);
      appBloc.enderecosIn(enderecos);
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

Future<bool> cupomRequestService(AppBloc appBloc, String value) async {
  Dio dio = getDioHttp();

  try {
    Response response = await dio
        .get(
            "$urlApi/Pedido/valida-cupom?codigoCupom=$value&clienteId=${appBloc.userModel.clienteId}",
            options: Options(
                followRedirects: false,
                validateStatus: (status) {
                  return status < 500;
                }))
        .timeout(Duration(seconds: 60))
        .catchError((e) {
      throw e;
    });
    if (response.statusCode == 200 && response.data != null) {
      Cupom cupom = Cupom.fromJson(response.data);
      appBloc.cupom = cupom;
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

Future<bool> setPedidoService(AppBloc appBloc,
    {Company company,
    UserModel userModel,
    List<Product> listProducts,
    Cupom cupom,
    FormaPagamentoDelivery payment,
    CartaoCliente card,
    EnderecoModel enderecoModel,
    double valorPago,
    double cashBack}) async {
  Dio dio = getDioHttp();

  List<Map<String, dynamic>> listProductsCarrinho = [];
  double valorAcrescimo = 0;
  double valorTotal = 0;
  double valorFrete = 0;

  for (Product product in listProducts) {
    listProductsCarrinho.add(product.toCarrinho());
    valorAcrescimo += product.toCarrinho()["ValorAcrescimo"];
    valorTotal += product.toCarrinho()["ValorTotal"];
  }

  double valorDesconto = 0;
  if (cupom != null) {
    valorDesconto = (double.parse(cupom.descontoPremiacao) / 100) * valorTotal;
  }

  String date = DateTime.now().toIso8601String();

  valorFrete = payment.formaPagamentoDeliveryId == 14
      ? 0
      : double.parse(company.valorFrete);

  try {
    Response response = await dio
        .post("$urlApi/Pedido/finalizar-pedido",
            options: Options(
                followRedirects: false,
                validateStatus: (status) {
                  return status < 500;
                }),
            data: {
              "EmpresaId": company.empresaId,
              "DataPedido": date,
              "StatusPedidoId": 1,
              "ClienteDeliveryId": userModel.clienteId,
              "QtdItens": listProducts.length,
              "CupomDesconto": cupom?.descontoPremiacao ?? "",
              "FormaPagamentoDeliveryId": payment.formaPagamentoDeliveryId,
              "PedidoGofood": true,
              "NomeContato": userModel.nome,
              "TelefoneContato": userModel.celular,
              "Endereco":
                  "${enderecoModel.logradouro}, ${enderecoModel.numero}",
              "Cidade": enderecoModel.cidade,
              "Uf": enderecoModel.uf,
              "Cep": enderecoModel.cep.replaceAll("-", "").replaceAll(".", ""),
              "Bairro": enderecoModel.bairro,
              "Observacao": enderecoModel.complemento,
              "ValorFrete": valorFrete,
              "ValorAcrescimo": valorAcrescimo,
              "ValorPago": valorPago,
              "ValorDesconto": valorDesconto,
              "SubTotal": valorTotal,
              "ValorTotal": valorTotal + valorFrete - valorDesconto - cashBack,
              "ValorCashBack": cashBack,
              "PagoComCashBack": cashBack > 0,
              "PedidoItens": listProductsCarrinho,
              "PagamentoOnline": card != null,
              "CartaoClienteDeliveryId":
                  card != null ? card.cartaoClienteDeliveryId : "",
            })
        .timeout(Duration(seconds: 120))
        .catchError((e) {
          throw e;
        });
    print(response.data);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}
