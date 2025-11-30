import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; 
import 'package:proyectofinal_grupo10_avansado/funciones/datos.dart'; 

class HacerReporte extends StatefulWidget {
  const HacerReporte({super.key});

  @override
  State<HacerReporte> createState() => _HacerReporteState();
}

class _HacerReporteState extends State<HacerReporte> {
  String _tipoSeleccionado = '';
  File? _imagenEvidencia; // Variable para guardar la foto
  final ImagePicker _picker = ImagePicker();

  // Lista de tipos de incidentes
  final List<String> _tiposIncidentes = [
    'ROBO', 'PELEA', 'INCENDIO', 
    'ACCIDENTE', 'VANDALISMO', 'OTRO'
  ];

  final TextEditingController _descripcionController = TextEditingController();

  // --- LÓGICA PARA SELECCIONAR IMAGEN (IGUAL QUE EN PERFIL) ---
  Future<void> _seleccionarImagen(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imagenEvidencia = File(pickedFile.path);
      });
    }
  }

  // --- MUESTRA UN MENÚ PARA ELEGIR CÁMARA O GALERÍA ---
  void _mostrarOpcionesImagen() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Tomar Foto'),
                onTap: () {
                  _seleccionarImagen(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Elegir de Galería'),
                onTap: () {
                  _seleccionarImagen(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // --- LÓGICA PARA GUARDAR EL REPORTE EN LA LISTA GLOBAL ---
  void _enviarReporte() {
    // 1. Validar que se haya seleccionado un tipo
    if (_tipoSeleccionado.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor selecciona un tipo de incidente"), backgroundColor: Colors.orange),
      );
      return;
    }

    // 2. Obtener Fecha y Hora actual
    final DateTime now = DateTime.now();
    String dia = "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}";
    String hora = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    // 3. Crear el objeto Mapa del reporte
    Map<String, String> nuevoReporte = {
      'tipo': _tipoSeleccionado,
      'usuario': 'Juan Pérez', // Podrías sacarlo de SharedPreferences si quisieras
      'anonimo': 'No',
      'dia': dia,
      'hora': hora,
      'ubicacion': 'Monoblock Central UMSA',
      'reporte': _descripcionController.text.isEmpty ? 'Sin detalles adicionales' : _descripcionController.text,
      'evidencia': _imagenEvidencia?.path ?? '', 
      'es_local': 'si', 
    };

    // 4. AGREGAR A LA LISTA GLOBAL (Importada de datos.dart)
    setState(() {
      historialReportes.add(nuevoReporte); 
    });

    // 5. Feedback y salir
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("¡Reporte enviado y guardado!"), backgroundColor: Colors.green),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), 
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'REPORTAR INCIDENTE',
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // --- SECCIÓN 1: TIPO DE INCIDENTE ---
            const Text('TIPO DE INCIDENTE', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 1)),
            const SizedBox(height: 15),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _tiposIncidentes.map((tipo) {
                final bool isSelected = _tipoSeleccionado == tipo;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _tipoSeleccionado = tipo;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF1565C0) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade300),
                      boxShadow: [
                        if(!isSelected) BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5, offset: const Offset(0, 2))
                      ]
                    ),
                    child: Text(
                      tipo,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold, fontSize: 13
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            // --- SECCIÓN 2: UBICACIÓN ---
            const Text('UBICACIÓN', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 1)),
            const SizedBox(height: 15),

            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/mapa_incidente.png', 
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(color: Colors.grey[300], child: const Icon(Icons.map)),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- SECCIÓN 3: DETALLES Y EVIDENCIA ---
            const Text('DETALLES Y EVIDENCIA', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 1)),
            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade200)
              ),
              child: TextField(
                controller: _descripcionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Describe brevemente lo sucedido...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
            ),
            
            const SizedBox(height: 15),

            // --- BOTÓN DE IMAGEN DINÁMICO ---
            InkWell(
              onTap: _mostrarOpcionesImagen, // Abre cámara o galería
              child: Container(
                height: 120, 
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blue.withOpacity(0.3), style: BorderStyle.solid),
                  image: _imagenEvidencia != null 
                    ? DecorationImage(image: FileImage(_imagenEvidencia!), fit: BoxFit.cover) // Muestra la foto si existe
                    : null
                ),
                child: _imagenEvidencia == null 
                  ? Column( 
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, color: Colors.blue[700], size: 40),
                        const SizedBox(height: 10),
                        Text("Subir Foto o Video", style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold)),
                      ],
                    )
                  : Stack( 
                      children: [
                        Positioned(
                          right: 10, bottom: 10,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                            child: const Icon(Icons.edit, color: Colors.white, size: 20),
                          ),
                        )
                      ],
                    ),
              ),
            ),

            const SizedBox(height: 20),

            // --- BOTÓN ENVIAR ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                  shadowColor: Colors.redAccent.withOpacity(0.4),
                ),
                onPressed: _enviarReporte, // Llama a la función de guardado
                child: const Text(
                  'ENVIAR REPORTE',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}