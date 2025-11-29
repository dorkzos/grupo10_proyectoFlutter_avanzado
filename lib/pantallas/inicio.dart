import 'package:flutter/material.dart';
import 'package:proyectofinal_grupo10_avansado/pantallas/reportar.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('INICIO', style: TextStyle(fontWeight: FontWeight.bold) ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: const Text(
              'ACCESO RAPIDO',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {},
                  child: const 
                    Text('Llamada de Emergencias',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: (){
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HacerReporte(),
                    ),
                  );
                  },
                  child: const 
                    Text('Realizar Nuevo Reporte', 
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: const Text(
              'ÚLTIMOS REPORTES DEL DÍA',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),


          Expanded(
            child: ListView(
              children: const [
                ListTile(
                  leading: Icon(Icons.report, color: Colors.red),
                  title: Text('Robo en la calle 123'),
                  subtitle: Text('Reportado hace 2 horas'),
                ),
              ],
            ),
          ),


        ],
      ),
    );
  }
}