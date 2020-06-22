import 'FormaPagamentoDelivery.dart';

class CartaoCliente {
  int cartaoClienteDeliveryId;
  int formaPagamentoDeliveryId;
  FormaPagamentoDelivery formaPagamentoDelivery;
  String token;
  String numeroCartao;

  CartaoCliente({
       this.cartaoClienteDeliveryId, 
       this.formaPagamentoDeliveryId, 
       this.token, 
       this.numeroCartao});



  CartaoCliente.fromJson(Map<String, dynamic> json) {
    cartaoClienteDeliveryId = json['CartaoClienteDeliveryId'];
    formaPagamentoDeliveryId = json['FormaPagamentoDeliveryId'];
    token = json['Token'];
    numeroCartao = json['NumeroCartao'];
    formaPagamentoDelivery = json['FormaPagamentoDelivery'] != null
        ? new FormaPagamentoDelivery.fromJson(json['FormaPagamentoDelivery'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CartaoClienteDeliveryId'] = this.cartaoClienteDeliveryId;
    data['FormaPagamentoDeliveryId'] = this.formaPagamentoDeliveryId;
    data['Token'] = this.token;
    data['NumeroCartao'] = this.numeroCartao;
    if (this.formaPagamentoDelivery != null) {
      data['FormaPagamentoDelivery'] = this.formaPagamentoDelivery.toJson();
    }
    return data;
  }
}