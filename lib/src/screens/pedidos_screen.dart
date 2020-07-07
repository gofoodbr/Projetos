import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_food_br/src/app-settings.dart';
import 'package:go_food_br/src/blocs/pedidos_bloc.dart';
import 'package:go_food_br/src/components/bottom-bar-carrinho.dart';
import 'package:go_food_br/src/model/pedido.dart';
import 'package:go_food_br/src/screens/historico_pedido_screen.dart';

import '../app-bloc.dart';
import 'package:go_food_br/src/model/bottom_navigator_item.dart';

class PedidosScreen extends StatefulWidget {
  @override
  _PedidosScreenState createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> with SingleTickerProviderStateMixin {
  final pedidosBloc = BlocProvider.getBloc<PedidosBloc>();
  final appBloc = BlocProvider.getBloc<AppBloc>();
  TabController tabController;

  @override
  void initState() {
    super.initState();
    pedidosBloc.getPedidos(appBloc.userModel.clienteId.toString());
    tabController = TabController(initialIndex: 1, length: 2, vsync: this);
  }

  final List<BottomNavigatorItem> menus = [
    BottomNavigatorItem(icon: Icons.home, text: 'Início', ),
    BottomNavigatorItem(icon: Icons.search, text: 'Busca', ),
    BottomNavigatorItem(icon: Icons.receipt, text: 'Pedidos'),
    BottomNavigatorItem(icon: Icons.person_outline, text: 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {

    List<BottomNavigationBarItem> _buildBottomIcon() => menus
        .map((menu) => BottomNavigationBarItem(
      icon: Icon(menu.icon, color: Colors.black),
      title: Text(menu.text, style: TextStyle(color: Colors.black)),
    ))
        .toList();

    return WillPopScope(
      onWillPop: ()async{
        pedidosBloc.clear();
        return true;
      },
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 20,
        onTap: (value){
          if(value == 1) Navigator.pushReplacementNamed(context, '/filter_screen');
          if(!appBloc.convidado){
            if(value == 3) Navigator.pushReplacementNamed(context, '/profile_screen');
            if(value == 2) Navigator.pushReplacementNamed(context, "/pedidos_screen");
          }
          if(value == 0) Navigator.pushReplacementNamed(context, "/home");;
        },
        items: _buildBottomIcon(),
      ),
          bottomSheet: bottomBarCarrinho(appBloc, context),
          backgroundColor: Colors.white,
          appBar: AppBar(
            bottom: TabBar(
              indicatorColor: Colors.white,
              controller: tabController,
              tabs: <Widget>[
                Tab(text: "Finalizados",),
                Tab(text: "Em andamento",),
              ],
            ),
            backgroundColor: primaryColor,
            title: Text("Meus pedidos"),
          ),
          body: TabBarView(
            controller: tabController,
            children: <Widget>[
              page(1),
              page(2),
            ],
          ),
        ),
      ),
    );
  }

  Widget page(int page){
    return Container(
      color: Colors.grey.withOpacity(0.2),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(20),
          vertical: ScreenUtil().setHeight(20)
        ),
        child: StreamBuilder<List<Pedido>>(
          stream: pedidosBloc.pedidosOut,
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              );
            }
            List<Pedido> listPedidos;
            if(page == 1){
              listPedidos = snapshot.data.where((element) => element.statusPedidoId == 3 || element.statusPedidoId == 6).toList();
            }else{
              listPedidos = snapshot.data.where((element) => element.statusPedidoId == 1 || element.statusPedidoId == 2  || element.statusPedidoId == 5).toList();
            }
            if(listPedidos.length == 0){
              return Center(
                child: Text("Nenhum pedido ${page == 1 ? "Finalizado" : "Em andamento"}",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: ScreenUtil().setSp(34)
                  ),
                ),
              );
            } 
            listPedidos.sort((a,b)=>DateTime.parse(a.dataPedido).compareTo(DateTime.parse(b.dataPedido)));
            listPedidos = listPedidos.reversed.toList();
              
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: listPedidos.length,
              shrinkWrap: true,
              itemBuilder: (context, index){
                Pedido pedido = listPedidos[index];
                Map<String, dynamic> date = getDateString(dateTime: DateTime.parse(pedido.dataPedido));
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    page == 1 ? Text("${date["dayWeek"]} • ${date["day"]} ${date["month"]} ${date["year"]}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil().setSp(38),
                        fontWeight: FontWeight.w500
                      ),
                    ): Container(),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10)),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 2,
                        child: Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(20),
                                vertical: ScreenUtil().setHeight(20),
                              ),
                              child: Column(
                                children: <Widget>[
                                   page == 1 ? Container() : _prev(pedido:pedido),
                                  _header(pedido: pedido),
                                  page == 2 ? Container() :Divider(
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                  page == 2 ? Container() : _avaliacao(pedido: pedido, avaliacao: int.parse(pedido.avaliacaoPedido?? "0")),
                                  Divider(
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                  _bottom(page == 1 ? "Detalhes": "Acompanhar", pedido)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(30),
                    )
                  ],
                );
              },
            );
          }
        ),
      ),
    );
  }

  Widget _prev({Pedido pedido}){
    String hourMin = DateTime.parse(pedido.dataEntregaMinima).hour >= 10 ? DateTime.parse(pedido.dataEntregaMinima).hour.toString() : "0${DateTime.parse(pedido.dataEntregaMinima).hour.toString()}";
    String hourMax = DateTime.parse(pedido.dataEntregaMaxima).hour >= 10 ? DateTime.parse(pedido.dataEntregaMaxima).hour.toString() : "0${DateTime.parse(pedido.dataEntregaMaxima).hour.toString()}";
    String minuteMin = DateTime.parse(pedido.dataEntregaMinima).minute >= 10 ? DateTime.parse(pedido.dataEntregaMinima).minute.toString() : "0${DateTime.parse(pedido.dataEntregaMinima).minute.toString()}";
    String minuteMax = DateTime.parse(pedido.dataEntregaMaxima).minute >= 10 ? DateTime.parse(pedido.dataEntregaMaxima).minute.toString() : "0${DateTime.parse(pedido.dataEntregaMaxima).minute.toString()}";

    String prev = "$hourMin:$minuteMin - $hourMax:$minuteMax";
      return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text("Previsão de entrega",
              style: TextStyle(
                color: Colors.grey,
                fontSize: ScreenUtil().setSp(27)
              ),
            ),
          ],
        ),
        SizedBox(
          height: ScreenUtil().setHeight(10),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(prev,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setSp(44)
              ),
            ),
          ],
        ),
        SizedBox(
          height: ScreenUtil().setHeight(15),
        ),
      ],
    );
  }

  Widget _header({Pedido pedido}){
    Image image;
    if(pedido.contentType =="image/jpeg" || pedido.contentType =="image/png"){
      image = Image.memory(base64Decode(pedido.content), fit: BoxFit.fitWidth);
    }
    return Row(
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
          width: ScreenUtil().setWidth(20),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(pedido.empresaNome,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(30)
                ),
              ),
              Text("${getStatusPedido(pedido.statusPedidoId)} • ${pedido.numeroPedido}",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: ScreenUtil().setSp(27)
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
  
  Widget _avaliacao({Pedido pedido, int avaliacao}){


    List<Widget> stars = [

    ];

    for(int i = 0; i < avaliacao; i++){
      stars.add(Icon(Icons.star,
        color: Colors.amber,
        size: ScreenUtil().setHeight(36),
      ),);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(avaliacao == 0 ? 'Sem avaliação' : "Avalição do pedido",
          style: TextStyle(
            color: Colors.black54,
            fontSize: ScreenUtil().setSp(30)
          ),
        ),
        Row(
          children: stars
        )
      ],
    );
  }

  Widget _bottom(String title, Pedido pedido){
    return Row(
      children: <Widget>[
        Expanded(child: Container()),
        Expanded(child: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> HistoricoPedido(
              pedidoId: pedido.pedidoId, pedidoOld: pedido,))).then((value){
              pedidosBloc.getPedidos(appBloc.userModel.clienteId.toString());
            });
          },
          child: Container(
            color: Colors.transparent,
            height: ScreenUtil().setHeight(60),
            child: Center(
              child: Text(title,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: ScreenUtil().setSp(30)
                ),
              ),
            ),
          ),
        ))
      ],
    );
  }


}