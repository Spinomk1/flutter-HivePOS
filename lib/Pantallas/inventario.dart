import 'package:flutter/material.dart';
import 'package:flutter_hivepos/models/product.dart';
import 'package:hive_flutter/hive_flutter.dart';


class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  late Box<Product> productBox;

  @override
  void initState() {
    super.initState();
    productBox = Hive.box<Product>('product');
  }

  void _showProductDialog({Product? product}) {
    final nameController = TextEditingController(text: product?.name);
    final quantityController = TextEditingController(text: product?.quantity.toString());
    final priceController = TextEditingController(text: product?.price.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(product == null ? 'Agregar Producto' : 'Editar Producto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text;
                final quantity = int.tryParse(quantityController.text) ?? 0;
                final price = double.tryParse(priceController.text) ?? 0.0;

                if (product == null) {
                  final newProduct = Product(name: name, quantity: quantity, price: price);
                  productBox.add(newProduct);
                } else {
                  product.name = name;
                  product.quantity = quantity;
                  product.price = price;
                  product.save();
                }

                Navigator.of(context).pop();
                setState(() {}); // Update the state to refresh the UI
              },
              child: Text(product == null ? 'Agregar' : 'Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteProduct(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: const Text('¿Estás seguro de que quieres eliminar este producto?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                setState(() {
                  product.delete();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Color getContainerColor(int quantity) {
    if (quantity <= 5) {
      return Colors.red;
    } else if (quantity <= 15) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inventario',
          textAlign: TextAlign.center,
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: productBox.listenable(),
        builder: (context, Box<Product> box, _) {
          if (box.values.isEmpty) {
            return const Center(child: Text('No hay productos disponibles.'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final product = box.getAt(index);

              return GestureDetector(
                onTap: () {
                  _showProductDialog(product: product);
                },
                child: Container(
                  height: 90,
                  width: double.infinity,
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  color: getContainerColor(product!.quantity),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        child: Icon(Icons.phone_android_outlined),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(fontSize: 25, color: Colors.black),
                          ),
                          Row(
                            children: [
                              Text(
                                "Cantidad: ${product.quantity}",
                                style: const TextStyle(fontSize: 16, color: Colors.black),
                              ),
                              const SizedBox(width: 15),
                              Text(
                                "Precio: \$${product.price}",
                                style: const TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showProductDialog(product: product);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _confirmDeleteProduct(product);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showProductDialog(),
      ),
    );
  }
}
