import 'package:flutter_accordion_menu/data/menu_item_data.dart';

class Data {


  List<MenuItemData> menuItems = [
    MenuItemData(title: 'Men', subtitle: 'Clothing, shoes & accessories', iconPath: 'assets/img/icon_men.png'),
    MenuItemData(title: 'Women', subtitle: 'Clothing, shoes & accessories', iconPath: 'assets/img/icon_women.png'),
    MenuItemData(title: 'Wishlist', subtitle: 'You have 3 lists', iconPath: 'assets/img/icon_wishlist.png'),
    MenuItemData(title: 'Cart', subtitle: 'Amount \$224.88', iconPath: 'assets/img/icon_cart.png'),
    MenuItemData(title: 'Your orders', subtitle: '', iconPath: 'assets/img/icon_orders.png'),
  ];


  static final Data _instance = Data._internal();
  factory Data() {
    return _instance;
  }
  Data._internal();
}
