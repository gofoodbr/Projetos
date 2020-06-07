class Sabor {
  int saborProdutoId;
  String descricao;
  String composicao;
  String valorFatia;
  String valorTotal;
  String produto;
  String produtoId;
  String ativo;
  String resultadoValidacao;

  Sabor(
      {this.saborProdutoId,
      this.descricao,
      this.composicao,
      this.valorFatia,
      this.valorTotal,
      this.produto,
      this.produtoId,
      this.ativo,
      this.resultadoValidacao});

  Sabor.fromJson(Map<String, dynamic> json) {
    saborProdutoId = json['SaborProdutoId'];
    descricao = json['Descricao'].toString();
    composicao = json['Composicao'].toString();
    valorFatia = json['ValorFatia'].toString();
    valorTotal = json['ValorTotal'].toString();
    produto = json['Produto'].toString();
    produtoId = json['ProdutoId'].toString();
    ativo = json['Ativo'].toString();
    resultadoValidacao = json['ResultadoValidacao'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SaborProdutoId'] = this.saborProdutoId;
    data['Descricao'] = this.descricao;
    data['Composicao'] = this.composicao;
    data['ValorFatia'] = this.valorFatia;
    data['ValorTotal'] = this.valorTotal;
    data['Produto'] = this.produto;
    data['ProdutoId'] = this.produtoId;
    data['Ativo'] = this.ativo;
    data['ResultadoValidacao'] = this.resultadoValidacao;
    return data;
  }
}