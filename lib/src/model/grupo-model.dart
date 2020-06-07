class GrupoModel {
  int grupoProdutoId;
  String descricao;

  GrupoModel({this.grupoProdutoId, this.descricao});

  GrupoModel.fromJson(Map<String, dynamic> json) {
    grupoProdutoId = json['GrupoProdutoId'];
    descricao = json['Descricao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GrupoProdutoId'] = this.grupoProdutoId;
    data['Descricao'] = this.descricao;
    return data;
  }
}