import 'package:flutter/material.dart';
import 'package:flutter_hivepos/Pantallas/menu.dart';
import 'package:flutter_hivepos/Pantallas/messageUser/updateUser.dart';
import 'package:flutter_hivepos/models/product.dart';
import 'package:flutter_hivepos/models/ticket.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/user.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(TicketAdapter());
  await Hive.openBox<User>('usuarios');
  await Hive.openBox<Product>('product');
  await Hive.openBox<Ticket>('tickets');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  late Box<User> usuariosBox;

  @override
  void initState() {
    super.initState();
    usuariosBox = Hive.box<User>('usuarios');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Usuarios disponibles',
          textAlign: TextAlign.center,
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: usuariosBox.listenable(),
        builder: (context, Box<User> box, _) {
          if (box.values.isEmpty) {
            return const Center(child: Text('No users available.'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final user = box.getAt(index);
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Menu(usuario: {
                        'nombre': user.name,
                        'esAdmin': user.isAdmin,
                      }),
                    ),
                  );
                },
                child: Container(
                  height: 90,
                  width: double.infinity,
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  color: Colors.blue,
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        child: Icon(Icons.phone_android_outlined),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user!.name,
                            style: const TextStyle(fontSize: 25, color: Colors.black),
                          ),
                          Text(
                            user.isAdmin ? 'Admin' : 'Empleado',
                            style: const TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateUserScreen(user: user),
                            ),
                          );
                        },
                        child: const Icon(Icons.edit),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirmación'),
                                content: const Text('¿Estás seguro de que quieres eliminar este usuario?'),
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
                                        user.delete();
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Icon(FontAwesomeIcons.trash),
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
        onPressed: () => _showUserDialog(context),
      ),
    );
  }

  void _showUserDialog(BuildContext context, {User? user}) {
    final nameController = TextEditingController(text: user?.name);
    bool isAdmin = user?.isAdmin ?? false;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(user == null ? 'Add User' : 'Edit User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              Row(
                children: [
                  const Text('Is Admin'),
                  Checkbox(
                    value: isAdmin,
                    onChanged: (value) {
                      setState(() {
                        isAdmin = value!;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text;

                if (user == null) {
                  final newUser = User(name: name, isAdmin: isAdmin);
                  usuariosBox.add(newUser);
                } else {
                  user.name = name;
                  user.isAdmin = isAdmin;
                  user.save();
                }

                Navigator.of(context).pop();
              },
              child: Text(user == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );
  }
}
