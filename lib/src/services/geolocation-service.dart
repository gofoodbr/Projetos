import 'package:dio/dio.dart';
import 'package:go_food_br/src/app-bloc.dart';
import 'package:go_food_br/src/model/endereco-model.dart';
import 'package:location/location.dart';

Future<Null> getLocation({int timeOut, AppBloc appBloc}) async {
  bool result;
  int contador = 1;
  while (contador <= 3) {
    print(contador);
    result = await _getLocation(timeOut: timeOut, appBloc: appBloc);
    if (result != null) {
      contador = 99;
    }
    else {
      await Future.delayed(Duration(seconds: 2));
      print('numero de tentativa obter a geoolocalizacao = $contador');
      contador++;
    }
  }
}

Future<bool> _getLocation({int timeOut, AppBloc appBloc}) async {
  Location _locationService = new Location();
  Duration _timeOut = Duration(seconds: timeOut??15);
  try {
    await _locationService.changeSettings()
        .timeout(_timeOut)
        .catchError((e) {throw e;}
    );
    LocationData location = await _locationService.getLocation()
        .timeout(_timeOut)
        .catchError((e) {
      throw e;
    });

    appBloc.location = location;
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<EnderecoModel> getEnderecoService({int timeOut, String lat, String lng}) async {
  Dio dio = Dio();

  try {
    Response response = await dio.get(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyChqIs0L4jc-I7Jtc75oysEEaXzVEb4cJk",
    ).timeout(Duration(seconds: 20)).catchError((e) {
      throw e;
    });
    if (response.statusCode == 200) {

      EnderecoModel enderecoModel = EnderecoModel();

      List componentes  = response.data["results"][0]["address_components"];

      for(var _address in componentes){
        if(_address["types"][0] == "street_number") enderecoModel.numero = _address["long_name"];
        if(_address["types"][0] == "route") enderecoModel.logradouro = _address["long_name"];
        if(_address["types"][0] == "political") enderecoModel.bairro = _address["long_name"];
        if(_address["types"][0] == "administrative_area_level_2") enderecoModel.cidade = _address["long_name"];
        if(_address["types"][0] == "administrative_area_level_1") enderecoModel.uf = _address["short_name"];
        if(_address["types"][0] == "postal_code"){
          enderecoModel.cep = _address["long_name"];
          if (enderecoModel.cep.length == 9) enderecoModel.cep = "${enderecoModel.cep.substring(0,2)}.${enderecoModel.cep.substring(2,9)}";
        }
      }

      return enderecoModel;
    } else {
      print(response.data);
      return null;
    }
  } catch (e) {
    print(e);
    return null;
  }
}
