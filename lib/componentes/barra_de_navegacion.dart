import 'package:flutter/material.dart';
import 'package:proyectofinal_grupo10_avansado/pantallas/inicio.dart';
import 'package:proyectofinal_grupo10_avansado/pantallas/mapa.dart';
import 'package:proyectofinal_grupo10_avansado/pantallas/perfil.dart';

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NavigationExample()
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
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.grey.shade400,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          // Inicio
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Inicio',
          ),

          // Mapa
          NavigationDestination(
            selectedIcon: Icon(Icons.map),
            icon: Icon(Icons.map_outlined),
            label: 'Mapa',
          ),

          // Reportes
          NavigationDestination(
            selectedIcon: Icon(Icons.article),
            icon: Icon(Icons.article_outlined),
            label: 'Reportes',
          ),

          // Perfil
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
      ),

      ///
      /// CUERPO DE LA BARRA DE NAVEGACIÓN
      ///
      body: <Widget>[

        /// PAGINA DE INICIO
        Inicio(),

        /// PAGINA DE MAPA
        MapaDeBusqueda(),

        /// Historial de reportes
        const Center(
          child: Text('REPORTES'),
        ),

        // PERFIL PAGINA
         const Perfil(),
      ][currentPageIndex],
    );
  }
}
