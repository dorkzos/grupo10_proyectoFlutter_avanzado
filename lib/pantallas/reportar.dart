import 'package:flutter/material.dart';

class HacerReporte extends StatefulWidget {
  const HacerReporte({super.key});

  @override
  State<HacerReporte> createState() => _HacerReporteState();
}

class _HacerReporteState extends State<HacerReporte> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('REPORTAR INCIDENTE',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: const Text(
              'TIPO DE INCIDENTE',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          ///
          ///  TIPO DEL ACIDENTE
          ///
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {}, 
                    child: const Text('ROBO', style: TextStyle(color: Colors.white))),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {}, 
                    child: const Text('PELEA', style: TextStyle(color: Colors.white))),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {}, 
                    child: const Text('INCENDIO', style: TextStyle(color: Colors.white))),
                ),
              ),
            ],
          ),


          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {}, 
                    child: const Text('ACCIDENTE', style: TextStyle(color: Colors.white))),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {}, 
                    child: const Text('ACOSO', style: TextStyle(color: Colors.white))),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {}, 
                    child: const Text('OTRO', style: TextStyle(color: Colors.white))),
                ),
              ),
            ],
          ),

          ///
          ///  UBICACIÓN DEL INCIDENTE
          ///
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: const Text(
              'UBICACIÓN DEL INCIDENTE',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset('assets/images/mapa_incidente.png',
              width: 700,
            ),
          ),

          ///
          ///  DETALLES Y EVIDENCIAS
          ///
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: const Text(
              'DETALLES Y EVIDENCIAS',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Describe los detalles del incidente aquí...',
              ),
            ),
          ),


          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {}, 
              child: const Text('ENVIAR REPORTE', style: TextStyle(color: Colors.white))),
          ),

        ],
      ),
    );
  }
}