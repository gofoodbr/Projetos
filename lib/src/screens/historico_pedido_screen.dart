import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import '../components/show-error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_food_br/src/app-settings.dart';
import 'package:go_food_br/src/blocs/historico-pedido-bloc.dart';
import 'package:go_food_br/src/model/pedido.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class HistoricoPedido extends StatefulWidget {
  final int pedidoId;
  final Pedido pedidoOld;

  const HistoricoPedido({Key key, this.pedidoId, this.pedidoOld}) : super(key: key);

  @override
  _HistoricoPedidoState createState() => _HistoricoPedidoState();
}

class _HistoricoPedidoState extends State<HistoricoPedido> {
  final historicoBloc = BlocProvider.getBloc<HistoricoBloc>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    historicoBloc.watchPedido(widget.pedidoId.toString());
    super.initState();
  }
  
  double avaliacao = 5;
  final descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        historicoBloc.pedidoIn(null);
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text("Detalhes do pedido"),
        ),
        
        body: StreamBuilder<int>(
          stream: historicoBloc.loadOut,
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              );
            }
            if(snapshot.data == 1){
              Future.delayed(Duration(
                microseconds: 500
              )).then((value){
                historicoBloc.pedidoIn(null);
                Navigator.pop(context);
              });
              historicoBloc.loadIn(100);
            }
            if(snapshot.data == 2){
              Future.delayed(Duration(
                microseconds: 500
              )).then((value){
                showError(
                  color: Colors.red,
                  message: "Erro ao excluir pedido",
                  scaffoldKey: _scaffoldKey
                );
              });
              
              historicoBloc.loadIn(100);
            }
            if(snapshot.data == 4){
              Future.delayed(Duration(
                microseconds: 500
              )).then((value){
                showError(
                  color: Colors.red,
                  message: "Erro ao confirmar recebimento",
                  scaffoldKey: _scaffoldKey
                );
              });
              historicoBloc.loadIn(100);
            }
            if(snapshot.data == 3){
              Future.delayed(Duration(
                microseconds: 500
              )).then((value){
                showRoundedModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return WillPopScope(
                      onWillPop: ()async => false,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              height: ScreenUtil().setHeight(40),
                            ),
                            Text("Avalie seu pedido",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(35)
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(20),
                            ),
                            RatingBar(
                              initialRating: avaliacao,
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: ScreenUtil().setHeight(80),
                              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                setState(() {
                                  avaliacao = rating;
                                });
                              },
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(20),
                            ),
                            Container(
                              child: TextField(
                                controller: descController,
                                decoration: InputDecoration(
                                  hintText: "Descrição"
                                ),
                              ),
                              margin: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(30)
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(20),
                            ),
                            FlatButton(onPressed: ()async{
                              historicoBloc.avaliarPedido(avaliacao.toInt(), descController.text);
                              Navigator.pop(context);
                            }, 
                              color: primaryColor,
                            child: 
                              Container(
                                width: ScreenUtil().setWidth(600),
                                height: 40,
                                child: Center(
                                  child: Text("Avaliar",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )),
                            SizedBox(
                              height: ScreenUtil().setHeight(40),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              });
              
              historicoBloc.loadIn(100);
            }
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(20),
                vertical: ScreenUtil().setHeight(20)
              ),
              child: StreamBuilder<Pedido>(
                stream: historicoBloc.pedidoOut,
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    );
                  }
                  return ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      _header(snapshot.data),
                      Divider(
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      _pedidos(snapshot.data),
                      Divider(
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      _valor(snapshot.data),
                      Divider(
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      _pagamento(snapshot.data),
                      Divider(
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      _endereco(snapshot.data),
                      Divider(
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      _buttons(snapshot.data, context, historicoBloc)
                    ],
                  );
                }
              ),
            );
          }
        ),
      ),
    );
  }

  Widget _buttons(Pedido pedido, BuildContext context, HistoricoBloc historicoBloc){
    int status = int.parse(pedido.historicoStatusPedidos.last.statusPedidoId);
    bool isOpen = status == 1 || status == 2 || status == 5;
    return Column(
      children: <Widget>[
         status == 5 ? FlatButton(onPressed: ()async{
            historicoBloc.receberPedido();
         }, 
          color: Colors.green,
        child: 
          Container(
            width: ScreenUtil().setWidth(600),
            height: 40,
            child: Center(
              child: Text("Recebi meu Pedido",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          )
        ) : Container(),
        pedido.empresa.telefone != null ? FlatButton(onPressed: ()async{
          
          String url = 'tel:${pedido.empresa.telefone}';
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
        }, 
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
          color: Colors.transparent,
        child: 
          Container(
            width: ScreenUtil().setWidth(600),
            height: 40,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.phone,
                    size: ScreenUtil().setHeight(40),
                    color: primaryColor,
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(20),
                  ),
                  Text("Ligar Para o restaurante",
                    style: TextStyle(
                      color: primaryColor,
                      
                    ),
                  ),
                ],
              ),
            ),
          )
        ) : Container(),
        status == 1 ? FlatButton(onPressed: ()async{
           historicoBloc.cancelarPedido();
         }, 
          color: Colors.red,
        child: 
          Container(
            width: ScreenUtil().setWidth(600),
            height: 40,
            child: Center(
              child: Text("Cancelar Pedido",
                style: TextStyle(
                  color: Colors.white,
                  
                ),
              ),
            ),
          )
        ) : Container(),
      ],
    );
  }

  Widget _header(Pedido pedido){
    
    DateTime data = DateTime.parse(pedido.dataPedido);
    HistoricoStatusPedidos status = pedido.historicoStatusPedidos.last;
    int statusId = int.parse(status.statusPedidoId);
    DateTime dateTime = DateTime.parse(status.dataHistoricoPedido);
    String hour = dateTime.hour < 10 ? "0${dateTime.hour}" : dateTime.hour.toString();
    String min = dateTime.minute < 10 ? "0${dateTime.minute}" : dateTime.minute.toString();
    
    Widget statusPedido(){
      if(statusId == 5 || statusId == 1 || statusId == 2){
        return Stack(
          children: <Widget>[
            LinearProgressIndicator(
              backgroundColor: primaryColor.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
            Padding(
              padding: EdgeInsets.all(ScreenUtil().setHeight(15)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: ScreenUtil().setHeight(10),
                  ),
                  Text("$hour:$min",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: ScreenUtil().setSp(46)
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(10),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.info_outline,
                        color: Colors.amber,
                        size: ScreenUtil().setHeight(40),
                      ),
                      Text(" ${status.descricao}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                          fontSize: ScreenUtil().setSp(27)
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }
      if(int.parse(status.statusPedidoId) == 3){
        return Padding(
          padding: EdgeInsets.all(ScreenUtil().setHeight(15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.info_outline,
                color: Colors.red,
                size: ScreenUtil().setHeight(40),
              ),
              Text(" Pedido cancelado",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: ScreenUtil().setSp(27)
                ),
              ),
            ],
          ),
        );
      }
      if(int.parse(status.statusPedidoId) == 6){
        return Padding(
          padding: EdgeInsets.all(ScreenUtil().setHeight(15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.info_outline,
                color: Colors.amber,
                size: ScreenUtil().setHeight(40),
              ),
              Text(" Pedido recebido ${"$hour:$min"}",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: ScreenUtil().setSp(27)
                ),
              ),
            ],
          ),
        );
      }else return Container();
    }

    Image image;
    if(pedido.empresa.contentType =="image/jpeg" || pedido.empresa.contentType =="image/png"){
      image = Image.memory(base64Decode(pedido.empresa.content), fit: BoxFit.fitWidth);
    }
    return GestureDetector(
      onTap: (){
        historicoBloc.showAll = !historicoBloc.showAll;
        setState(() {
          
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
               image == null ? Center(
                    child: CircleAvatar(
                      radius: ScreenUtil().setHeight(40),
                      backgroundColor: Colors.grey.shade200,
                    )
                ) : Center(
                  child: CircleAvatar(
                    radius: ScreenUtil().setHeight(40),
                    backgroundImage: image.image,
                    backgroundColor: Colors.grey.shade200,
                  )
                ),
              SizedBox(
                width: ScreenUtil().setWidth(25),
              ),
              Text(pedido.empresa.empresaNome,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(36),
                ),
              ),
            ],
          ),
          statusId != 0 && statusId != 1 && statusId != 2 ?
          SizedBox(
            height: ScreenUtil().setHeight(20),
          ): Container(),
          statusId != 0 && statusId != 1 && statusId != 2 && statusId != 5 ?
          Text("Realizado às ${data.hour}:${data.minute} - ${data.day}/${data.month}/${data.year}",
            style: TextStyle(
              color: Colors.black54,
              fontSize: ScreenUtil().setSp(27)
            ),
          ): Container(),
          SizedBox(
            height: ScreenUtil().setHeight(30),
          ),
          Container(
            color: Colors.grey.withOpacity(0.2),
            child: Center(
              child: Column(
                children: <Widget>[
                  statusPedido(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      !historicoBloc.showAll  && pedido.historicoStatusPedidos.length > 1 ? Icon(Icons.arrow_drop_down) : Container(),
                      SizedBox(
                        width: ScreenUtil().setWidth(10),
                      ),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    reverse: historicoBloc.showAll ? true : false,
                    itemCount: !historicoBloc.showAll  && pedido.historicoStatusPedidos.length > 1 ? 0 : pedido.historicoStatusPedidos.length -1,
                    itemBuilder: (context, index){
                      DateTime dateIndex = DateTime.parse(pedido.historicoStatusPedidos[index].dataHistoricoPedido);
                      String hourIndex = dateIndex.hour < 10 ? "0${dateIndex.hour}" : dateIndex.hour.toString();
                      String minIndex = dateIndex.minute < 10 ? "0${dateIndex.minute}" : dateIndex.minute.toString();
                      return Container(
                        margin: EdgeInsets.only(
                          bottom: ScreenUtil().setHeight(15)
                        ),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: ScreenUtil().setWidth(10),
                            ),
                            Icon(Icons.watch_later,
                              color: Colors.black45,
                              size: ScreenUtil().setHeight(30),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(10),
                            ),
                            Expanded(
                              child: Text("${"$hourIndex:$minIndex"} - ${pedido.historicoStatusPedidos[index].descricao}",
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: ScreenUtil().setSp(28)
                                ),
                              ),
                            ),
                            index == 0 ? GestureDetector(
                              onTap: (){
                                historicoBloc.showAll = !historicoBloc.showAll;
                                setState(() {
                                  
                                });
                              },
                              child: Icon(!historicoBloc.showAll ? Icons.arrow_drop_down : Icons.arrow_drop_up)
                            ) : Container(),
                            SizedBox(
                              width: ScreenUtil().setWidth(10),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              )
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(30),
          ),
          Text("Pedido ${pedido.numeroPedido}",
            style: TextStyle(
              color: Colors.black,
              fontSize: ScreenUtil().setSp(30)
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _pedidos(Pedido pedido){
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: pedido.pedidoItens.length,
      itemBuilder: (context,index){
        PedidoItens item = pedido.pedidoItens[index];
        List<String> complementos = []; 
        for(var a in item.composicaoPedidoItens){
          complementos.add(a.descricao);
        }
        for(var a in item.saborPedidoItens){
          complementos.add(a.descricao);
        }
        for(var a in item.complementoPedidoItens){
          complementos.add(a.produto.nomeAbreviado);
        }
        return Column(
          children: <Widget>[
            SizedBox(
              height: ScreenUtil().setHeight(10),
            ),
            Row(
              children: <Widget>[
                Text('${double.parse(item.quantidade).truncate().toString()}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: ScreenUtil().setSp(32),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(20),
                ),
                Text(item.produto.nomeAbreviado,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: ScreenUtil().setSp(32),
                  ),
                ),
                Expanded(child: Container(),),
                Text(formatPrice(double.parse(item.valorTotal)),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: ScreenUtil().setSp(32),
                  ),
                ),
              ],
            ),
            ListView.builder(
              itemCount: complementos.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index){
                return Text(complementos[index],
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: ScreenUtil().setSp(32),
                  ),
                );
              },
            ),
            SizedBox(
              height: ScreenUtil().setHeight(10),
            ),
          ],
        );
      },
    );
  }
 
  Widget _valor(Pedido pedido){
    return Column(
      children: <Widget>[
        SizedBox(
          height: ScreenUtil().setHeight(30),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("SubTotal",
              style: TextStyle(
                color: Colors.grey,
                fontSize: ScreenUtil().setSp(32),
              ),
            ),
            Text(formatPrice(double.parse(pedido.subTotal)),
              style: TextStyle(
                color: Colors.grey,
                fontSize: ScreenUtil().setSp(32),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Frete",
              style: TextStyle(
                color: Colors.grey,
                fontSize: ScreenUtil().setSp(32),
              ),
            ),
            Text(formatPrice(double.parse(pedido.valorFrete)),
              style: TextStyle(
                color: Colors.grey,
                fontSize: ScreenUtil().setSp(32),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Desconto",
              style: TextStyle(
                color: Colors.grey,
                fontSize: ScreenUtil().setSp(32),
              ),
            ),
            Text(formatPrice(double.parse(pedido.valorDesconto)),
              style: TextStyle(
                color: Colors.grey,
                fontSize: ScreenUtil().setSp(32),
              ),
            ),
          ],
        ),
        SizedBox(
          height: ScreenUtil().setHeight(30),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Total",
              style: TextStyle(
                color: Colors.black,
                fontSize: ScreenUtil().setSp(35),
              ),
            ),
            Text(formatPrice(double.parse(pedido.valorTotal)),
              style: TextStyle(
                color: Colors.black,
                fontSize: ScreenUtil().setSp(35),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _pagamento(Pedido pedido){
    return Column(
      children: <Widget>[
        SizedBox(
          height: ScreenUtil().setHeight(10),
        ),
        Row(
          children: <Widget>[
            Text(
              pedido.pagamentoOnline == true ? "Pagamento pelo gofood" :
              "Pagamento na entrega",
              style: TextStyle(
                color: Colors.black,
                fontSize: ScreenUtil().setSp(30),
              ),
            ),
            Expanded(child: Container(),),
            Image.network("$urlApi/${pedido.formaPagamentoDelivery.imagemUrl}",
              height: ScreenUtil().setHeight(50),
            ),
            Text(formatPrice(double.parse(pedido.valorTotal)),
              style: TextStyle(
                color: Colors.black,
                fontSize: ScreenUtil().setSp(30),
              ),
            ),
          ],
        ),
        SizedBox(
          height: ScreenUtil().setHeight(10),
        ),
      ],
    );
  }

  Widget _endereco(Pedido pedido){

    String endereco = pedido.endereco;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: ScreenUtil().setHeight(20),
        ),
        Row(
          children: <Widget>[
            Text("Endereço de entrega",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: ScreenUtil().setSp(26),
                ),
              ),
          ],
        ),
        SizedBox(
          height: ScreenUtil().setHeight(10),
        ),
        Row(
          children: <Widget>[
            Text(endereco,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(33),
                ),
              ),
          ],
        ),
        SizedBox(
          height: ScreenUtil().setHeight(20),
        ),
      ],
    );
  }
  

}