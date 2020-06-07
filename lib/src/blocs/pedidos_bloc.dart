import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:go_food_br/src/model/pedido.dart';
import 'package:go_food_br/src/services/pedidos_service.dart';
import 'package:rxdart/rxdart.dart';

class PedidosBloc extends BlocBase{


  final _pedidosController = BehaviorSubject<List<Pedido>>();
  Function(List<Pedido>) get pedidosIn => _pedidosController.sink.add;
  Stream<List<Pedido>> get pedidosOut => _pedidosController.stream;

  void getPedidos(String userId)async{
    _pedidosController.add(null);
    List<Pedido> listPedidos = await getPedidosService(userId: userId);
    try {
      _pedidosController.sink.add(listPedidos);
    } catch (e) {
      print("medar");
    }
  }

  void clear(){
    _pedidosController.add(null);
  }

  @override
  void dispose() {
    super.dispose();
    _pedidosController.close();

  }
}