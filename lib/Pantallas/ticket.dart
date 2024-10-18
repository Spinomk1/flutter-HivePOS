import 'package:flutter/material.dart';
import 'package:flutter_hivepos/models/ticket.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TicketsScreen extends StatelessWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tickets Generados'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Ticket>('tickets').listenable(),
        builder: (context, Box<Ticket> box, _) {
          final tickets = box.values.toList();

          if (tickets.isEmpty) {
            return const Center(child: Text('No hay tickets generados'));
          }

          return ListView.builder(
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];

              return ListTile(
                title: Text('Ticket #${index + 1} - Total: \$${ticket.totalPrice.toStringAsFixed(2)}'),
                subtitle: Text('Fecha: ${ticket.date.toLocal()}'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Detalle del Ticket'),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: ListView.builder(
                            itemCount: ticket.items.length,
                            itemBuilder: (context, itemIndex) {
                              final item = ticket.items[itemIndex];
                              return ListTile(
                                title: Text(item['product'].name),
                                subtitle: Text('Cantidad: ${item['quantity']}, Precio: \$${item['totalPrice'].toStringAsFixed(2)}'),
                              );
                            },
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cerrar'),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
