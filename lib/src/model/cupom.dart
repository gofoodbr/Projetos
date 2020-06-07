class Cupom {
  int cupomDescontoDeliveryId;
  String codigoCupom;
  String validade;
  int modalidadeCupomId;
  String valorPremiacao;
  String descontoPremiacao;
  bool usoExclusivo;

  Cupom(
      {this.cupomDescontoDeliveryId,
      this.codigoCupom,
      this.validade,
      this.modalidadeCupomId,
      this.valorPremiacao,
      this.descontoPremiacao,
      this.usoExclusivo});

  Cupom.fromJson(Map<String, dynamic> json) {
    cupomDescontoDeliveryId = json['CupomDescontoDeliveryId'];
    codigoCupom = json['CodigoCupom'];
    validade = json['Validade'];
    modalidadeCupomId = json['ModalidadeCupomId'];
    valorPremiacao = json['ValorPremiacao'];
    descontoPremiacao = json['DescontoPremiacao'].toString();
    usoExclusivo = json['UsoExclusivo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CupomDescontoDeliveryId'] = this.cupomDescontoDeliveryId;
    data['CodigoCupom'] = this.codigoCupom;
    data['Validade'] = this.validade;
    data['ModalidadeCupomId'] = this.modalidadeCupomId;
    data['ValorPremiacao'] = this.valorPremiacao;
    data['DescontoPremiacao'] = this.descontoPremiacao;
    data['UsoExclusivo'] = this.usoExclusivo;
    return data;
  }
}