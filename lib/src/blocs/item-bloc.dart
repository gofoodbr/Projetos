import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:go_food_br/src/app-bloc.dart';
import 'package:go_food_br/src/model/complemento-model.dart';
import 'package:go_food_br/src/model/opcional.dart';
import 'package:go_food_br/src/model/product-model.dart';
import 'package:go_food_br/src/model/sabor.dart';
import 'package:go_food_br/src/services/product-service.dart';
import 'package:rxdart/rxdart.dart';

class ItemBloc extends BlocBase {
  final _qntSaboresController = BehaviorSubject<int>.seeded(0);
  Function(int) get qntSaboresIn => _qntSaboresController.sink.add;
  Stream<int> get qntSaboresOut => _qntSaboresController.stream;

  final _productsController = BehaviorSubject<Product>();
  Function(Product) get productsIn => _productsController.sink.add;
  Stream<Product> get productsOut => _productsController.stream;

  final _listComplementosController = BehaviorSubject<List<Complemento>>();
  Function(List<Complemento>) get complementoIn =>
      _listComplementosController.sink.add;
  Stream<List<Complemento>> get complementoOut =>
      _listComplementosController.stream;

  final _listSaboresController = BehaviorSubject<List<Sabor>>();
  Function(List<Sabor>) get saboresIn => _listSaboresController.sink.add;
  Stream<List<Sabor>> get saboresOut => _listSaboresController.stream;

  final _listOpcionaisController = BehaviorSubject<List<Opcional>>();
  Function(List<Opcional>) get opcionaisIn => _listOpcionaisController.sink.add;
  Stream<List<Opcional>> get opcionaisOut => _listOpcionaisController.stream;

  getComplemento() async {
    List<Complemento> listComplementos = await getComplementosService(
        productId: _productsController.value.produtoId.toString());
    if (listComplementos != null) {
      _listComplementosController.sink.add(listComplementos);

      for (Complemento complemento in listComplementos) {
        if (complemento.obrigatorio &&
            _productsController.value.complementos
                    .where((v) =>
                        v.complementoProdutoId ==
                        complemento.complementoProdutoId)
                    .length ==
                0) {
          List<Complemento> listComplementos =
              _productsController.value.complementos ?? [];
          listComplementos.add(complemento);

          Product product = _productsController.value;
          product.complementos = listComplementos;

          _productsController.sink.add(product);
        }
      }
    }
  }

  getOpcionais() async {
    List<Opcional> listOpcionais = await getOpcionaisService(
        productId: _productsController.value.produtoId.toString());

    if (listOpcionais.length != null) {
      _listOpcionaisController.sink.add(listOpcionais);
    }
  }

  getSabores() async {
    print(_productsController.value.maximoSabores);
    if (_productsController.value.maximoSabores != "null" &&
        _productsController.value.maximoSabores != null) {
      _qntSaboresController.sink
          .add(int.parse(_productsController.value.maximoSabores ?? "0"));
    } else {
      _qntSaboresController.sink.add(int.parse("0"));
    }
    List<Sabor> listSabor = await getSaboresService(
        productId: _productsController.value.produtoId.toString());
    if (listSabor.length != null) {
      _listSaboresController.sink.add(listSabor);
    }
  }

  clear() {
    _listComplementosController.sink.add(null);
    _productsController.sink.add(null);
    _listOpcionaisController.sink.add(null);
    _listSaboresController.sink.add(null);
  }

  void addComplemento(Complemento complemento) {
    if (!complemento.obrigatorio) {
      List<Complemento> listComplementos =
          _productsController.value.complementos ?? [];
      listComplementos.add(complemento);

      Product product = _productsController.value;
      product.complementos = listComplementos;

      _productsController.sink.add(product);
    }
  }

  String addCarrinho(AppBloc appBloc, String obs) {
    _productsController.value.observacaoProdutos = obs;
    _productsController.sink.add(_productsController.value);
    _listOpcionaisController.sink.add(_listOpcionaisController.value);
    List<Product> products = appBloc.getCarrinho();
    int produtosEmpresaOutra = products
        .where((a) =>
            a.company.empresaId != _productsController.value.company.empresaId)
        .length;
    if (produtosEmpresaOutra == 0) {
      var categorias = new List<CategoriaOpcional>();
      for (var item in _listOpcionaisController.value) {
        if (categorias
                .where((e) =>
                    e.categoriaOpcionalProdutoId ==
                    item.categoriaOpcionalProdutoId)
                .length ==
            0) categorias.add(item.categoria);
      }

      int minimo = 0;
      for (var categoria in categorias) {
        var _opcionalCategoriaList = _productsController.value.opcionais
            .where((e) =>
                e.categoriaOpcionalProdutoId ==
                categoria.categoriaOpcionalProdutoId)
            .toList();

        if (produtosEmpresaOutra == 0) {
          minimo = categoria.minimoOpcionais;
        }

        if (_opcionalCategoriaList.length < minimo) {
          return "Escolha pelo menos ${categoria.minimoOpcionais} ${minimo == 1 ? "opcional" : "opcionais"} de ${categoria.nomeCategoria}";
        }
      }

      if (_productsController.value.sabores.length <
          _qntSaboresController.value) {
        return "Escolha pelo menos  ${_qntSaboresController.value} ${_qntSaboresController.value == 1 ? "sabor" : "sabores"}";
      } else {
        appBloc.addProductCarrinho(_productsController.value);
        return null;
      }
    } else {
      return "modal";
    }
  }

  void addOpcionais(Opcional opcional) {
    List<Opcional> listOpcionais = _productsController.value.opcionais ?? [];
    if (listOpcionais.contains(opcional)) {
      listOpcionais.remove(opcional);
      Product product = _productsController.value;
      product.opcionais = listOpcionais;
      _productsController.sink.add(product);
    } else {
      var opcionalCategiriaIncluso = _productsController.value.opcionais
          .where((e) =>
              e.categoriaOpcionalProdutoId ==
              opcional.categoriaOpcionalProdutoId)
          .toList();
      if (opcionalCategiriaIncluso == null ||
          opcionalCategiriaIncluso.length <
              opcional.categoria.maximoOpcionais) {
        listOpcionais.add(opcional);
        Product product = _productsController.value;
        product.opcionais = listOpcionais;
        _productsController.sink.add(product);
      }
    }
  }

  void removeComplemento(Complemento complemento) {
    if (!complemento.obrigatorio) {
      List<Complemento> listComplementos =
          _productsController.value.complementos ?? [];
      listComplementos.remove(complemento);

      Product product = _productsController.value;
      product.complementos = listComplementos;

      _productsController.sink.add(product);
    }
  }

  void addQnt({bool remove = false}) {
    if (!remove) {
      Product product = _productsController.value;
      product.quantidade = product.quantidade + 1;
      _productsController.sink.add(product);
    } else {
      Product product = _productsController.value;
      if (product.quantidade != 1) product.quantidade = product.quantidade - 1;
      _productsController.sink.add(product);
    }
  }

  void addQntSabores() {
    int maxSabores = int.parse(_productsController.value.maximoSabores);
    if (maxSabores > _qntSaboresController.value) {
      _qntSaboresController.sink.add(_qntSaboresController.value + 1);
    }
  }

  void subQntSabores() {
    int minSabores = int.parse(_productsController.value.minimoSabores);
    if (minSabores < _qntSaboresController.value) {
      _qntSaboresController.sink.add(_qntSaboresController.value - 1);
    }
  }

  addSabor(Sabor sabor) {
    List<Sabor> listSabores = _productsController.value.sabores ?? [];
    if (listSabores.contains(sabor)) {
      listSabores.remove(sabor);
      Product product = _productsController.value;
      product.sabores = listSabores;
      _productsController.sink.add(product);
    } else {
      if (_productsController.value.sabores.length <
          _qntSaboresController.value) {
        listSabores.add(sabor);
        Product product = _productsController.value;
        product.sabores = listSabores;
        _productsController.sink.add(product);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _listComplementosController.close();
    _productsController.close();
    _listOpcionaisController.close();
    _listSaboresController.close();
    _qntSaboresController.close();
  }
}
