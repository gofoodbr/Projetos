class BannerModel {
  int bannerId;
  String descricao;
  String urlBanner;

  BannerModel({this.bannerId, this.descricao, this.urlBanner});

  BannerModel.fromJson(Map<String, dynamic> json) {
    bannerId = json['BannerId'];
    descricao = json['Descricao'];
    urlBanner = json['UrlBanner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BannerId'] = this.bannerId;
    data['Descricao'] = this.descricao;
    data['UrlBanner'] = this.urlBanner;
    return data;
  }
}