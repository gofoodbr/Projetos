import 'dart:typed_data';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_food_br/src/model/pedido.dart';
import 'package:go_food_br/src/services/pedidos_service.dart';
import 'package:rxdart/rxdart.dart';

import '../app-settings.dart';

class HistoricoBloc extends BlocBase {
  final _pedidoController = BehaviorSubject<Pedido>();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  Function(Pedido) get pedidoIn => _pedidoController.sink.add;
  Stream<Pedido> get pedidoOut => _pedidoController.stream;

  final _loadController = BehaviorSubject<int>.seeded(100);
  Function(int) get loadIn => _loadController.sink.add;
  Stream<int> get loadOut => _loadController.stream;

  bool looping = true;

  watchPedido(String id) async {
    Pedido pedido = await getPedidoService(id: id);
    if (pedido != null) {
      _pedidoController.sink.add(pedido);
      loopingStatus(id);
    }
  }

  showNotification(String mensagem) async {
    var vibrationPattern = new Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 500;
    vibrationPattern[2] = 500;

    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
    // of the `IOSFlutterLocalNotificationsPlugin` class
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }
    });

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '1', 'Gofood', 'Gofood Delivery',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker',
        vibrationPattern: vibrationPattern,
        playSound: true,
        color: primaryColor);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var notificationAppLaunchDetails = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        1, 'Gofood', mensagem, notificationAppLaunchDetails,
        payload: 'Default_Sound');
  }

  sendNotificationPedido(Pedido pedido) {
    HistoricoStatusPedidos status = pedido.historicoStatusPedidos.last;
    int statusId = int.parse(status.statusPedidoId);
    if (pedido.statusPedidoId != statusId) {
      pedido.statusPedidoId = statusId;
      _pedidoController.sink.add(pedido);
      DateTime dateTime = DateTime.parse(status.dataHistoricoPedido);
      String hour =
          dateTime.hour < 10 ? "0${dateTime.hour}" : dateTime.hour.toString();
      String min = dateTime.minute < 10
          ? "0${dateTime.minute}"
          : dateTime.minute.toString();
      if (statusId == 5 || statusId == 1 || statusId == 2) {
        showNotification("${status.descricao} $hour:$min");
      } else if (int.parse(status.statusPedidoId) == 3) {
        showNotification("Pedido Cancelado");
      } else if (int.parse(status.statusPedidoId) == 6) {
        showNotification(" Pedido recebido ${"$hour:$min"}");
      }
    }
  }

  loopingStatus(String id) async {
    print(id);
    List<HistoricoStatusPedidos> status = await getHistoricoService(id: id);
    _pedidoController.value.historicoStatusPedidos = status;
    _pedidoController.sink.add(_pedidoController.value);
    sendNotificationPedido(_pedidoController.value);
    Future.delayed(Duration(seconds: 30)).then((value) {
      loopingStatus(id);
    });
  }

  cancelarPedido() async {
    _loadController.sink.add(null);
    bool ok =
        await setExcluirPedido(id: _pedidoController.value.pedidoId.toString());
    if (ok) {
      _loadController.sink.add(1);
    } else {
      _loadController.sink.add(2);
    }
  }

  receberPedido() async {
    _loadController.sink.add(null);
    bool ok = await receberPedidoService(
        id: _pedidoController.value.pedidoId.toString());
    if (ok) {
      _loadController.sink.add(3);
    } else {
      _loadController.sink.add(4);
    }
  }

  avaliarPedido(int stars, String desc) async {
    _loadController.sink.add(null);
    bool ok = await avaliarPedidoService(
        id: _pedidoController.value.pedidoId.toString(),
        stars: stars,
        desc: desc);
    if (ok) {
      _loadController.sink.add(9);
    } else {
      _loadController.sink.add(8);
    }
  }

  bool showAll = false;

  @override
  void dispose() {
    super.dispose();
    _pedidoController.close();
    _loadController.close();
  }
}
