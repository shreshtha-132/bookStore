import 'package:flutter/material.dart';

void main() {
  runApp(Cart());
}

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" CART "),
      ),
      body: Center(
        child: Text("this is where books will be shown in a listView"),
      ),
    );
  }
}
