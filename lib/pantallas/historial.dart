import 'dart:io'; // <--- IMPORTANTE: Necesario para mostrar las fotos que tomas
import 'package:flutter/material.dart';
import 'package:proyectofinal_grupo10_avansado/funciones/calcular_tiempo.dart';
import 'package:proyectofinal_grupo10_avansado/funciones/datos.dart';

class HistorialDeReportes extends StatefulWidget {
  const HistorialDeReportes({super.key});

  @override
  State<HistorialDeReportes> createState() => _HistorialDeReportesState();
}

class _HistorialDeReportesState extends State<HistorialDeReportes> {
  String _filtroSeleccionado = 'Todos';
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, String>> _obtenerListaFiltrada() {
    List<Map<String, String>> lista = historialReportes.reversed.toList();

    if (_filtroSeleccionado != 'Todos') {
      lista = lista.where((item) => 
        (item['tipo'] ?? '').toUpperCase() == _filtroSeleccionado.toUpperCase()
      ).toList();
    }

    String busqueda = _searchController.text.toLowerCase();
    if (busqueda.isNotEmpty) {
      lista = lista.where((item) => 
        (item['reporte'] ?? '').toLowerCase().contains(busqueda) ||
        (item['tipo'] ?? '').toLowerCase().contains(busqueda)
      ).toList();
    }

    return lista;
  }

  // --- DIALOGO MODERNO CORREGIDO (Soporta Fotos Locales) ---
  void _mostrarDetalleReporte(BuildContext context, Map<String, String> reporte) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
          backgroundColor: Colors.white,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Cabecera
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                    color: _getColorPorTipo(reporte['tipo']).withOpacity(0.1),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      Icon(_getIconoPorTipo(reporte['tipo']), color: _getColorPorTipo(reporte['tipo']), size: 28),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          (reporte['tipo'] ?? 'DETALLE').toUpperCase(),
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _getColorPorTipo(reporte['tipo'])),
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
                        
                        const Text("Descripción:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                        const SizedBox(height: 8),
                        Text(reporte['reporte'] ?? 'Sin descripción', style: const TextStyle(fontSize: 16, color: Colors.black54)),
                        
                        const SizedBox(height: 20),
                        
                        // --- IMAGEN CORREGIDA ---
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
                              onError: (exception, stackTrace) {},
                            )
                          ),
                          child: (reporte['evidencia'] == null || reporte['evidencia'] == '')
                            ? const Center(child: Text("Sin evidencia"))
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
                        backgroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 15)
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('CERRAR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.bold)),
            Text(valor ?? '---', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
          ],
        )
      ],
    );
  }

  // --- UI HELPERS ---
  Color _getColorPorTipo(String? tipo) {
    switch ((tipo ?? '').toUpperCase()) {
      case 'ROBO': return Colors.red;
      case 'INCENDIO': return Colors.orange;
      case 'ACCIDENTE': return Colors.blue;
      case 'PELEA': return Colors.purple;
      case 'VANDALISMO': return Colors.brown;
      default: return Colors.blueGrey;
    }
  }

  IconData _getIconoPorTipo(String? tipo) {
    switch ((tipo ?? '').toUpperCase()) {
      case 'ROBO': return Icons.warning_amber_rounded;
      case 'INCENDIO': return Icons.local_fire_department;
      case 'ACCIDENTE': return Icons.car_crash;
      case 'PELEA': return Icons.sports_mma;
      case 'VANDALISMO': return Icons.broken_image;
      default: return Icons.info;
    }
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = _filtroSeleccionado == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            _filtroSeleccionado = label;
          });
        },
        selectedColor: Colors.black,
        backgroundColor: Colors.white,
        checkmarkColor: Colors.white, // Color del check blanco
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey.shade300)
        ),
        elevation: 0,
        pressElevation: 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    final listaMostrar = _obtenerListaFiltrada();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), 
      appBar: AppBar(
        title: const Text('HISTORIAL', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[200], height: 1),
        ),
      ),
      body: Column(
        children: [
          
          // --- SECCIÓN SUPERIOR: BUSCADOR Y FILTROS ---
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            child: Column(
              children: [
                // Buscador
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100], 
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState((){}), // Actualiza al escribir
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      hintText: 'Buscar incidentes...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    ),
                  ),
                ),
                
                const SizedBox(height: 15),
                
                // Chips de Filtro
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Todos'),
                      _buildFilterChip('Robo'),
                      _buildFilterChip('Accidente'),
                      _buildFilterChip('Incendio'),
                      _buildFilterChip('Pelea'),
                      _buildFilterChip('Vandalismo'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- LISTA DE REPORTES ---
          Expanded(
            child: listaMostrar.isEmpty 
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.folder_off_outlined, size: 70, color: Colors.grey[300]),
                    const SizedBox(height: 15),
                    Text("No se encontraron reportes", style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                  ],
                ),
              )
            : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              itemCount: listaMostrar.length,
              itemBuilder: (context, index) {
                final notificacion = listaMostrar[index];
                
                String tipo = (notificacion['tipo'] ?? 'Desconocido');
                String reporte = notificacion['reporte'] ?? '';
                String usuario = notificacion['usuario'] ?? 'Anónimo';
                if (notificacion['anonimo'] == 'Sí') usuario = 'Anónimo';
                String fecha = notificacion['dia'] ?? '';
                String hora = notificacion['hora'] ?? '';

                Color colorTema = _getColorPorTipo(tipo);
                IconData iconoTema = _getIconoPorTipo(tipo);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ]
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _mostrarDetalleReporte(context, notificacion),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icono lateral con color de fondo
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: colorTema.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(iconoTema, color: colorTema, size: 24),
                            ),
                            const SizedBox(width: 15),
                            
                            // Info Central
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        tipo.toUpperCase(),
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                      ),
                                      // Badge de tiempo
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: Colors.grey.shade200)
                                        ),
                                        child: Text(
                                          calcularTiempoTranscurrido(fecha, hora), 
                                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    reporte, 
                                    maxLines: 2, 
                                    overflow: TextOverflow.ellipsis, 
                                    style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.3),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.person, size: 12, color: Colors.grey[400]),
                                      const SizedBox(width: 4),
                                      Text(
                                        usuario,
                                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
      )
    );
  }
}