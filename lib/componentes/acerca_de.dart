import 'package:flutter/material.dart';

class AcercaDe extends StatelessWidget {
  const AcercaDe({super.key});

  final List<Map<String, String>> _equipo = const [
    {'nombre': 'Dorian Patrick Menendez Limo', 'rol': 'Líder', 'handle': 'Tu Usuario', 'tipo': 'lider'},
    {'nombre': 'Fernando Mauro Alarcon Fernandez', 'rol': 'UI/UX', 'handle': '@AlarconFernando', 'tipo': 'diseno'},
    {'nombre': 'Josué Bonifacio Chino Quispe', 'rol': 'UI/UX', 'handle': '@SHINO-DOS', 'tipo': 'diseno'},
    {'nombre': 'Sergio Alejandro Macias Quispe', 'rol': 'Dev', 'handle': '@Alee1234em', 'tipo': 'dev'},
    {'nombre': 'Jhonny Juan Silvestre Laura', 'rol': 'Dev', 'handle': '@jhonnyasuka124', 'tipo': 'dev'},
    {'nombre': 'Rafael Alejandro Mamani Chavez', 'rol': 'Dev', 'handle': '@PixelPointer', 'tipo': 'dev'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), 
      appBar: AppBar(
        title: const Text(
          'ACERCA DE', 
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1)
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            // --- HEADER: LOGO E INFO UMSA ---
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.blue.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))
                      ]
                    ),
                    child: const Icon(Icons.shield, size: 50, color: Colors.blueAccent),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'POLICÍA DE BOLSILLO',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.black87),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(20)),
                    child: const Text('GRUPO 10', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                  ),
                  const SizedBox(height: 15),
                  const Text('UMSA - Programación Móvil I (INF-245)', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                  const Text('Docente: Lic. Marcelo Aruquipa', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),

            const SizedBox(height: 30),

            _buildSectionTitle("SOBRE EL PROYECTO"),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Fase final y más compleja del proyecto. Es una solución integral que permite al ciudadano reportar incidentes detallados, adjuntando evidencia y ubicación.",
                    style: TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
                  ),
                  const SizedBox(height: 15),
                  const Divider(),
                  const SizedBox(height: 10),
                  _buildFeatureRow(Icons.description, "Reporte de Incidentes", "Formulario completo con categorización."),
                  _buildFeatureRow(Icons.camera_alt, "Integración de Hardware", "Uso de Cámara y Galería."),
                  _buildFeatureRow(Icons.map, "Navegación Compleja", "Inicio, Mapa, Historial y Perfil."),
                  _buildFeatureRow(Icons.save, "Persistencia Avanzada", "Base de datos local simulada."),
                ],
              ),
            ),

            const SizedBox(height: 30),
            _buildSectionTitle("EQUIPO DE DESARROLLO"),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: _cardDecoration(),
              child: Column(
                children: _equipo.map((miembro) {
                  return _buildMemberTile(
                    miembro['nombre']!,
                    miembro['rol']!,
                    miembro['handle']!,
                    miembro['tipo']!
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))
      ]
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12, letterSpacing: 1),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.blueAccent),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontSize: 13, height: 1.4),
                children: [
                  TextSpan(text: "$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: subtitle, style: TextStyle(color: Colors.grey[700])),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberTile(String name, String role, String github, String type) {
    Color roleColor;
    IconData roleIcon;

    switch (type) {
      case 'lider':
        roleColor = Colors.amber;
        roleIcon = Icons.emoji_events; // Corona
        break;
      case 'diseno':
        roleColor = Colors.purpleAccent;
        roleIcon = Icons.palette; // UI/UX
        break;
      default:
        roleColor = Colors.blueAccent;
        roleIcon = Icons.computer; // Dev
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: roleColor.withOpacity(0.1),
        child: Icon(roleIcon, color: roleColor, size: 20),
      ),
      title: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
      ),
      subtitle: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: roleColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4)
            ),
            child: Text(role, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: roleColor)),
          ),
          const SizedBox(width: 8),
          Text(github, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
        ],
      ),
    );
  }
}