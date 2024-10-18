import 'package:hive/hive.dart';

part 'ticket.g.dart';

@HiveType(typeId: 2)
class Ticket extends HiveObject {
  @HiveField(0)
  late DateTime date;

  @HiveField(1)
  late List<Map<String, dynamic>> items;

  @HiveField(2)
  late double totalPrice;

  Ticket({
    required this.date,
    required this.items,
    required this.totalPrice,
  });
}
