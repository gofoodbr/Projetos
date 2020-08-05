import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_food_br/src/model/bottom_navigator_item.dart';

import '../app-bloc.dart';

final List<BottomNavigatorItem> menus = [
  BottomNavigatorItem(
    icon: Icons.home,
    text: 'Início',
  ),
  BottomNavigatorItem(
    icon: Icons.search,
    text: 'Busca',
  ),
  BottomNavigatorItem(icon: Icons.receipt, text: 'Pedidos'),
  BottomNavigatorItem(icon: Icons.person_outline, text: 'Perfil'),
];

List<BottomNavigationBarItem> _buildBottomIcon() => menus
    .map((menu) => BottomNavigationBarItem(
          icon: Icon(menu.icon, color: Colors.black),
          title: Text(menu.text, style: TextStyle(color: Colors.black)),
        ))
    .toList();

Widget bottomNavigation(AppBloc appBloc, BuildContext context) {
  return BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      elevation: 20,
      onTap: (value) {
        if (value == 1)
          Navigator.pushReplacementNamed(context, '/filter_screen');
        if (!appBloc.convidado) {
          if (value == 3)
            Navigator.pushReplacementNamed(context, '/profile_screen');
          if (value == 2)
            Navigator.pushReplacementNamed(context, "/pedidos_screen");
        }
        if (value == 0) Navigator.pushReplacementNamed(context, "/home");
      },
      items: _buildBottomIcon());
}
