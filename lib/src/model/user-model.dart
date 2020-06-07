class UserModel {
  int clienteId;
  String observacao;
  String nome;
  String sexo;
  String dataCadastro;
  bool ativo;
  String cpf;
  String celular;
  String email;
  String password;
  String credencial;
  String codigoCashBack;
  String saldoCashBack;

  UserModel(
      {this.clienteId,
        this.observacao,
        this.nome,
        this.sexo,
        this.dataCadastro,
        this.ativo,
        this.cpf,
        this.celular,
        this.email,
        this.password,
        this.codigoCashBack,
        this.saldoCashBack,
        this.credencial});

  UserModel.fromJson(Map<String, dynamic> json) {
    clienteId = json['ClienteDeliveryId'];
    observacao = json['Observacao'];
    nome = json['Nome'];
    sexo = json['Sexo'];
    dataCadastro = json['DataCadastro'];
    ativo = json['Ativo'];
    cpf = json['Cpf'];
    celular = json['Celular'];
    email = json['Email'];
    password = json['Password'];
    credencial = json['Credencial'];
    codigoCashBack = json['CodigoCashBack'];
    saldoCashBack = json['SaldoCashBack'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ClienteDeliveryId'] = this.clienteId;
    data['Observacao'] = this.observacao;
    data['Nome'] = this.nome;
    data['Sexo'] = this.sexo;
    data['DataCadastro'] = this.dataCadastro;
    data['Ativo'] = this.ativo;
    data['Cpf'] = this.cpf;
    data['Celular'] = this.celular;
    data['Email'] = this.email;
    data['Password'] = this.password;
    data['Credencial'] = this.credencial;
    return data;
  }
}