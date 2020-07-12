import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:go_food_br/src/model/company-model.dart';
import 'package:go_food_br/src/model/grupo-model.dart';
import 'package:go_food_br/src/model/product-model.dart';
import 'package:go_food_br/src/services/company-screen-service.dart';
import 'package:rxdart/rxdart.dart';

class CompanyScreenBloc extends BlocBase {
  Company company;

  final _gruposController = BehaviorSubject<List<GrupoModel>>.seeded([]);
  Function(List<GrupoModel>) get gruposIn => _gruposController.sink.add;
  Stream<List<GrupoModel>> get gruposOut => _gruposController.stream;

  final _allProductsController = BehaviorSubject<List<Product>>.seeded([]);
  Function(List<Product>) get allproductsIn => _allProductsController.sink.add;
  Stream<List<Product>> get allproductsOut => _allProductsController.stream;

  final _productsController =
      BehaviorSubject<Map<GrupoModel, List<Product>>>.seeded({});
  Function(Map<GrupoModel, List<Product>>) get productsIn =>
      _productsController.sink.add;
  Stream<Map<GrupoModel, List<Product>>> get productsOut =>
      _productsController.stream;

  final _gruposSelectController = BehaviorSubject<List<GrupoModel>>.seeded([]);
  Function(List<GrupoModel>) get gruposSelectIn =>
      _gruposSelectController.sink.add;
  Stream<List<GrupoModel>> get gruposSelectOut =>
      _gruposSelectController.stream;

  selectGrupo(GrupoModel grupoModel) {
    if (_gruposSelectController.value.contains(grupoModel)) {
      _gruposSelectController.value.remove(grupoModel);
    } else {
      _gruposSelectController.value.add(grupoModel);
    }
    _gruposSelectController.sink.add(_gruposSelectController.value);
  }

  void addCompany(Company company) {
    this.company = company;
  }

  List<Product> getAllProducts() {
    return _allProductsController.value;
  }   
 
  void loadProdutosCompany(){
     _gruposController.sink.add([]);
    _productsController.sink.add({});
    _allProductsController.sink.add([]);
    _productsController.sink.add(_productsController.value);
    _allProductsController.sink.add(_allProductsController.value);
    _gruposController.sink.add(_gruposController.value);
  }

  Company getCompany() {
    return this.company;
  }

  getDataCompany() async {
    _gruposController.sink.add([]);
    _productsController.sink.add({});
    bool grupos = await getGruposCompany(company: company, bloc: this);
    if (grupos) {
      List<Product> listAllProdutos =
          await getProductsCompany(bloc: this, company: company);
      List<GrupoModel> listaGrupos = _gruposController.value;
      _allProductsController.sink.add(listAllProdutos);       
      for (GrupoModel grupoModel in listaGrupos) {
        Map<GrupoModel, List<Product>> _products = _productsController.value;
        List<Product> listProdutos = listAllProdutos
            .where((product) =>
                product.grupoProdutoId == grupoModel.grupoProdutoId)
            .toList();
        if (listProdutos != null && listProdutos.length > 0) {
          _products[grupoModel] = listProdutos;
        }
        _productsController.sink.add(_products);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _gruposController.close();
    _productsController.close();
    _gruposSelectController.close();
    _allProductsController.close();
  }
}
