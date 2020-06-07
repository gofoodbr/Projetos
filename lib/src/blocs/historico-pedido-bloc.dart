import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:go_food_br/src/model/pedido.dart';
import 'package:go_food_br/src/services/pedidos_service.dart';
import 'package:rxdart/rxdart.dart';

class HistoricoBloc extends BlocBase{

  final _pedidoController = BehaviorSubject<Pedido>();
  Function(Pedido) get pedidoIn => _pedidoController.sink.add;
  Stream<Pedido> get pedidoOut => _pedidoController.stream;

  final _loadController = BehaviorSubject<int>.seeded(100);
  Function(int) get loadIn => _loadController.sink.add;
  Stream<int> get loadOut => _loadController.stream;

  bool looping = true;

  watchPedido(String id)async{
    
    Pedido pedido = await getPedidoService(id: id);
    if(pedido != null){
      _pedidoController.sink.add(pedido);
      loopingStatus(id);
    }
  }

  loopingStatus(String id)async{
    print(id);
    List<HistoricoStatusPedidos> status = await getHistoricoService(id: id);
    _pedidoController.value.historicoStatusPedidos = status;
    _pedidoController.sink.add(_pedidoController.value);
      Future.delayed(Duration(seconds: 10)).then((value){
          loopingStatus(id);
      });
  }

  cancelarPedido()async{
    _loadController.sink.add(null);
    bool ok = await setExcluirPedido(id: _pedidoController.value.pedidoId.toString());
    if(ok){
      _loadController.sink.add(1);
    }else{
      _loadController.sink.add(2);
    }
  }

  receberPedido()async{
    _loadController.sink.add(null);
    bool ok = await receberPedidoService(id: _pedidoController.value.pedidoId.toString());
    if(ok){
      _loadController.sink.add(3);
    }else{
      _loadController.sink.add(4);
    }
  }

  avaliarPedido(int stars, String desc)async{
    _loadController.sink.add(null);
    bool ok = await avaliarPedidoService(id: _pedidoController.value.pedidoId.toString(), stars: stars, desc: desc);
    if(ok){
      _loadController.sink.add(9);
    }else{
      _loadController.sink.add(8);
    }
  }

  bool showAll = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pedidoController.close();
    _loadController.close();
  }
}