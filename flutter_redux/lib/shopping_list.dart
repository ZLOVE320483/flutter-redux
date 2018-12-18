import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_demo/model/card_item.dart';
import 'package:flutter_redux_demo/shopping_item.dart';


class ShoppingList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<List<CartItem>, List<CartItem>>(
      converter: (store) => store.state,
      builder: (context, list) => new ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, i) => new ShoppingItem(item: list[i]),
      ),
    );
  }
}