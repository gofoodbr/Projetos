class RegistroCartaoCliente {
  int clienteDeliveryId;
  int formaPagamentoDeliveryId;
  int empresaId;
  String numeroCartao;
  String nomeTitular;
  String cpf;
  String ano;
  String mes;
  String cvv;

  RegistroCartaoCliente({
       this.clienteDeliveryId, 
       this.formaPagamentoDeliveryId, 
       this.empresaId, 
       this.numeroCartao,
       this.nomeTitular,
       this.cpf,
       this.ano,
       this.mes,
       this.cvv
       });



  RegistroCartaoCliente.fromJson(Map<String, dynamic> json) {
    clienteDeliveryId = json['ClienteDeliveryId'];
    formaPagamentoDeliveryId = json['FormaPagamentoDeliveryId'];
    empresaId = json['EmpresaId'];
    numeroCartao = json['NumeroCartao'];
    nomeTitular  = json['NomeTitular'];
    cpf          = json['CPF'];
    ano          = json['Ano'];
    mes          = json['Mes'];
    cvv          = json['CVV'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ClienteDeliveryId'] = this.clienteDeliveryId;
    data['FormaPagamentoDeliveryId'] = this.formaPagamentoDeliveryId;
    data['EmpresaId'] = this.empresaId;
    data['NumeroCartao'] = this.numeroCartao;
    data['NomeTitular'] = this.numeroCartao;
    data['CPF'] = this.cpf;
    data['Ano'] = this.ano;
    data['Mes'] = this.mes;
    data['CVV'] = this.cvv;
    return data;
  }
}