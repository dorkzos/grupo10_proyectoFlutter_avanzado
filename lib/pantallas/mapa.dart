import 'package:flutter/material.dart';

class MapaDeBusqueda extends StatelessWidget {
  const MapaDeBusqueda({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'TU UBICACIÓN',
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black, fontSize: 18),
        ),
      ),

      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/mapa.png',
              fit: BoxFit.cover, 
            ),
          ),

          Positioned(
            top: 20, 
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ]
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Buscar dirección...",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  const Icon(Icons.search, color: Colors.blueAccent),
                ],
              ),
            ),
          ),

          Positioned(
            right: 20,
            bottom: 180, 
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blueAccent.shade700,
              elevation: 4,
              onPressed: () {},
              child: const Icon(Icons.my_location),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  )
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Texto de dirección
                  const Text(
                    "Tú ubicación actual",
                    style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Universidad Mayor de San Andrés",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black87),
                  ),
                  const Text(
                    "La Paz, Bolivia",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
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