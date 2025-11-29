import 'package:flutter/material.dart';

class MapaDeBusqueda extends StatelessWidget {
  const MapaDeBusqueda({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('TU UBIACIÓN'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/mapa.png',
              width: 200,
              height: 200,
            )
          ]
        ),
      ),
    );
  }
}