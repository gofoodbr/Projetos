class EnderecoModel {
  int enderecoId;
  String identificacao;
  String logradouro;
  String cidade;
  String uf;
  String cep;
  String bairro;
  String complemento;
  String numero;
  int clienteId;
  String latitude;
  String longitude;

  EnderecoModel(
      {this.enderecoId,
        this.identificacao,
        this.logradouro,
        this.cidade,
        this.uf,
        this.cep,
        this.bairro,
        this.complemento,
        this.numero,
        this.clienteId,
        this.latitude,
        this.longitude});

  EnderecoModel.fromJson(Map<String, dynamic> json) {
    enderecoId = json['EnderecoId'];
    identificacao = json['Identificacao'];
    logradouro = json['Logradouro'];
    cidade = json['Cidade'];
    uf = json['Uf'];
    cep = json['Cep'];
    bairro = json['Bairro'];
    complemento = json['Complemento'];
    numero = json['Numero'];
    clienteId = json['ClienteDeliveryId'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EnderecoId'] = this.enderecoId;
    data['Identificacao'] = this.identificacao;
    data['Logradouro'] = this.logradouro;
    data['Cidade'] = this.cidade;
    data['Uf'] = this.uf;
    data['Cep'] = this.cep;
    data['Bairro'] = this.bairro;
    data['Complemento'] = this.complemento;
    data['Numero'] = this.numero;
    data['ClienteDeliveryId'] = this.clienteId;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    return data;
  }
}