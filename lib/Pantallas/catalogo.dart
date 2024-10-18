import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_hivepos/models/product.dart';

class Catalogo extends StatefulWidget {
  const Catalogo({super.key});

  @override
  _CatalogoState createState() => _CatalogoState();
}

class _CatalogoState extends State<Catalogo> {
  late Box<Product> productBox;

  @override
  void initState() {
    super.initState();
    productBox = Hive.box<Product>('product');
  }

  void _toggleProductAvailability(Product product) {
    setState(() {
      product.isAvailable = !product.isAvailable;
      product.save();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Productos'),
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

              return ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.shopping_cart),
                ),
                title: Text(product!.name),
                trailing: Switch(
                  value: product.isAvailable,
                  onChanged: (value) {
                    _toggleProductAvailability(product);
                  },
                ),
                subtitle: Text(product.isAvailable ? 'Disponible' : 'No disponible'),
              );
            },
          );
        },
      ),
    );
  }
}
