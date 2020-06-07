class Complemento {
  int complementoProdutoId;
  int produtoId;
  ProdutoComplemento produtoComplemento;
  int produtoComplementoId;
  bool obrigatorio;

  Complemento(
      {this.complementoProdutoId,
      this.produtoId,
      this.produtoComplemento,
      this.produtoComplementoId,
      this.obrigatorio});

  Complemento.fromJson(Map<String, dynamic> json) {
    complementoProdutoId = json['ComplementoProdutoId'];
    produtoId = json['ProdutoId'];
    produtoComplemento = json['ProdutoComplemento'] != null
        ? new ProdutoComplemento.fromJson(json['ProdutoComplemento'])
        : null;
    produtoComplementoId = json['ProdutoComplementoId'];
    obrigatorio = json['Obrigatorio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ComplementoProdutoId'] = this.complementoProdutoId;
    data['ProdutoId'] = this.produtoId;
    if (this.produtoComplemento != null) {
      data['ProdutoComplemento'] = this.produtoComplemento.toJson();
    }
    data['ProdutoComplementoId'] = this.produtoComplementoId;
    data['Obrigatorio'] = this.obrigatorio;
    return data;
  }
}

class ProdutoComplemento {
  int produtoId;
  String descricaoProduto;
  String precoVenda;
  String nomeAbreviado;
  String fileName;
  String contentType;
  String content;
  String maximoSabores;
  String minimoSabores;
  String numeroFatias;

  ProdutoComplemento(
      {this.produtoId,
      this.descricaoProduto,
      this.precoVenda,
      this.nomeAbreviado,
      this.fileName,
      this.contentType,
      this.content,
      this.maximoSabores,
      this.minimoSabores,
      this.numeroFatias});

  ProdutoComplemento.fromJson(Map<String, dynamic> json) {
    produtoId = json['ProdutoId'];
    descricaoProduto = json['DescricaoProduto'];
    precoVenda = json['PrecoVenda'].toString();
    nomeAbreviado = json['NomeAbreviado'];
    fileName = json['FileName'];
    contentType = json['ContentType'];
    content = json['Content'];
    maximoSabores = json['MaximoSabores'].toString();
    minimoSabores = json['MinimoSabores'].toString();
    numeroFatias = json['NumeroFatias'].toString();
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
    data['NumeroFatias'] = this.numeroFatias;
    return data;
  }
}