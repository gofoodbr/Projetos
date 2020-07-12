import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:go_food_br/src/app-bloc.dart';
import 'package:go_food_br/src/model/endereco-model.dart';
import 'package:go_food_br/src/services/geolocation-service.dart';
import 'package:go_food_br/src/services/register-service.dart';
import 'package:rxdart/rxdart.dart';

class RegisterEnderecoBloc extends BlocBase
{
  Future<EnderecoModel> getEndereco(String lat, String lng)async{
    loadIn(1);
    EnderecoModel enderecoModel = await getEnderecoService(
      lat: lat,
      lng: lng,
      timeOut: 10
    );
    loadIn(10);
    return enderecoModel;
  }

  final _loadController = BehaviorSubject<int>.seeded(0);
  Function(int) get loadIn => _loadController.sink.add;
  Stream<int> get loadOut => _loadController.stream;
  
  Future<String> registerEndereco({
    AppBloc appBloc,
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
  })async{
    loadIn(1);

    if(apelido.length == 0){
      loadIn(10);
      return "Apelido inválido";
    }
    if(cep.length != 10){
      loadIn(10);
      return "CEP inválido";
    }
    if(cidade.length == 0){
      loadIn(10);
      return "Cidade inválido";
    }
    if(uf.length == 0){
      loadIn(10);
      return "UF inválido";
    }
    if(bairro.length == 0){
      loadIn(10);
      return "Bairro inválido";
    }
    if(logradouro.length == 0){
      loadIn(10);
      return "Logradouro inválido";
    }
    if(numero.length == 0){
      loadIn(10);
      return "Número inválido";
    }
    if(lat.length == 0){
      loadIn(10);
      return "Latitude não encontrada";
    }
    if(lng.length == 0){
      loadIn(10);
      return "Longitude não encontrada";
    }

    bool register = await registerEnderecoService(
      apelido: apelido,
      lng: lng,
      lat: lat,
      logradouro: logradouro,
      bairro: bairro,
      uf: uf,
      cep: cep,
      complemento: complemento,
      cidade: cidade,
      numero: numero,
      idClient: appBloc.userModel.clienteId.toString()
    );
    if(register){
      loadIn(10);
      return null;
    }else{
      loadIn(10);
      return "Erro ao cadastrar endereço";
    }
  }

  @override
  void dispose() {
    super.dispose();
    _loadController.close();
  }
}