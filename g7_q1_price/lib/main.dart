import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CartPage(),
    ));

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  static const double unitPrice = 25.0;
  final ValueNotifier<int> quantity = ValueNotifier<int>(1);

  @override
  void dispose() {
    quantity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('WHOLE SCREEN built'); // prints only once
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Product price: \$25', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (quantity.value > 1) quantity.value--;
                  },
                ),
                ValueListenableBuilder<int>(
                  valueListenable: quantity,
                  builder: (context, qty, _) => Text('$qty',
                      style: const TextStyle(fontSize: 24)),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => quantity.value++,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder<int>(
              valueListenable: quantity,
              builder: (context, qty, _) {
                debugPrint('Only the TOTAL rebuilt');
                return Text('Total: \$${(qty * unitPrice).toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold));
              },
            ),
          ],
        ),
      ),
    );
  }
}
