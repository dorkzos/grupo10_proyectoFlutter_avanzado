import 'package:flutter/material.dart';
class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}
class _PerfilState extends State<Perfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CONFIGURAR PERFIL'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Stack(
                children: <Widget>[
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 70, color: Colors.white),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Icon(Icons.edit, color: Colors.red[400], size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'NOMBRE Y APELLIDOS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    TextField(
                      controller: TextEditingController(text: 'JUAN PEREZ'),
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.edit, color: Colors.red[400], size: 18),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                        border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'TIPO DE SANGRE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    TextField(
                      controller: TextEditingController(text: 'O POSITIVO'),
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.edit, color: Colors.red[400], size: 18),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                        border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      ),
                    ),
                    const SizedBox(height: 15),

                    const Text(
                      'DIRECCION',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    TextField(
                      controller: TextEditingController(text: 'CALLE X AVENIDA X NRO 123'),
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.edit, color: Colors.red[400], size: 18),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                        border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'CONTACTO DE EMERGENCIA',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    TextField(
                      controller: TextEditingController(text: '789678754'),
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.edit, color: Colors.red[400], size: 18),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                        border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              'GENERAL',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.help_outline),
              label: const Text('AYUDA Y SOPORTE'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.black, width: 1.5),
                ),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
              ),
            ),
            const SizedBox(height: 15),
            
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.info_outline),
              label: const Text('ACERCA DE'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.black, width: 1.5),
                ),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
