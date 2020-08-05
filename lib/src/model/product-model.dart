import 'package:go_food_br/src/model/company-model.dart';
import 'package:go_food_br/src/model/complemento-model.dart';
import 'package:go_food_br/src/model/grupo-model.dart';
import 'package:go_food_br/src/model/opcional.dart';
import 'package:go_food_br/src/model/sabor.dart';

class Product {
  int produtoId;
  int codigoProduto;
  bool indisponivel;
  String codigoBarraProduto;
  String descricaoProduto;
  String precoVenda;
  int grupoProdutoId;
  bool isAdicional;
  String quantidadeEstoque;
  String nomeAbreviado;
  int unidadeMedidaId;
  String unidadeMedidaCompraId;
  UnidadeMedida unidadeMedida;
  bool cardapioDigital;
  bool itemCozinha;
  bool itemProntaEntrega;
  String modoPreparo;
  String cozinhaId;
  bool itemPorPeso;
  String fileName;
  String contentType;
  String content;
  String maximoSabores;
  String minimoSabores = "0";
  String minimoOpcionais = "0";
  String maximoOpcionais = "2";
  String numeroFatias;
  String observacaoProdutos;
  String complementoProdutos;
  String saborProdutos;
  String composicaoProdutos;
  List<Complemento> complementos = [];
  List<Opcional> opcionais = [];
  List<Sabor> sabores = [];
  int quantidade = 1;
  String precoVendaPromocional = "0";
  Company company;
  GrupoModel grupoProduto;

  Product(
      {this.produtoId,
      this.codigoProduto,
      this.indisponivel,
      this.codigoBarraProduto,
      this.descricaoProduto,
      this.precoVenda,
      this.grupoProduto,
      this.grupoProdutoId,
      this.precoVendaPromocional,
      this.isAdicional,
      this.quantidadeEstoque,
      this.nomeAbreviado,
      this.unidadeMedidaId,
      this.unidadeMedidaCompraId,
      this.unidadeMedida,
      this.cardapioDigital,
      this.itemCozinha,
      this.itemProntaEntrega,
      this.modoPreparo,
      this.cozinhaId,
      this.itemPorPeso,
      this.fileName,
      this.contentType,
      this.content,
      this.maximoSabores,
      this.minimoSabores,
      this.minimoOpcionais,
      this.maximoOpcionais,
      this.numeroFatias,
      this.observacaoProdutos,
      this.complementoProdutos,
      this.saborProdutos,
      this.composicaoProdutos});

  Product.fromJson(Map<String, dynamic> json) {
    precoVendaPromocional = json["PrecoVendaPromocional"].toString();
    produtoId = json['ProdutoId'];
    codigoProduto = json['CodigoProduto'];
    indisponivel = json['Indisponivel'];
    codigoBarraProduto = json['CodigoBarraProduto'].toString();
    descricaoProduto = json['DescricaoProduto'].toString();
    precoVenda = json['PrecoVenda'].toString();
    grupoProdutoId = json['GrupoProdutoId'];
    isAdicional = json['IsAdicional'];
    quantidadeEstoque = json['QuantidadeEstoque'].toString();
    nomeAbreviado = json['NomeAbreviado'].toString();
    unidadeMedidaId = json['UnidadeMedidaId'];
    unidadeMedidaCompraId = json['UnidadeMedidaCompraId'].toString();
    unidadeMedida = json['UnidadeMedida'] != null
        ? new UnidadeMedida.fromJson(json['UnidadeMedida'])
        : null;
    grupoProduto = json['GrupoProduto'] != null
        ? new GrupoModel.fromJson(json['GrupoProduto'])
        : null;
    cardapioDigital = json['CardapioDigital'];
    itemCozinha = json['ItemCozinha'];
    itemProntaEntrega = json['ItemProntaEntrega'];
    modoPreparo = json['ModoPreparo'].toString().toString();
    cozinhaId = json['CozinhaId'].toString().toString();
    itemPorPeso = json['ItemPorPeso'];
    fileName = json['FileName'].toString();
    contentType = json['ContentType'].toString();
    content = json['Content'].toString();
    maximoSabores = json['MaximoSabores'].toString();
    minimoSabores = json['MinimoSabores'].toString();
    minimoOpcionais = json['MinimoOpcionais'].toString();
    maximoOpcionais = json['MaximoOpcionais'].toString();
    numeroFatias = json['NumeroFatias'].toString();
    observacaoProdutos = json['ObservacaoProdutos'].toString();
    complementoProdutos = json['ComplementoProdutos'].toString();
    saborProdutos = json['SaborProdutos'].toString();
    composicaoProdutos = json['ComposicaoProdutos'].toString();
  }

  Map<String, dynamic> toJson({bool image = true}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProdutoId'] = this.produtoId;
    data['CodigoProduto'] = this.codigoProduto;
    data['Indisponivel'] = this.indisponivel;
    data['CodigoBarraProduto'] = this.codigoBarraProduto;
    data['DescricaoProduto'] = this.descricaoProduto;
    data['PrecoVenda'] = this.precoVenda;
    data['GrupoProduto'] = this.grupoProduto;
    data['GrupoProdutoId'] = this.grupoProdutoId;
    data['IsAdicional'] = this.isAdicional;
    data['QuantidadeEstoque'] = this.quantidadeEstoque;
    data['NomeAbreviado'] = this.nomeAbreviado;
    data['UnidadeMedidaId'] = this.unidadeMedidaId;
    data['UnidadeMedidaCompraId'] = this.unidadeMedidaCompraId;
    if (this.unidadeMedida != null) {
      data['UnidadeMedida'] = this.unidadeMedida.toJson();
    }
    data['CardapioDigital'] = this.cardapioDigital;
    data['ItemCozinha'] = this.itemCozinha;
    data['ItemProntaEntrega'] = this.itemProntaEntrega;
    data['ModoPreparo'] = this.modoPreparo;
    data['CozinhaId'] = this.cozinhaId;
    data['ItemPorPeso'] = this.itemPorPeso;
    data['FileName'] = this.fileName;
    if (image) data['ContentType'] = this.contentType;
    if (image) data['Content'] = this.content;
    data['MaximoSabores'] = this.maximoSabores;
    data['MinimoSabores'] = this.minimoSabores;
    data['MinimoOpcionais'] = this.minimoOpcionais;
    data['MaximoOpcionais'] = this.maximoOpcionais;
    data['NumeroFatias'] = this.numeroFatias;
    data['ObservacaoProdutos'] = this.observacaoProdutos;
    data['ComplementoProdutos'] = this.complementoProdutos;
    data['SaborProdutos'] = this.saborProdutos;
    data['ComposicaoProdutos'] = this.composicaoProdutos;
    return data;
  }

  Map<String, dynamic> toCarrinho() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProdutoId'] = this.produtoId;
    data["ItemImprimido"] = false;
    data["DataImpressao"] = null;
    data["DataInclusao"] = DateTime.now().toString();
    data["Quantidade"] = this.quantidade;
    data["ValorUnitario"] = double.parse(precoVendaPromocional) > 0
        ? double.parse(precoVendaPromocional)
        : double.parse(precoVenda);
    data["Observacao"] = observacaoProdutos;
    data["ValorDesconto"] = 0;
    data["ValorAcrescimo"] = 0;
    data["Cancelado"] = false;
    data["ProdutoPromocaoItemId"] = null;
    data["Observacao"] = observacaoProdutos;
    data["SaborPedidoItens"] = getSabores();
    data["ComposicaoPedidoItens"] = getOpcionais();
    data["ComplementoPedidoItens"] = getComplementos();
    if (data["SaborPedidoItens"].length > 0) {
      if (company.preferenciaMaiorPrecoSabor) {
        double maiorPrecoSabor = 0;
        for (Sabor sabor in sabores) {
          if (double.parse(sabor.valorTotal) > maiorPrecoSabor)
            maiorPrecoSabor = double.parse(sabor.valorTotal);
        }
        if (maiorPrecoSabor > 0) data["ValorUnitario"] = maiorPrecoSabor;
      } else {
        double preco = 0;
        for (Sabor sabor in sabores) {
          preco += double.parse(sabor.valorTotal) / sabores.length;
        }
        if (preco > 0) data["ValorUnitario"] = preco;
      }
    }
    if (data["ComplementoPedidoItens"].length > 0) {
      double valorAdicional = 0;
      for (Complemento c in complementos) {
        valorAdicional += double.parse(c.produtoComplemento.precoVenda) * c.quantidade;
      }
      data["ValorAcrescimo"] = valorAdicional * quantidade;
    }

     if (data["ComposicaoPedidoItens"].length > 0) {
      double valorOpcional = 0;
      for (Opcional c in opcionais) {
        valorOpcional += double.parse(c.valorTotal) * c.quantidade;
      }
      data["ValorAcrescimo"] = valorOpcional * quantidade;
    }


    data["ValorSubTotal"] =
        (quantidade * data["ValorUnitario"]) + data["ValorAcrescimo"];
    data["ValorTotal"] = data["ValorSubTotal"];
    return data;
  }

  List<Map<String, dynamic>> getSabores() 
  {
    List<Map<String, dynamic>> data = [];
    for (Sabor sabor in this.sabores) {
      data.add({
        "SaborPedidoItemId": 0,
        "Descricao": sabor.descricao,
      });
    }
    return data;
  }

  List<Map<String, dynamic>> getOpcionais() {
    List<Map<String, dynamic>> data = [];
    for (Opcional opcional in this.opcionais) {
      data.add({
        "ComposicaoPedidoItemId": 0,
        "Descricao": opcional.descricao,
        "Quantidade": opcional.quantidade,
      });
    }
    return data;
  }

  List<Map<String, dynamic>> getComplementos() {
    List<Map<String, dynamic>> data = [];
    for (Complemento complemento in this.complementos) {
      data.add({
        "ComplementoPedidoItemId": 0,
        "Descricao": complemento.produtoComplemento.descricaoProduto,
        "Quantidade": complemento.quantidade,
        "ProdutoComplementoId": complemento.produtoComplementoId
      });
    }
    return data;
  }
}

class UnidadeMedida {
  int unidadeMedidaId;
  String descricao;
  String abreviacao;

  UnidadeMedida({this.unidadeMedidaId, this.descricao, this.abreviacao});

  UnidadeMedida.fromJson(Map<String, dynamic> json) {
    unidadeMedidaId = json['UnidadeMedidaId'];
    descricao = json['Descricao'];
    abreviacao = json['Abreviacao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UnidadeMedidaId'] = this.unidadeMedidaId;
    data['Descricao'] = this.descricao;
    data['Abreviacao'] = this.abreviacao;
    return data;
  }
}
