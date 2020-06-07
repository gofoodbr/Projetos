class Payment {
  int formaPagamentoLojistaId;
  int empresaId;
  FormaPagamentoDelivery formaPagamentoDelivery;
  int formaPagamentoDeliveryId;
  bool ativa;

  Payment(
      {this.formaPagamentoLojistaId,
      this.empresaId,
      this.formaPagamentoDelivery,
      this.formaPagamentoDeliveryId,
      this.ativa});

  Payment.fromJson(Map<String, dynamic> json) {
    formaPagamentoLojistaId = json['FormaPagamentoLojistaId'];
    empresaId = json['EmpresaId'];
    formaPagamentoDelivery = json['FormaPagamentoDelivery'] != null
        ? new FormaPagamentoDelivery.fromJson(json['FormaPagamentoDelivery'])
        : null;
    formaPagamentoDeliveryId = json['FormaPagamentoDeliveryId'];
    ativa = json['Ativa'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FormaPagamentoLojistaId'] = this.formaPagamentoLojistaId;
    data['EmpresaId'] = this.empresaId;
    if (this.formaPagamentoDelivery != null) {
      data['FormaPagamentoDelivery'] = this.formaPagamentoDelivery.toJson();
    }
    data['FormaPagamentoDeliveryId'] = this.formaPagamentoDeliveryId;
    data['Ativa'] = this.ativa;
    return data;
  }
}

class FormaPagamentoDelivery {
  int formaPagamentoDeliveryId;
  String nome;
  String imagemUrl;

  FormaPagamentoDelivery(
      {this.formaPagamentoDeliveryId, this.nome, this.imagemUrl});

  FormaPagamentoDelivery.fromJson(Map<String, dynamic> json) {
    formaPagamentoDeliveryId = json['FormaPagamentoDeliveryId'];
    nome = json['Nome'];
    imagemUrl = json['ImagemUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FormaPagamentoDeliveryId'] = this.formaPagamentoDeliveryId;
    data['Nome'] = this.nome;
    data['ImagemUrl'] = this.imagemUrl;
    return data;
  }
}