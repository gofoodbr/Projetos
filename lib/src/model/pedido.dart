import 'FormaPagamentoDelivery.dart';

class Pedido {
  int pedidoId;
  int empresaId;
  Empresa empresa;
  int numeroPedido;
  String dataPedido;
  String dataEntrega;
  String usuario;
  String cliente;
  String avaliacaoPedido;
  String clienteId;
  String clienteDelivery;
  int clienteDeliveryId;
  int qtdItens;
  String cupomDesconto;
  String formaPagamentoId;
  FormaPagamentoDelivery formaPagamentoDelivery;
  int formaPagamentoDeliveryId;
  bool pedidoGofood;
  String nomeContato;
  String telefoneContato;
  String endereco;
  String cidade;
  String uf;
  String cep;
  String bairro;
  String observacao;
  String valorFrete;
  String valorAcrescimo;
  String valorPago;
  String valorDesconto;
  String funcionarioId;
  String subTotal;
  String valorTotal;
  String dataEntregaMinima;
  String dataEntregaMaxima;
  int statusPedidoId;
  List<PedidoItens> pedidoItens;
  List<HistoricoStatusPedidos> historicoStatusPedidos;
  String empresaNome;
  String content;
  String contentType;
  bool pagamentoOnline;
  int cartaoClienteDeliveryId;

  Pedido(
      {this.pedidoId,
      this.empresaId,
      this.dataEntregaMaxima,
      this.dataEntregaMinima,
      this.empresa,
      this.numeroPedido,
      this.dataPedido,
      this.dataEntrega,
      this.usuario,
      this.empresaNome,
      this.cliente,
      this.content,
      this.contentType = "",
      this.clienteId,
      this.clienteDelivery,
      this.clienteDeliveryId,
      this.qtdItens,
      this.cupomDesconto,
      this.formaPagamentoId,
      this.formaPagamentoDelivery,
      this.formaPagamentoDeliveryId,
      this.pedidoGofood,
      this.nomeContato,
      this.telefoneContato,
      this.endereco,
      this.cidade,
      this.uf,
      this.cep,
      this.bairro,
      this.observacao,
      this.valorFrete,
      this.avaliacaoPedido,
      this.valorAcrescimo,
      this.valorPago,
      this.valorDesconto,
      this.funcionarioId,
      this.subTotal,
      this.valorTotal,
      this.statusPedidoId,
      this.pedidoItens,
      this.historicoStatusPedidos,
      this.pagamentoOnline,
      this.cartaoClienteDeliveryId});

  Pedido.fromJson(Map<String, dynamic> json) {
    pedidoId = json['PedidoId'];
    empresaId = json['EmpresaId'];
    empresa =
        json['Empresa'] != null ? new Empresa.fromJson(json['Empresa']) : null;
    numeroPedido = json['NumeroPedido'];
    dataPedido = json['DataPedido'];
    dataEntrega = json['DataEntrega'];
    usuario = json['Usuario'];
    dataEntregaMinima = json["DataEntregaMinima"].toString();
    dataEntregaMaxima = json["DataEntregaMaxima"].toString();
    cliente = json['Cliente'];
    avaliacaoPedido = json['AvaliacaoPedido'].toString();
    clienteId = json['ClienteId'];
    clienteDelivery = json['ClienteDelivery'];
    clienteDeliveryId = json['ClienteDeliveryId'];
    qtdItens = json['QtdItens'];
    empresaNome = json["EmpresaNome"];
    cupomDesconto = json['CupomDesconto'];
    formaPagamentoId = json['FormaPagamentoId'];
    formaPagamentoDelivery = json['FormaPagamentoDelivery'] != null
        ? new FormaPagamentoDelivery.fromJson(json['FormaPagamentoDelivery'])
        : null;
    formaPagamentoDeliveryId = json['FormaPagamentoDeliveryId'];
    pedidoGofood = json['PedidoGofood'];
    nomeContato = json['NomeContato'];
    telefoneContato = json['TelefoneContato'];
    endereco = json['Endereco'];
    cidade = json['Cidade'];
    uf = json['Uf'];
    cep = json['Cep'];
    bairro = json['Bairro'];
    observacao = json['Observacao'];
    valorFrete = json['ValorFrete'].toString();
    valorAcrescimo = json['ValorAcrescimo'].toString();
    valorPago = json['ValorPago'].toString();
    valorDesconto = json['ValorDesconto'].toString();
    funcionarioId = json['FuncionarioId'];
    subTotal = json['SubTotal'].toString();
    valorTotal = json['ValorTotal'].toString();
    content = json["Content"];
    contentType = json["ContentType"];
    statusPedidoId = json['StatusPedidoId'];
    pagamentoOnline = json['PagamentoOnline'];
    cartaoClienteDeliveryId = json['CartaoClienteDeliveryId'];
    if (json['PedidoItens'] != null) {
      pedidoItens = new List<PedidoItens>();
      json['PedidoItens'].forEach((v) {
        pedidoItens.add(new PedidoItens.fromJson(v));
      });
    }
    if (json['HistoricoStatusPedidos'] != null) {
      historicoStatusPedidos = new List<HistoricoStatusPedidos>();
      json['HistoricoStatusPedidos'].forEach((v) {
        historicoStatusPedidos.add(new HistoricoStatusPedidos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PedidoId'] = this.pedidoId;
    data['EmpresaId'] = this.empresaId;
    if (this.empresa != null) {
      data['Empresa'] = this.empresa.toJson();
    }
    data['NumeroPedido'] = this.numeroPedido;
    data['DataPedido'] = this.dataPedido;
    data['DataEntrega'] = this.dataEntrega;
    data['Usuario'] = this.usuario;
    data['Cliente'] = this.cliente;
    data['ClienteId'] = this.clienteId;
    data['ClienteDelivery'] = this.clienteDelivery;
    data['ClienteDeliveryId'] = this.clienteDeliveryId;
    data['QtdItens'] = this.qtdItens;
    data['CupomDesconto'] = this.cupomDesconto;
    data['FormaPagamentoId'] = this.formaPagamentoId;
    if (this.formaPagamentoDelivery != null) {
      data['FormaPagamentoDelivery'] = this.formaPagamentoDelivery.toJson();
    }
    data['FormaPagamentoDeliveryId'] = this.formaPagamentoDeliveryId;
    data['PedidoGofood'] = this.pedidoGofood;
    data['NomeContato'] = this.nomeContato;
    data['TelefoneContato'] = this.telefoneContato;
    data['Endereco'] = this.endereco;
    
    data['Cidade'] = this.cidade;
    data['Uf'] = this.uf;
    data['Cep'] = this.cep;
    data['Bairro'] = this.bairro;
    data['Observacao'] = this.observacao;
    data['ValorFrete'] = this.valorFrete;
    data['ValorAcrescimo'] = this.valorAcrescimo;
    data['ValorPago'] = this.valorPago;
    data['ValorDesconto'] = this.valorDesconto;
    data['FuncionarioId'] = this.funcionarioId;
    data['SubTotal'] = this.subTotal;
    data['ValorTotal'] = this.valorTotal;
    data['StatusPedidoId'] = this.statusPedidoId;
    data['PagamentoOnline'] = this.pagamentoOnline;
    data['CartaoClienteDeliveryId'] = this.cartaoClienteDeliveryId;
    if (this.pedidoItens != null) {
      data['PedidoItens'] = this.pedidoItens.map((v) => v.toJson()).toList();
    }
    if (this.historicoStatusPedidos != null) {
      data['HistoricoStatusPedidos'] =
          this.historicoStatusPedidos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Empresa {
  String empresaNome;
  String ativa;
  String rua;
  String bairro;
  String cidade;
  String uf;
  String cep;
  String numero;
  String telefone;
  String email;
  String content;
  String contentType;

  Empresa(
      {this.empresaNome,
      this.ativa,
      this.rua,
      this.bairro,
      this.cidade,
      this.uf,
      this.cep,
      this.content,
      this.contentType,
      this.numero,
      this.telefone,
      this.email});

  Empresa.fromJson(Map<String, dynamic> json) {
    empresaNome = json['EmpresaNome'];
    ativa = json['Ativa'];
    rua = json['Rua'];
    bairro = json['Bairro'];
    cidade = json['Cidade'];
    uf = json['Uf'];
    cep = json['Cep'];
    numero = json['Numero'];
    telefone = json['Telefone'];
    email = json['Email'];
    content = json["Content"];
    contentType = json["ContentType"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EmpresaNome'] = this.empresaNome;
    data['Ativa'] = this.ativa;
    data['Rua'] = this.rua;
    data['Bairro'] = this.bairro;
    data['Cidade'] = this.cidade;
    data['Uf'] = this.uf;
    data['Cep'] = this.cep;
    data['Numero'] = this.numero;
    data['Telefone'] = this.telefone;
    data['Email'] = this.email;
    return data;
  }
}

class PedidoItens {
  String pedidoItemId;
  String numeroItem;
  String pedidoId;
  Produto produto;
  String produtoId;
  String itemImprimido;
  String dataImpressao;
  String dataInclusao;
  String quantidade;
  String valorUnitario;
  String valorSubTotal;
  String valorTotal;
  String valorDesconto;
  String valorAcrescimo;
  String cancelado;
  String produtoPromocaoItemId;
  String observacao;
  String produtoVinculadoId;
  List<String> observacaoPedidoItens;
  List<SaborPedidoItens> saborPedidoItens;
  List<ComposicaoPedidoItens> composicaoPedidoItens;
  List<ComplementoPedidoItens> complementoPedidoItens;

  PedidoItens(
      {this.pedidoItemId,
      this.numeroItem,
      this.pedidoId,
      this.produto,
      this.produtoId,
      this.itemImprimido,
      this.dataImpressao,
      this.dataInclusao,
      this.quantidade,
      this.valorUnitario,
      this.valorSubTotal,
      this.valorTotal,
      this.valorDesconto,
      this.valorAcrescimo,
      this.cancelado,
      this.produtoPromocaoItemId,
      this.observacao,
      this.produtoVinculadoId,
      this.observacaoPedidoItens,
      this.saborPedidoItens,
      this.composicaoPedidoItens,
      this.complementoPedidoItens});

  PedidoItens.fromJson(Map<String, dynamic> json) {
    pedidoItemId = json['PedidoItemId'].toString();
    numeroItem = json['NumeroItem'].toString();
    pedidoId = json['PedidoId'].toString();
    produto =
        json['Produto'] != null ? new Produto.fromJson(json['Produto']) : null;
    produtoId = json['ProdutoId'].toString();
    itemImprimido = json['ItemImprimido'].toString();
    dataImpressao = json['DataImpressao'].toString();
    dataInclusao = json['DataInclusao'].toString();
    quantidade = json['Quantidade'].toString();
    valorUnitario = json['ValorUnitario'].toString();
    valorSubTotal = json['ValorSubTotal'].toString();
    valorTotal = json['ValorTotal'].toString();
    valorDesconto = json['ValorDesconto'].toString();
    valorAcrescimo = json['ValorAcrescimo'].toString();
    cancelado = json['Cancelado'].toString();
    produtoPromocaoItemId = json['ProdutoPromocaoItemId'].toString();
    observacao = json['Observacao'].toString();
    produtoVinculadoId = json['ProdutoVinculadoId'].toString();
    if (json['ObservacaoPedidoItens'] != null) {
      observacaoPedidoItens = new List<Null>();
      json['ObservacaoPedidoItens'].forEach((v) {
        observacaoPedidoItens.add(v);
      });
    }
    if (json['SaborPedidoItens'] != null) {
      saborPedidoItens = new List<SaborPedidoItens>();
      json['SaborPedidoItens'].forEach((v) {
        saborPedidoItens.add(new SaborPedidoItens.fromJson(v));
      });
    }
    if (json['ComposicaoPedidoItens'] != null) {
      composicaoPedidoItens = new List<ComposicaoPedidoItens>();
      json['ComposicaoPedidoItens'].forEach((v) {
        composicaoPedidoItens.add(new ComposicaoPedidoItens.fromJson(v));
      });
    }
    if (json['ComplementoPedidoItens'] != null) {
      complementoPedidoItens = new List<ComplementoPedidoItens>();
      json['ComplementoPedidoItens'].forEach((v) {
        complementoPedidoItens.add(new ComplementoPedidoItens.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PedidoItemId'] = this.pedidoItemId;
    data['NumeroItem'] = this.numeroItem;
    data['PedidoId'] = this.pedidoId;
    if (this.produto != null) {
      data['Produto'] = this.produto.toJson();
    }
    data['ProdutoId'] = this.produtoId;
    data['ItemImprimido'] = this.itemImprimido;
    data['DataImpressao'] = this.dataImpressao;
    data['DataInclusao'] = this.dataInclusao;
    data['Quantidade'] = this.quantidade;
    data['ValorUnitario'] = this.valorUnitario;
    data['ValorSubTotal'] = this.valorSubTotal;
    data['ValorTotal'] = this.valorTotal;
    data['ValorDesconto'] = this.valorDesconto;
    data['ValorAcrescimo'] = this.valorAcrescimo;
    data['Cancelado'] = this.cancelado;
    data['ProdutoPromocaoItemId'] = this.produtoPromocaoItemId;
    data['Observacao'] = this.observacao;
    data['ProdutoVinculadoId'] = this.produtoVinculadoId;
    if (this.observacaoPedidoItens != null) {
      data['ObservacaoPedidoItens'] =
          this.observacaoPedidoItens.map((v) => v).toList();
    }
    if (this.saborPedidoItens != null) {
      data['SaborPedidoItens'] =
          this.saborPedidoItens.map((v) => v.toJson()).toList();
    }
    if (this.composicaoPedidoItens != null) {
      data['ComposicaoPedidoItens'] =
          this.composicaoPedidoItens.map((v) => v.toJson()).toList();
    }
    if (this.complementoPedidoItens != null) {
      data['ComplementoPedidoItens'] =
          this.complementoPedidoItens.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Produto {
  String produtoId;
  String descricaoProduto;
  String precoVenda;
  String nomeAbreviado;
  String fileName;
  String contentType;
  String content;
  String maximoSabores;
  String minimoSabores;
  String maximoOpcionais;
  String minimoOpcionais;
  String grupoProdutoId;
  String isAdicional;
  String quantidadeEstoque;
  String precoVendaPromocional;

  Produto(
      {this.produtoId,
      this.descricaoProduto,
      this.precoVenda,
      this.nomeAbreviado,
      this.fileName,
      this.contentType,
      this.content,
      this.maximoSabores,
      this.minimoSabores,
      this.maximoOpcionais,
      this.minimoOpcionais,
      this.grupoProdutoId,
      this.isAdicional,
      this.quantidadeEstoque,
      this.precoVendaPromocional});

  Produto.fromJson(Map<String, dynamic> json) {
    produtoId = json['ProdutoId'].toString();
    descricaoProduto = json['DescricaoProduto'].toString();
    precoVenda = json['PrecoVenda'].toString();
    nomeAbreviado = json['NomeAbreviado'].toString();
    fileName = json['FileName'].toString();
    contentType = json['ContentType'].toString();
    content = json['Content'].toString();
    maximoSabores = json['MaximoSabores'].toString();
    minimoSabores = json['MinimoSabores'].toString();
    maximoOpcionais = json['MaximoOpcionais'].toString();
    minimoOpcionais = json['MinimoOpcionais'].toString();
    grupoProdutoId = json['GrupoProdutoId'].toString();
    isAdicional = json['IsAdicional'].toString();
    quantidadeEstoque = json['QuantidadeEstoque'].toString();
    precoVendaPromocional = json['PrecoVendaPromocional'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProdutoId'] = this.produtoId;
    data['DescricaoProduto'] = this.descricaoProduto;
    data['PrecoVenda'] = this.precoVenda;
    data['NomeAbreviado'] = this.nomeAbreviado;
    data['FileName'] = this.fileName;
    data['ContentType'] = this.contentType;
    data['Content'] = this.content;
    data['MaximoSabores'] = this.maximoSabores;
    data['MinimoSabores'] = this.minimoSabores;
    data['MaximoOpcionais'] = this.maximoOpcionais;
    data['MinimoOpcionais'] = this.minimoOpcionais;
    data['GrupoProdutoId'] = this.grupoProdutoId;
    data['IsAdicional'] = this.isAdicional;
    data['QuantidadeEstoque'] = this.quantidadeEstoque;
    data['PrecoVendaPromocional'] = this.precoVendaPromocional;
    return data;
  }
}

class SaborPedidoItens {
  String saborPedidoItemId;
  String descricao;
  String pedidoItemId;

  SaborPedidoItens({this.saborPedidoItemId, this.descricao, this.pedidoItemId});

  SaborPedidoItens.fromJson(Map<String, dynamic> json) {
    saborPedidoItemId = json['SaborPedidoItemId'].toString();
    descricao = json['Descricao'].toString();
    pedidoItemId = json['PedidoItemId'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SaborPedidoItemId'] = this.saborPedidoItemId;
    data['Descricao'] = this.descricao;
    data['PedidoItemId'] = this.pedidoItemId;
    return data;
  }
}

class ComposicaoPedidoItens {
  int composicaoPedidoItemId;
  String descricao;
  String quantidade;
  int pedidoItemId;

  ComposicaoPedidoItens(
      {this.composicaoPedidoItemId,
      this.descricao,
      this.quantidade,
      this.pedidoItemId});

  ComposicaoPedidoItens.fromJson(Map<String, dynamic> json) {
    composicaoPedidoItemId = json['ComposicaoPedidoItemId'];
    descricao = json['Descricao'];
    quantidade = json['Quantidade'].toString();
    pedidoItemId = json['PedidoItemId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ComposicaoPedidoItemId'] = this.composicaoPedidoItemId;
    data['Descricao'] = this.descricao;
    data['Quantidade'] = this.quantidade;
    data['PedidoItemId'] = this.pedidoItemId;
    return data;
  }
}

class ComplementoPedidoItens {
  String complementoPedidoItemId;
  String produtoId;
  Produto produto;
  String quantidade;
  String pedidoItemId;
  String produtoComplementoId;

  ComplementoPedidoItens(
      {this.complementoPedidoItemId,
      this.produtoId,
      this.produto,
      this.quantidade,
      this.pedidoItemId,
      this.produtoComplementoId});

  ComplementoPedidoItens.fromJson(Map<String, dynamic> json) {
    complementoPedidoItemId = json['ComplementoPedidoItemId'].toString();
    produtoId = json['ProdutoId'].toString();
    produto =
        json['Produto'] != null ? new Produto.fromJson(json['Produto']) : null;
    quantidade = json['Quantidade'].toString();
    pedidoItemId = json['PedidoItemId'].toString();
    produtoComplementoId = json['ProdutoComplementoId'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ComplementoPedidoItemId'] = this.complementoPedidoItemId;
    data['ProdutoId'] = this.produtoId;
    if (this.produto != null) {
      data['Produto'] = this.produto.toJson();
    }
    data['Quantidade'] = this.quantidade;
    data['PedidoItemId'] = this.pedidoItemId;
    data['ProdutoComplementoId'] = this.produtoComplementoId;
    return data;
  }
}

class HistoricoStatusPedidos {
  String historicoStatusPedidoId;
  String statusPedidoId;
  String pedidoId;
  String dataHistoricoPedido;
  String descricao;

  HistoricoStatusPedidos(
      {this.historicoStatusPedidoId,
      this.statusPedidoId,
      this.pedidoId,
      this.dataHistoricoPedido,
      this.descricao});

  HistoricoStatusPedidos.fromJson(Map<String, dynamic> json) {
    historicoStatusPedidoId = json['HistoricoStatusPedidoId'].toString();
    statusPedidoId = json['StatusPedidoId'].toString();
    pedidoId = json['PedidoId'].toString();
    dataHistoricoPedido = json['DataHistoricoPedido'].toString();
    descricao = json['Descricao'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['HistoricoStatusPedidoId'] = this.historicoStatusPedidoId;
    data['StatusPedidoId'] = this.statusPedidoId;
    data['PedidoId'] = this.pedidoId;
    data['DataHistoricoPedido'] = this.dataHistoricoPedido;
    data['Descricao'] = this.descricao;
    return data;
  }
}