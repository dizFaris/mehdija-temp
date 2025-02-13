import 'package:book_beauty/models/order.dart';
import 'package:book_beauty/models/order_item.dart';
import 'package:book_beauty/providers/order_item_provider.dart';
import 'package:book_beauty/providers/order_provider.dart';
import 'package:book_beauty/providers/user_provider.dart';
import 'package:book_beauty/screens/payment_screen.dart';
import 'package:book_beauty/widgets/buy_button.dart';
import 'package:book_beauty/widgets/cart_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/main_title.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderItemProvider>(context);
    final _orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final _orderItemProvider =
        Provider.of<OrderItemProvider>(context, listen: false);

    List<OrderItem> _orderItems = provider.orderItems;

    double total = provider.totalSum;

    Future<void> goToPayment() async {
      List<OrderItem> items = [];
      print(UserProvider.globalUserId);
      Order newOrder = Order(customerId: UserProvider.globalUserId);
      print('teststsetest');
      print(newOrder.orderId);
      var response = await _orderProvider.insert(newOrder);
      print(response);
      print("     RESPONSEEEE FROM INSERTING ORDDDEEEER    ");
      print(response.orderNumber);
      for (var item in _orderItems) {
        OrderItem newItem = OrderItem(
            // orderItemId: item.orderItemId,
            orderId: response.orderId,
            quantity: item.quantity,
            productId: item.productId,
            product: item.product);
        var r = await _orderItemProvider.insert(newItem) as OrderItem;
        items.add(r);
        print("     RESPONSEEEE FROM INSERTING ORDDDEEEER  ITEM  ");
        print(r.orderItemId);
      }
      print("ORDER ITEMS LENGTH");
      print(items.length);
      for (var element in items) {
        print("**** ELEMENT order item ****");
        print(element.orderItemId);
      }
      newOrder.orderItems = items;
      newOrder.totalPrice = provider.totalSum;
      newOrder.dateTime = DateTime.now();
      newOrder.status = 'Kreirana';
      for (var element in newOrder.orderItems!) {
        print("**** NEW ORDER  order item ****");
        print(element.orderItemId);
      }

      print(newOrder.orderId);
      print(response.orderId);
      var res = await _orderProvider.update(response.orderId!, newOrder);

      Order o = res;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => PaymentScreen(order: o),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Korpa')),
      body: _orderItems.isEmpty
          ? const Center(child: Text('Vasa korpa je prazna'))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _orderItems.length,
                    itemBuilder: (context, index) {
                      final item = _orderItems[index];
                      return CartCard(product: item);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, right: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Ukupno: $total KM',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: ElevatedButton(
                    onPressed: goToPayment,
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: const Color.fromARGB(255, 34, 33, 33)),
                    child: const Text(
                      'Kupiti',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
