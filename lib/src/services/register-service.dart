import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_food_br/src/app-settings.dart';

Future<bool> registerUserService({
   FirebaseUser firebaseUser,
    String cpf,
    String phone,
    String sexo,
    String code
}) async {
  Dio dio = Dio();

  try {
    Response response = await dio.post(
      "$urlApi/Cliente/registrar-cliente",
      data: {
        "Nome": firebaseUser.displayName,
        "Sexo": sexo,
        "DataCadastro": DateTime.now().toString(),
        "Ativo": true,
        "Cpf": cpf.replaceAll(".", "").replaceAll("-", ""),
        "Celular": phone.replaceAll("(", "").replaceAll(")", "").replaceAll(" ", "").replaceAll("-", ""),
        "Email": firebaseUser.email,
        "Credencial": firebaseUser.uid,
        "CodigoIndicacaoCashBack": code
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

Future<bool> registerEnderecoService({
  String idClient,
  String apelido,
  String cep,
  String cidade,
  String uf,
  String bairro,
  String logradouro,
  String numero,
  String complemento,
  String lat,
  String lng
}) async {
  Dio dio = Dio();

  try {
    Response response = await dio.post(
        "$urlApi/Endereco/registrar-endereco",
        data: {
          "EnderecoId": 0,
          "Identificacao": apelido,
          "Logradouro": logradouro,
          "Cidade": cidade,
          "Uf": uf,
          "Cep": cep,
          "Bairro": bairro,
          "Complemento": complemento,
          "Numero": numero,
          "ClienteDeliveryId": idClient,
          "Latitude": lat,
          "Longitude": lng,
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