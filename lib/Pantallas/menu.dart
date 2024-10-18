import 'package:flutter/material.dart';
import 'package:flutter_hivepos/main.dart';
import 'package:flutter_hivepos/Pantallas/venta.dart';
import 'package:flutter_hivepos/Pantallas/inventario.dart';
import 'package:flutter_hivepos/Pantallas/ticket.dart';
import 'package:flutter_hivepos/Pantallas/catalogo.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Menu extends StatelessWidget {
  final Map<String, dynamic> usuario;

  const Menu({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bienvenido ${usuario['nombre']}',
          textAlign: TextAlign.center,
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            // Botón para ventas
            left: 20,
            top: 100,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Venta(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                fixedSize: const Size(175, 170),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 100,
                  ),
                  Text(
                    'Ventas',
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            // Botón para catálogo (solo admin)
            right: 20,
            top: 100,
            child: usuario['esAdmin']
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Catalogo(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      fixedSize: const Size(175, 170),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.bookOpen,
                          size: 100,
                        ),
                        Text(
                          'Catálogo',
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(), // No mostrar botón si no es admin
          ),
          Positioned(
            // Botón para usuario
            left: 20,
            top: 290,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyApp(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                fixedSize: const Size(175, 170),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_outlined,
                    size: 120,
                  ),
                  Text(
                    'Usuario',
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            // Botón para inventario (solo admin)
            right: 20,
            top: 290,
            child: usuario['esAdmin']
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Inventory(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      fixedSize: const Size(175, 170),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.boxesStacked,
                          size: 100,
                        ),
                        Text(
                          'Inventario',
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(), // No mostrar botón si no es admin
          ),
          Positioned(
            // Botón para ticket
            left: 120,
            bottom: 160,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TicketsScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                fixedSize: const Size(175, 170),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.receipt,
                    size: 100,
                  ),
                  Text(
                    'Tickets',
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
