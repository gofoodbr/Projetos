class FormaPagamentoDelivery {
  int formaPagamentoDeliveryId;
  String nome;
  String imagemUrl;
  bool pagamentoEntrega;

  FormaPagamentoDelivery(
      {this.formaPagamentoDeliveryId, this.nome, this.imagemUrl, this.pagamentoEntrega});

  FormaPagamentoDelivery.fromJson(Map<String, dynamic> json) {
    formaPagamentoDeliveryId = json['FormaPagamentoDeliveryId'];
    nome = json['Nome'];
    imagemUrl = json['ImagemUrl'];
    pagamentoEntrega = json['PagamentoEntrega'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FormaPagamentoDeliveryId'] = this.formaPagamentoDeliveryId;
    data['Nome'] = this.nome;
    data['ImagemUrl'] = this.imagemUrl;
    data['PagamentoEntrega'] = this.pagamentoEntrega;
    return data;
  }
}