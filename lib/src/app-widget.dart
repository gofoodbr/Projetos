import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:go_food_br/src/app-bloc.dart';
import 'package:go_food_br/src/blocs/company-screen-bloc.dart';
import 'package:go_food_br/src/blocs/filter-bloc.dart';
import 'package:go_food_br/src/blocs/item-bloc.dart';
import 'package:go_food_br/src/blocs/register-bloc.dart';
import 'package:go_food_br/src/blocs/register-endereco-bloc.dart';
import 'package:go_food_br/src/screens/carrinho-screen.dart';
import 'package:go_food_br/src/screens/cashback_screen.dart';
import 'package:go_food_br/src/screens/company-screen.dart';
import 'package:go_food_br/src/screens/cupom-screen.dart';
import 'package:go_food_br/src/screens/filter-screen.dart';
import 'package:go_food_br/src/screens/historico_pedido_screen.dart';
import 'package:go_food_br/src/screens/home-screen.dart';
import 'package:go_food_br/src/screens/list-enderecos-screen.dart';
import 'package:go_food_br/src/screens/login-screen.dart';
import 'package:go_food_br/src/screens/off-geolocator.dart';
import 'package:go_food_br/src/screens/off_internet-page.dart';
import 'package:go_food_br/src/screens/payments_screen.dart';
import 'package:go_food_br/src/screens/pedidos_screen.dart';
import 'package:go_food_br/src/screens/product-screen.dart';
import 'package:go_food_br/src/screens/profile-screen.dart';
import 'package:go_food_br/src/screens/register-card-screen.dart';
import 'package:go_food_br/src/screens/register-endereco-screen.dart';
import 'package:go_food_br/src/screens/register-screen.dart';
import 'package:go_food_br/src/screens/splash-screen.dart';
import 'package:go_food_br/src/screens/troco_screen.dart';

import 'app-settings.dart';
import 'blocs/historico-pedido-bloc.dart';
import 'blocs/pedidos_bloc.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [
        Bloc((i) => AppBloc()),
        Bloc((i) => RegisterBloc()),
        Bloc((i) => RegisterEnderecoBloc()),
        Bloc((i) => FilterBloc()),
        Bloc((i) => CompanyScreenBloc()),
        Bloc((i) => ItemBloc()),
        Bloc((i)=> PedidosBloc()),
        Bloc((i)=> HistoricoBloc()),
        Bloc((i)=> RegisterCardScreen())
      ],
      child: MaterialApp(
        color: Colors.blue,
        title: appName,
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          "/": (context) => SplashScreen(),
          "/login": (context) => LoginScreen(),
          "/home": (context) => HomeScreen(),
          "/net": (context) => OffInternetPage(),
          "/register": (context) => RegisterScreen(),
          "/register_endereco": (context) => RegisterEnderecoScreen(),
          "/geolocator_off": (context) => OffGeolocatoPage(),
          "/list_enderecos": (context) => ListEnderecosScreen(),
          "/filter_screen": (context) => FilterScreen(),
          "/company_screen": (context) => CompanyScreen(),
          "/item_screen": (context) => ProductScreen(),
          "/carrinho_screen": (context) => CarrinhoScreen(),
          "/payments_screen": (context) => PaymentScreen(),
          "/cupom_screen": (context) => CupomScreen(),
          "/profile_screen": (context) => ProfileScreen(),
          "/cashback_screen": (context) => CashBackScreen(),
          "/troco_screen": (context) => TrocoScreen(),
          "/pedidos_screen": (context)=> PedidosScreen(),
          "/historico_pedido": (context) => HistoricoPedido(),
          "/Register_card_screen": (context) => RegisterCardScreen()
        },
      ),
    );
  }
}