class CategoriesModel {
  int categoriaId;
  String descricao;
  String urlImagem;

  CategoriesModel({this.categoriaId, this.descricao, this.urlImagem});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
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