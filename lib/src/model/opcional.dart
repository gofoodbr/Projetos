class Opcional {
  int composicaoProdutoId;
  String descricao;
  String produto;
  int produtoId;
  int categoriaOpcionalProdutoId;
  String resultadoValidacao;
  String valorTotal; 
  CategoriaOpcional categoria;

  Opcional(
      {
        this.composicaoProdutoId,
        this.descricao,
        this.produto,
        this.produtoId,
        this.valorTotal,
        this.categoria,
        this.categoriaOpcionalProdutoId
      });

  Opcional.fromJson(Map<String, dynamic> json) {
    composicaoProdutoId = json['ComposicaoProdutoId'];
    descricao = json['Descricao'];
    produto = json['Produto'];
    valorTotal = json['ValorTotal'].toString() == 'null' ? '0' : json['ValorTotal'].toString();
    produtoId = json['ProdutoId'];
    categoriaOpcionalProdutoId = json['CategoriaOpcionalProdutoId'];
    categoria = json['CategoriaOpcionalProduto'] != null
        ? new CategoriaOpcional.fromJson(json['CategoriaOpcionalProduto'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ComposicaoProdutoId'] = this.composicaoProdutoId;
    data['Descricao'] = this.descricao;
    data['Produto'] = this.produto;
    data['ValorTotal'] = this.valorTotal;
    data['ProdutoId'] = this.produtoId;
    data['CategoriaOpcionalProdutoId'] = this.categoriaOpcionalProdutoId;
    return data;
  }
}

class CategoriaOpcional {
  int categoriaOpcionalProdutoId;
  String nomeCategoria;
  int maximoOpcionais;
  int minimoOpcionais;

  CategoriaOpcional({
     this.categoriaOpcionalProdutoId,
     this.maximoOpcionais,
     this.minimoOpcionais,
     this.nomeCategoria
  });

  CategoriaOpcional.fromJson(Map<String, dynamic> json) {
    categoriaOpcionalProdutoId = json['CategoriaOpcionalProdutoId'];
    maximoOpcionais = json['MaximoOpcionais'];
    minimoOpcionais = json['MinimoOpcionais'];
    nomeCategoria = json['NomeCategoria'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CategoriaOpcionalProdutoId'] = this.categoriaOpcionalProdutoId;
    data['MaximoOpcionais'] = this.maximoOpcionais;
    data['MinimoOpcionais'] = this.minimoOpcionais;
    data['NomeCategoria'] = this.nomeCategoria;
    return data;
  }


  
}