class Company {
  int empresaId;
  String empresaNome;
  int categoriaId;
  Categoria categoria;
  String bairro;
  String cidade;
  String uf;
  String cep;
  String numero;
  String telefone;
  String cnpjCpf;
  String email;
  String fileName;
  String contentType;
  String content;
  String tempoMinimoEntrega;
  String tempoMaximoEntrega;
  String pedidoMinimo;
  String horarioInicio;
  String horarioFim;
  String infoPagamento;
  bool aceitaDinheiro;
  bool aceitaCredito;
  bool aceitaDebito;
  String resumoEmpresa;
  String aberto;
  String valorFrete;
  String latitude;
  String longitude;
  String distanciaCliente;
  String classificao;
  String descontoGofood;
  String offline;
  bool preferenciaMaiorPrecoSabor;
  bool baneseCardAtivo;
  bool zoopAtivo;
  String gofoodAtivo;

  Company(
      {this.empresaId,
        this.empresaNome,
        this.categoriaId,
        this.categoria,
        this.bairro,
        this.cidade,
        this.uf,
        this.cep,
        this.numero,
        this.telefone,
        this.cnpjCpf,
        this.email,
        this.fileName,
        this.contentType,
        this.content,
        this.tempoMinimoEntrega,
        this.tempoMaximoEntrega,
        this.pedidoMinimo,
        this.horarioInicio,
        this.horarioFim,
        this.infoPagamento,
        this.aceitaDinheiro,
        this.aceitaCredito,
        this.aceitaDebito,
        this.resumoEmpresa,
        this.aberto,
        this.preferenciaMaiorPrecoSabor,
        this.valorFrete,
        this.latitude,
        this.longitude,
        this.distanciaCliente,
        this.classificao,
        this.descontoGofood,
        this.offline,
        this.gofoodAtivo,
        this.baneseCardAtivo,
        this.zoopAtivo
        });

  Company.fromJson(Map<String, dynamic> json) {
    empresaId = json['EmpresaId'];
    empresaNome = json['EmpresaNome'].toString();
    categoriaId = json['CategoriaId'];
    categoria = json['Categoria'] != null
        ? new Categoria.fromJson(json['Categoria'])
        : null;
    bairro = json['Bairro'].toString();
    cidade = json['Cidade'].toString();
    uf = json['Uf'].toString();
    cep = json['Cep'].toString();
    numero = json['Numero'].toString();
    telefone = json['Telefone'].toString();
    cnpjCpf = json['CnpjCpf'].toString();
    email = json['Email'].toString();
    fileName = json['FileName'];
    contentType = json['ContentType'];
    content = json['Content'];
    tempoMinimoEntrega = json['TempoMinimoEntrega'].toString();
    tempoMaximoEntrega = json['TempoMaximoEntrega'].toString();
    pedidoMinimo = json['PedidoMinimo'].toString();
    horarioInicio = json['HorarioInicio'].toString();
    horarioFim = json['HorarioFim'].toString();
    infoPagamento = json['InfoPagamento'].toString();
    aceitaDinheiro = json['AceitaDinheiro'];
    aceitaCredito = json['AceitaCredito'];
    aceitaDebito = json['AceitaDebito'];
    resumoEmpresa = json['ResumoEmpresa'];
    aberto = json['Aberto'].toString();
    valorFrete = json['ValorFrete'].toString();
    latitude = json['Latitude'].toString();
    longitude = json['Longitude'].toString();
    distanciaCliente = json['DistanciaCliente'].toString();
    classificao = json['Classificao'].toString();
    descontoGofood = json['DescontoGofood'].toString();
    gofoodAtivo = json['GofoodAtivo'].toString();
    offline = json['Offline'].toString();
    preferenciaMaiorPrecoSabor = json['PreferenciaMaiorPrecoSabor'];
    zoopAtivo = json['ZoopAtivo'];
    baneseCardAtivo = json['BaneseCardAtivo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EmpresaId'] = this.empresaId;
    data['EmpresaNome'] = this.empresaNome;
    data['CategoriaId'] = this.categoriaId;
    if (this.categoria != null) {
      data['Categoria'] = this.categoria.toJson();
    }
    data['Bairro'] = this.bairro;
    data['Cidade'] = this.cidade;
    data['Uf'] = this.uf;
    data['Cep'] = this.cep;
    data['Numero'] = this.numero;
    data['Telefone'] = this.telefone;
    data['CnpjCpf'] = this.cnpjCpf;
    data['Email'] = this.email;
    data['FileName'] = this.fileName;
    data['ContentType'] = this.contentType;
    data['Content'] = this.content;
    data['TempoMinimoEntrega'] = this.tempoMinimoEntrega;
    data['TempoMaximoEntrega'] = this.tempoMaximoEntrega;
    data['PedidoMinimo'] = this.pedidoMinimo;
    data['HorarioInicio'] = this.horarioInicio;
    data['HorarioFim'] = this.horarioFim;
    data['InfoPagamento'] = this.infoPagamento;
    data['AceitaDinheiro'] = this.aceitaDinheiro;
    data['AceitaCredito'] = this.aceitaCredito;
    data['AceitaDebito'] = this.aceitaDebito;
    data['ResumoEmpresa'] = this.resumoEmpresa;
    data['Aberto'] = this.aberto;
    data['ValorFrete'] = this.valorFrete;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['DistanciaCliente'] = this.distanciaCliente;
    data['Classificao'] = this.classificao;
    data['DescontoGofood'] = this.descontoGofood;
    data['Offline'] = this.offline;
    data['GofoodAtivo'] = this.gofoodAtivo;
    data['ZoopAtivo'] = this.zoopAtivo;
    data['BaneseCardAtivo'] = this.baneseCardAtivo;
    return data;
  }
}

class Categoria {
  int categoriaId;
  String descricao;
  String urlImagem;

  Categoria({this.categoriaId, this.descricao, this.urlImagem});

  Categoria.fromJson(Map<String, dynamic> json) {
    categoriaId = json['CategoriaId'];
    descricao = json['Descricao'];
    urlImagem = json['UrlImagem'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CategoriaId'] = this.categoriaId;
    data['Descricao'] = this.descricao;
    data['UrlImagem'] = this.urlImagem;
    return data;
  }
}