import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_food_br/src/model/banner.dart';
import 'package:go_food_br/src/model/company-model.dart';
import 'package:go_food_br/src/model/cupom.dart';
import 'package:go_food_br/src/model/endereco-model.dart';
import 'package:go_food_br/src/model/payment.dart';
import 'package:go_food_br/src/model/product-model.dart';
import 'package:go_food_br/src/model/user-model.dart';
import 'package:go_food_br/src/services/geolocation-service.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';
import 'app-services.dart';
import 'model/categories.dart';

class AppBloc extends BlocBase{

  FirebaseUser firebaseUser;
  UserModel userModel;
  List<CategoriesModel> listCategories = [];
  List<BannerModel> banners = [];
  LocationData location;
  bool convidado = false;
  double cashback = 0;
  double troco = 0;

  bool addCashback(double value){
    if(value <= double.parse(userModel.saldoCashBack)){
      cashback = value;
      return true;
    }else{
      return false;
    }
  }

  bool addTroco(double value){
    troco = value;
  }

  void clearCarrinho(){
    _carrinhoController.sink.add([]);
    troco = 0;
    cashback = 0;
    _paymentController.sink.add(null);
    cupom = null;
  }

  final _loadController = BehaviorSubject<int>.seeded(0);
  Function(int) get loadIn => _loadController.sink.add;
  Stream<int> get loadOut => _loadController.stream;

  final _enderecosController = BehaviorSubject<List<EnderecoModel>>.seeded([]);
  Function(List<EnderecoModel>) get enderecosIn => _enderecosController.sink.add;
  Stream<List<EnderecoModel>> get enderecosOut => _enderecosController.stream;

  final _carrinhoController = BehaviorSubject<List<Product>>.seeded([]);
  Function(List<Product>) get carrinhoIn => _carrinhoController.sink.add;
  Stream<List<Product>> get carrinhoOut => _carrinhoController.stream;

  final _companiesController = BehaviorSubject<List<Company>>.seeded([]);
  Function(List<Company>) get companiesIn => _companiesController.sink.add;
  Stream<List<Company>> get companiesOut => _companiesController.stream;

  final _paymentsController = BehaviorSubject<List<Payment>>();
  Function(List<Payment>) get paymentsIn => _paymentsController.sink.add;
  Stream<List<Payment>> get paymentsOut => _paymentsController.stream;

  final _paymentController = BehaviorSubject<Payment>();
  Function(Payment) get paymentIn => _paymentController.sink.add;
  Stream<Payment> get paymentOut => _paymentController.stream;

  Payment getPayment() => _paymentController.value;

  List<EnderecoModel> getListEnderecos(){
    return _enderecosController.value;
  }

  List<Company> getListCompanies(){
    return _companiesController.value;
  }

  void initApp()async{
    var internet = await checkInternetAccess();
    if (!internet){
      loadIn(1);
      return;
    }

    await getLocation(timeOut: 10, appBloc: this);
    if(location == null){
      loadIn(10);
      return;
    }

    var user = await loadCurrentUser();
    if(user != null){
      firebaseUser = user;
      loadData();
      return;
    }else{
      loadIn(3);
      return;
    }

  }

  void login()async{
    await signOutFirebase();
    FirebaseUser user = await signInWithGoogle();
    if(user != null){
      firebaseUser = user;
      loadData();
      return;
    }else{
      loadIn(3);
      return;
    }
  }

  void loadData({bool convidado = false})async{
    loadIn(100);
    if(!convidado) await getUser(this, credential: firebaseUser.uid);
    if(userModel != null){
      bool success = convidado ? true : await getEndereco();
      if(success){
        if(_enderecosController.value.length == 0){
          loadIn(5);
          return;
        }
        bool categories = await getCategories(this);
        bool bannerOk = await getBanner(this);

        if(!categories || !bannerOk){
          loadIn(7);
          return;
        }
        bool companies = await getCompanies();
        if(!companies){
          loadIn(8);
          return;
        }
        loadIn(2);
        return;
      }else {
        loadIn(6);
        return;
      }
    }else{
      loadIn(4);
      return;
    }
  }

  void modoConvidado(){
    UserModel user = UserModel(
      ativo: true,
      nome: "Convidado"
    );
    userModel = user;
    EnderecoModel enderecoModel = EnderecoModel(
      latitude: location.latitude.toString(),
      longitude: location.longitude.toString(),
    );
    _enderecosController.sink.add([enderecoModel]);
    convidado = true;
    loadData(convidado: true);
  }

  Future<bool> getEndereco()async{
    return getEnderecosService(this);
  }

  Future<bool> getCompanies()async{
    return getCompaniesService(this, lat: getListEnderecos()[0].latitude, lng: getListEnderecos()[0].longitude);
  }

  Future<bool> setEndereco(EnderecoModel enderecoModel)async{
    List<EnderecoModel> listEnderecos = getListEnderecos();
    listEnderecos.removeWhere((endereco)=> endereco.enderecoId == enderecoModel.enderecoId);
    listEnderecos.insert(0, enderecoModel);
    _enderecosController.sink.add(listEnderecos);

    return getCompanies();
   }

  void addProductCarrinho(Product product){
    List<Product> produtos = [];
    produtos.addAll(_carrinhoController.value);

    produtos.add(product);
    _carrinhoController.sink.add(produtos);
  }

  List<Product> getCarrinho() => _carrinhoController.value;

  getPayments(){
    getPaymentsService(this, getCarrinho()[0].company.empresaId);
  }

  Future<bool> deleteEndereco(int id)async{
    return deleteEnderecoService(this, id);
  }

  Cupom cupom;

  Future<bool> getCupom(String value)async{
    return cupomRequestService(this, value);
  }

  Future<String> confirmPedido()async{
    loadIn(null);
    double valorTotal = 0;

    for(Product product in getCarrinho()){
      valorTotal += product.toCarrinho()["ValorTotal"];
    }

    double valorDesconto = 0;
    if(cupom != null){
      valorDesconto = (double.parse(cupom.descontoPremiacao)/100) * valorTotal;
    }
    
    bool value = await setPedidoService(
      this,
      cashBack: cashback,
      company: getCarrinho()[0].company,
      cupom: cupom,
      enderecoModel: getListEnderecos()[0],
      listProducts: getCarrinho(),
      payment: _paymentController.value,
      userModel: userModel,
      valorPago: troco,
    );
    if(value) loadIn(1);
    else loadIn(100);
    return value ? null : "Erro ao confirmar pedido";
  }

  @override
  void dispose() {
    super.dispose();
    _loadController.close();
    _enderecosController.close();
    _companiesController.close();
    _carrinhoController.close();
    _paymentsController.close();
    _paymentController.close();
  }
}