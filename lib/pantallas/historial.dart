import 'package:flutter/material.dart';
import 'package:proyectofinal_grupo10_avansado/funciones/calcular_tiempo.dart';
import 'package:proyectofinal_grupo10_avansado/funciones/datos.dart';

class HistorialDeReportes extends StatefulWidget {
  const HistorialDeReportes({super.key});

  @override
  State<HistorialDeReportes> createState() => _HistorialDeReportesState();
}

class _HistorialDeReportesState extends State<HistorialDeReportes> {
  
  late List<Map<String, String>> listaActualizada = historialReportes.reversed.toList();
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

  // LOGICA DE FILTROS
  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        selected: isSelected,
        onSelected: (bool selected) {
          // Aquí iría la lógica de filtro
        },
        backgroundColor: Colors.white,
        selectedColor: Colors.blue,
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey.shade300),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], 
      appBar: AppBar(
        title: const Text('HISTORIAL DE REPORTES', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          
          // --- SECCIÓN SUPERIOR: BUSCADOR Y FILTROS ---
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100], // Un gris muy suave para el input
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search_rounded, color: Colors.blueGrey),
                              hintText: 'Buscar reportes...',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4), 
                      
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {},
                        child: const Icon(Icons.search, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Todos', true),
                      _buildFilterChip('Robo', false),
                      _buildFilterChip('Accidente', false),
                      _buildFilterChip('Vandalismo', false),
                      _buildFilterChip('Incendio', false),
                      _buildFilterChip('Pelea', false),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 2,
            child: listaActualizada.isEmpty 
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.folder_open, size: 60, color: Colors.grey),
                    SizedBox(height: 10),
                    Text("No hay historial disponible", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              )
            : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: listaActualizada.length,
              itemBuilder: (context, index) {
                final notificacion = listaActualizada[index];
                
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
      )
    );
  }
}