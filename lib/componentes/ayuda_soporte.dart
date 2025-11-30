import 'package:flutter/material.dart';

class AyudaSoporte extends StatelessWidget {
  const AyudaSoporte({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'AYUDA Y SOPORTE', 
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
          children: [

            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ]
                    ),
                    child: const Icon(Icons.security, size: 60, color: Colors.blueAccent),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'POLICÍA DE BOLSILLO',
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.w900, 
                      color: Colors.black87,
                      letterSpacing: 0.5
                    ),
                  ),
                  Text(
                    'App Avanzada',
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.w500, 
                      color: Colors.blueGrey[400],
                      letterSpacing: 1.5
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                  "GUÍA DE FUNCIONALIDADES",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12),
                ),
              ),
            ),
            
            _buildHelpItem(
              title: "Botón de Pánico (SOS)",
              content: "En la pantalla de inicio, presiona el botón rojo para realizar una llamada inmediata al 110. Úsalo solo en casos de extrema urgencia.",
              icon: Icons.phone_in_talk,
              color: Colors.redAccent,
            ),
            
            _buildHelpItem(
              title: "Reportar Incidentes",
              content: "Puedes reportar robos, incendios o accidentes. Selecciona el tipo de incidente, añade una descripción y, si es posible, adjunta una foto como evidencia. Tu ubicación se enviará automáticamente.",
              icon: Icons.add_location_alt,
              color: Colors.blueAccent,
            ),

            _buildHelpItem(
              title: "Historial y Seguimiento",
              content: "Consulta todos los reportes que has realizado. Podrás ver el estado, la fecha, la hora y la evidencia adjunta. Puedes filtrar la lista por tipo de incidente.",
              icon: Icons.history,
              color: Colors.amber,
            ),

            _buildHelpItem(
              title: "Mapa de Ubicación",
              content: "Visualiza tu ubicación en tiempo real en el mapa interactivo. Esto ayuda a confirmar que el GPS está funcionando correctamente antes de enviar un reporte.",
              icon: Icons.map,
              color: Colors.green,
            ),

            _buildHelpItem(
              title: "Perfil de Usuario",
              content: "Mantén tus datos actualizados (Nombre, Tipo de Sangre, Contacto de Emergencia). Esta información es vital para los servicios de emergencia.",
              icon: Icons.person,
              color: Colors.purple,
            ),

            const SizedBox(height: 30),

            // --- FOOTER: CONTACTO ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.blueAccent.withOpacity(0.3))
              ),
              child: Row(
                children: [
                  const Icon(Icons.support_agent, color: Colors.blueAccent, size: 30),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("¿Necesitas más ayuda?", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                        Text("Contáctanos: soporte@policia.bo", style: TextStyle(fontSize: 12, color: Colors.black54)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpItem({
    required String title, 
    required String content, 
    required IconData icon,
    required Color color
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ]
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent), // Quita la línea divisoria por defecto
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 15),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(
                content,
                style: const TextStyle(color: Colors.grey, height: 1.5, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}