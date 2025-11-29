import 'package:flutter/material.dart';
import 'package:proyectofinal_grupo10_avansado/componentes/barra_de_navegacion.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100),
            Text('LOGIN'),
            SizedBox(height: 30),
            Text('Usuario'),
            SizedBox(
              width: 250,
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 228, 227, 227),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Text('Contraseña'),
            SizedBox(
              width: 250,
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 228, 227, 227),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text('¿Tienes un codigo de la casa?'),
            SizedBox(
              width: 250,
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 228, 227, 227),
                  labelText: 'Ingresa un código',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: 250,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NavigationBarApp(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(5),
                  ),
                ),
                child: Text('INGRESAR'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}