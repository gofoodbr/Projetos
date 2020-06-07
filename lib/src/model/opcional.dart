class Opcional {
  int composicaoProdutoId;
  String descricao;
  String produto;
  int produtoId;
  String resultadoValidacao;

  Opcional(
      {this.composicaoProdutoId,
      this.descricao,
      this.produto,
      this.produtoId,
      this.resultadoValidacao});

  Opcional.fromJson(Map<String, dynamic> json) {
    composicaoProdutoId = json['ComposicaoProdutoId'];
    descricao = json['Descricao'];
    produto = json['Produto'];
    produtoId = json['ProdutoId'];
    resultadoValidacao = json['ResultadoValidacao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ComposicaoProdutoId'] = this.composicaoProdutoId;
    data['Descricao'] = this.descricao;
    data['Produto'] = this.produto;
    data['ProdutoId'] = this.produtoId;
    data['ResultadoValidacao'] = this.resultadoValidacao;
    return data;
  }
}