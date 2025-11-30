import 'package:flutter/material.dart';
import 'package:proyectofinal_grupo10_avansado/pantallas/historial.dart';
import 'package:proyectofinal_grupo10_avansado/pantallas/inicio.dart';
import 'package:proyectofinal_grupo10_avansado/pantallas/mapa.dart';
import 'package:proyectofinal_grupo10_avansado/pantallas/perfil.dart';

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // --- TEMA GLOBAL PARA TODA LA APP ---
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue, // Color base para toda la app
        scaffoldBackgroundColor: const Color(0xFFF5F7FA), // El fondo gris suave que usamos en las otras pantallas
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white, // Evita cambio de color al scrollear
        ),
      ),
      home: const NavigationExample()
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        /// PAGINA DE INICIO
        const Inicio(),

        /// PAGINA DE MAPA
        const MapaDeBusqueda(),

        /// HISTORIAL
        const HistorialDeReportes(),

        /// PERFIL
        const Perfil(),
      ][currentPageIndex],

      // --- BARRA DE NAVEGACIÓN MODERNA ---
      bottomNavigationBar: Container(
        child: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          indicatorColor: Colors.blue.shade100, 
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          height: 70,
          destinations: const <Widget>[
            // Inicio
            NavigationDestination(
              selectedIcon: Icon(Icons.home, color: Colors.blueAccent), 
              icon: Icon(Icons.home_outlined, color: Colors.grey), 
              label: 'Inicio',
            ),

            // Mapa
            NavigationDestination(
              selectedIcon: Icon(Icons.map, color: Colors.blueAccent),
              icon: Icon(Icons.map_outlined, color: Colors.grey),
              label: 'Mapa',
            ),

            // Reportes
            NavigationDestination(
              selectedIcon: Icon(Icons.article, color: Colors.blueAccent),
              icon: Icon(Icons.article_outlined, color: Colors.grey),
              label: 'Reportes',
            ),

            // Perfil
            NavigationDestination(
              selectedIcon: Icon(Icons.person, color: Colors.blueAccent),
              icon: Icon(Icons.person_outline, color: Colors.grey),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}