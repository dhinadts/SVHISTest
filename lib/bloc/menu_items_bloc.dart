import '../model/menu_item.dart';
import '../repo/menu_items_repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';

class MenuItemsBloc extends Bloc {
  MenuItems menuItem;

  final _repository = MenuItemsRepository();

  final menuItemsFetcher = PublishSubject<MenuItems>();

  MenuItemsBloc(BuildContext context) : super(context);

  @override
  void init() {}

  getMenuItems() async {
    menuItem = await _repository.getMenuItems();
    menuItemsFetcher.sink.add(menuItem);
  }

  @override
  void dispose() {
    menuItemsFetcher.close();
  }
}
