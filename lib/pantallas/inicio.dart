import 'dart:io'; // <--- IMPORTANTE PARA LEER LAS FOTOS DEL CELULAR
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se puede abrir la aplicación de llamadas.')),
        );
      }
    }
  }

  // --- DIALOGO GRANDE CORREGIDO (Muestra Assets o Fotos Locales) ---
  void _mostrarDetalleReporte(BuildContext context, Map<String, String> reporte) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 10,
          backgroundColor: Colors.white,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Cabecera Sólida
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 30),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          (reporte['tipo'] ?? 'DETALLE REPORTE').toUpperCase(),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                ),
                
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _itemDetalle(Icons.person, "Usuario", reporte['anonimo'] == 'Sí' ? 'Anónimo' : reporte['usuario']),
                        const Divider(height: 25),
                        _itemDetalle(Icons.calendar_today, "Fecha", reporte['dia']),
                        const Divider(height: 25),
                        _itemDetalle(Icons.access_time, "Hora", reporte['hora']),
                        const Divider(height: 25),
                        _itemDetalle(Icons.location_on, "Ubicación", reporte['ubicacion']),
                        const Divider(height: 25),
                        
                        const Text("Descripción:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                        const SizedBox(height: 8),
                        Text(reporte['reporte'] ?? 'Sin descripción', style: const TextStyle(fontSize: 16)),
                        
                        const SizedBox(height: 20),
                        
                        // --- CONTENEDOR DE IMAGEN CORREGIDO ---
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey.shade300),
                            image: DecorationImage(
                              // LÓGICA: Si es local usamos FileImage, si no AssetImage
                              image: reporte['es_local'] == 'si' && reporte['evidencia'] != ''
                                  ? FileImage(File(reporte['evidencia']!)) as ImageProvider
                                  : AssetImage('assets/images/${reporte['evidencia'] ?? 'placeholder.png'}'),
                              fit: BoxFit.cover,
                              onError: (exception, stackTrace) {
                                // Evita crash si la imagen no existe
                              },
                            )
                          ),
                          child: (reporte['evidencia'] == null || reporte['evidencia'] == '')
                            ? const Center(child: Text("Sin evidencia visual"))
                            : null,
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 12)
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('CERRAR', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _itemDetalle(IconData icon, String titulo, String? valor) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blueGrey),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            Text(valor ?? 'No especificado', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos fecha de hoy
    final now = DateTime.now();
    String dia = now.day.toString().padLeft(2, '0');
    String mes = now.month.toString().padLeft(2, '0');
    String anio = now.year.toString();
    String fechaHoy = "$dia/$mes/$anio"; 

    // Filtramos la lista global
    List<Map<String, String>> reportesDeHoy = historialReportes.where((elemento) {
      return elemento['dia'] == fechaHoy;
    }).toList().reversed.toList(); 

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'INICIO', 
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1) 
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: const Text(
              'Accesos Rápidos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: _botonAccionSolido(
                    titulo: "Emergencia",
                    subtitulo: "Llamada 110",
                    icono: Icons.phone_in_talk,
                    colorFondo: Colors.redAccent.shade700, 
                    onTap: _llamarDeEmergencia
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: _botonAccionSolido(
                    titulo: "Reportar",
                    subtitulo: "Incidente",
                    icono: Icons.add_location_alt_outlined,
                    colorFondo: Colors.amber.shade700, 
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HacerReporte()),
                      ).then((_) {
                        // ESTO ES CLAVE: Al volver, actualizamos el estado para ver el nuevo reporte
                        setState(() {});
                      });
                    }
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Reportes de Hoy',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Text(fechaHoy, style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold, fontSize: 13)),
                )
              ],
            ),
          ),
          
          const SizedBox(height: 10),

          Expanded(
            child: reportesDeHoy.isEmpty 
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shield_outlined, size: 70, color: Colors.grey[300]),
                    const SizedBox(height: 15),
                    Text("Todo tranquilo por ahora", style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: reportesDeHoy.length,
                itemBuilder: (context, index) {
                  final notificacion = reportesDeHoy[index];
                  
                  String tipo = (notificacion['tipo'] ?? 'Desconocido').toUpperCase();
                  String reporte = notificacion['reporte'] ?? '';
                  String usuario = notificacion['usuario'] ?? 'Anónimo';
                  if (notificacion['anonimo'] == 'Sí') usuario = 'Anónimo';
                  String fecha = notificacion['dia'] ?? '';
                  String hora = notificacion['hora'] ?? '';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ]
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () => _mostrarDetalleReporte(context, notificacion),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              // Icono Circular
                              Container(
                                height: 50, width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.notifications_active, color: Colors.amber),
                              ),
                              const SizedBox(width: 15),
                              
                              // Texto Central
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tipo,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      reporte,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.person, size: 12, color: Colors.grey[400]),
                                        const SizedBox(width: 4),
                                        Text(usuario, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                                      ],
                                    )
                                  ],
                                ),
                              ),

                              // Tiempo
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    hora,
                                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green[50],
                                      borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: Text(
                                      calcularTiempoTranscurrido(fecha, hora),
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green[700]),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
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

  Widget _botonAccionSolido({
    required String titulo, 
    required String subtitulo, 
    required IconData icono, 
    required Color colorFondo, 
    required VoidCallback onTap
  }) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: colorFondo, 
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorFondo.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ]
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column( 
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle
                  ),
                  child: Icon(icono, color: Colors.white, size: 24),
                ),
                const Spacer(),
                Text(
                  titulo,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  subtitulo,
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}