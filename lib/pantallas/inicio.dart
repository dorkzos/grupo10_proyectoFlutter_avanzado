import 'package:flutter/material.dart';
import 'package:proyectofinal_grupo10_avansado/pantallas/reportar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:proyectofinal_grupo10_avansado/funciones/datos.dart';
import 'package:proyectofinal_grupo10_avansado/funciones/calcular_tiempo.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});
  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {

  // --- FUNCIÓN PARA LLAMADAS ---
  Future<void> _llamarDeEmergencia() async {
    const String phoneNumber = '110'; 
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se puede abrir la aplicación de llamadas.')),
      );
    }
  }

  // --- NUEVAS FUNCIONES PARA EL DIALOG ---
  void _mostrarDetalleReporte(BuildContext context, Map<String, String> reporte) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.red),
              const SizedBox(width: 10),
              Expanded(child: Text((reporte['tipo'] ?? 'REPORTE').toUpperCase(), style: const TextStyle(fontSize: 18))),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _crearLineaDetalle("Usuario:", reporte['anonimo'] == 'Sí' ? 'Anónimo' : reporte['usuario']),
                _crearLineaDetalle("Fecha:", reporte['dia']),
                _crearLineaDetalle("Hora:", reporte['hora']),
                _crearLineaDetalle("Ubicación:", reporte['ubicacion']),
                const Divider(),
                const Text(
                  "Descripción:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(reporte['reporte'] ?? 'Sin descripción'),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 5),
                      Expanded(
                        child: Image.asset('assets/images/${reporte['evidencia']}', fit: BoxFit.cover)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CERRAR', style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _crearLineaDetalle(String etiqueta, String? valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 14),
          children: [
            TextSpan(text: "$etiqueta ", style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: valor ?? 'No especificado'),
          ],
        ),
      ),
    );
  }
  // -------------------------------------

  @override
  Widget build(BuildContext context) {

    /// Mostrar Solo los Datos del dia de hoy
    final now = DateTime.now();
    String dia = now.day.toString().padLeft(2, '0');
    String mes = now.month.toString().padLeft(2, '0');
    String anio = now.year.toString();
    String fechaHoy = "$dia/$mes/$anio"; 

    List<Map<String, String>> reportesDeHoy = historialReportes.where((elemento) {
      return elemento['dia'] == fechaHoy;
    }).toList().reversed.toList(); 

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
              'Accesos Rápidos',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // BOTÓN 1: LLAMADA EMERGENCIA
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    fixedSize: const Size(140, 120), 
                    elevation: 4,
                  ),
                  onPressed: _llamarDeEmergencia,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente
                    children: const [
                      Icon(Icons.phone_in_talk, size: 40, color: Colors.white), // Icono grande
                      SizedBox(height: 10), // Espacio entre icono y texto
                      Text(
                        'Llamada de\nEmergencias', 
                        textAlign: TextAlign.center, // Centra el texto si tiene 2 líneas
                        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                // BOTÓN 2: NUEVO REPORTE (Estilo consistente)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    fixedSize: const Size(140, 120),
                    elevation: 4,
                  ),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HacerReporte()),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add_location_alt, size: 40, color: Colors.white),
                      SizedBox(height: 10),
                      Text(
                        'Realizar Nuevo\nReporte', 
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: const Text(
              'Últimos Reportes Hoy',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ),

          /// LISTA DE NOTIFICACIONES DE REPORTES
          Expanded(
            flex: 2,
            child: reportesDeHoy.isEmpty 
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.check_circle_outline, size: 60, color: Colors.green),
                    SizedBox(height: 10),
                    Text("No hay reportes hoy", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              )
            : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: reportesDeHoy.length,
              itemBuilder: (context, index) {
                final notificacion = reportesDeHoy[index];
                
                String tipo = (notificacion['tipo'] ?? 'Desconocido').toUpperCase();
                String reporte = notificacion['reporte'] ?? '';
                String usuario = notificacion['usuario'] ?? 'Anónimo';
                if (notificacion['anonimo'] == 'Sí') {
                  usuario = 'Reporte Anónimo';
                }
                String fecha = notificacion['dia'] ?? '';
                String hora = notificacion['hora'] ?? '';

                return Card(
                  elevation: 2, 
                  clipBehavior: Clip.hardEdge, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.black12), 
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                  
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      _mostrarDetalleReporte(context, notificacion);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          Expanded( 
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tipo,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                const SizedBox(height: 5), 
                                Text(
                                  reporte, 
                                  maxLines: 2, 
                                  overflow: TextOverflow.ellipsis, 
                                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 10), 
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                usuario,
                                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                calcularTiempoTranscurrido(fecha, hora), 
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}