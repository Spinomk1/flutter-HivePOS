import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 1)
class Product extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late int quantity;

  @HiveField(2)
  late double price;

  @HiveField(3)
  late bool isAvailable;  // Nuevo campo para disponibilidad

  Product({
    required this.name,
    required this.quantity,
    required this.price,
    this.isAvailable = true, // Por defecto, el producto está disponible
  });
}
