import 'package:flutter/material.dart';
import 'package:flutter_hivepos/models/product.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_hivepos/models/ticket.dart';


class Venta extends StatefulWidget {
  const Venta({super.key});

  @override
  _VentaState createState() => _VentaState();
}

class _VentaState extends State<Venta> {
  late Box<Product> productBox;
  late Box<Ticket> ticketBox;
  List<Map<String, dynamic>> selectedProducts = [];
  double totalPrice = 0.0;
  Product? selectedProduct;

  @override
  void initState() {
    super.initState();
    productBox = Hive.box<Product>('product');
    ticketBox = Hive.box<Ticket>('tickets');
  }

  void addProductToSale(Product product) {
    setState(() {
      final existingProduct = selectedProducts.firstWhere(
        (element) => element['product'].name == product.name,
        orElse: () => {},
      );

      if (existingProduct.isNotEmpty) {
        existingProduct['quantity'] += 1;
        existingProduct['totalPrice'] += product.price;
      } else {
        selectedProducts.add({
          'product': product,
          'quantity': 1,
          'totalPrice': product.price,
        });
      }

      totalPrice += product.price;
    });
  }

  void removeProductFromSale(Product product) {
    setState(() {
      final existingProduct = selectedProducts.firstWhere(
        (element) => element['product'].name == product.name,
      );

      totalPrice -= existingProduct['totalPrice'];
      selectedProducts.remove(existingProduct);
    });
  }

  void completeSale() {
    final ticket = Ticket(
      date: DateTime.now(),
      items: selectedProducts,
      totalPrice: totalPrice,
    );

    ticketBox.add(ticket);

    for (var item in selectedProducts) {
      final product = item['product'] as Product;
      final quantity = item['quantity'] as int;

      product.quantity -= quantity;
      product.save();
    }

    setState(() {
      selectedProducts.clear();
      totalPrice = 0.0;
      selectedProduct = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Venta completada y ticket generado')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bienvenido Usuario 1',
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<Product>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Buscar producto',
                    ),
                    items: productBox.values
                        .where((product) => product.isAvailable)
                        .map((product) {
                      return DropdownMenuItem<Product>(
                        value: product,
                        child: Text(product.name),
                      );
                    }).toList(),
                    onChanged: (product) {
                      setState(() {
                        selectedProduct = product;
                      });
                    },
                    value: selectedProduct,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: selectedProduct != null
                      ? () => addProductToSale(selectedProduct!)
                      : null,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: selectedProducts.length,
                itemBuilder: (context, index) {
                  final product = selectedProducts[index]['product'] as Product;
                  final quantity = selectedProducts[index]['quantity'] as int;
                  final totalPrice = selectedProducts[index]['totalPrice'] as double;

                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text('Cantidad: $quantity, Precio: \$${totalPrice.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => removeProductFromSale(product),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Precio Total: \$${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: selectedProducts.isNotEmpty ? completeSale : null,
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Realizar Compra'),
            ),
          ],
        ),
      ),
    );
  }
}
