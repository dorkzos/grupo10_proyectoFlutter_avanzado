import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  static const String _imagePathKey = 'profile_image_path';
  static const String _nameKey = 'user_name_key';
  static const String _bloodKey = 'blood_type_key';
  static const String _addressKey = 'address_key';
  static const String _contactKey = 'emergency_contact_key';

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  String _userName = 'JUAN PEREZ';
  String _bloodType = 'O POSITIVO';
  String _address = 'CALLE X AVENIDA X NRO 123';
  String _emergencyContact = '789678754';
  
  // Controllers
  // Usamos 'late' e inicializamos en initState
  late final TextEditingController _nameController;
  late final TextEditingController _bloodController;
  late final TextEditingController _addressController;
  late final TextEditingController _contactController;

  @override
  void initState() {
    super.initState();
    // 1. Inicializar controllers con valores por defecto
    _nameController = TextEditingController(text: _userName);
    _bloodController = TextEditingController(text: _bloodType);
    _addressController = TextEditingController(text: _address);
    _contactController = TextEditingController(text: _emergencyContact);
    
    // 2. Cargar datos persistentes al iniciar
    _loadProfileImagePath();
    _loadAllUserData();
    
    // Nota: Se han eliminado los FocusNodes y sus listeners
  }

  @override
  void dispose() {
    // Limpiar los Controllers
    _nameController.dispose();
    _bloodController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  // --- FUNCIONES DE PERSISTENCIA ---
  
  // Cargar todos los datos de texto al iniciar
  Future<void> _loadAllUserData() async {
    final prefs = await SharedPreferences.getInstance();
    
    setState(() {
      _userName = prefs.getString(_nameKey) ?? 'JUAN PEREZ';
      _bloodType = prefs.getString(_bloodKey) ?? 'O POSITIVO';
      _address = prefs.getString(_addressKey) ?? 'CALLE X AVENIDA X NRO 123';
      _emergencyContact = prefs.getString(_contactKey) ?? '789678754';

      // Actualizar los controllers con los datos cargados
      _nameController.text = _userName;
      _bloodController.text = _bloodType;
      _addressController.text = _address;
      _contactController.text = _emergencyContact;
    });
  }

  // **NUEVA FUNCIÓN** - Guarda todos los datos cuando se presiona el botón
  Future<void> _saveAllUserData() async {
    final prefs = await SharedPreferences.getInstance();

    // Guardar todos los valores de los controllers
    await prefs.setString(_nameKey, _nameController.text.trim());
    await prefs.setString(_bloodKey, _bloodController.text.trim());
    await prefs.setString(_addressKey, _addressController.text.trim());
    await prefs.setString(_contactKey, _contactController.text.trim());
    
    // Cerrar el teclado si está abierto
    FocusScope.of(context).unfocus(); 

    // Mostrar confirmación
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Cambios guardados exitosamente!'),
          backgroundColor: Colors.green,
        ),
      );
      // Opcional: Recargar los datos para actualizar el estado, aunque los controllers ya tienen los valores
      // await _loadAllUserData(); 
    }
  }

  // --- FUNCIONES DE IMAGEN (SE MANTIENEN IGUAL) ---
  Future<void> _loadProfileImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPath = prefs.getString(_imagePathKey);
    if (savedPath != null) {
      setState(() {
        _profileImage = File(savedPath);
      });
    }
  }
  
  Future<void> _saveProfileImagePath(File imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_imagePathKey, imageFile.path);
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final newImageFile = File(pickedFile.path);
      setState(() {
        _profileImage = newImageFile;
      });
      await _saveProfileImagePath(newImageFile);
      // _uploadProfileImage(newImageFile); // Opcional
    }
  }

  Future<void> _uploadProfileImage(File imageFile) async {
    print('Uploading file: ${imageFile.path}');
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile image uploaded successfully!')),
      );
    }
  }
  
  // --- WIDGET BUILD ---
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
            // --- Círculo de Imagen ---
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey,
                      backgroundImage: _profileImage != null 
                        ? FileImage(_profileImage!) 
                        : null,
                      child: _profileImage == null
                          ? const Icon(Icons.person, size: 70, color: Colors.white)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Icon(Icons.edit, color: Colors.red[400], size: 20),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // --- Tarjeta de Información Personal ---
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
                    // 1. NOMBRE Y APELLIDOS
                    const Text(
                      'NOMBRE Y APELLIDOS',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12),
                    ),
                    TextField(
                      controller: _nameController, // <-- Usando Controller
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.edit, color: Colors.red[400], size: 18),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                        border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // 2. TIPO DE SANGRE
                    const Text(
                      'TIPO DE SANGRE',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12),
                    ),
                    TextField(
                      controller: _bloodController, // <-- Usando Controller
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.edit, color: Colors.red[400], size: 18),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                        border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // 3. DIRECCION
                    const Text(
                      'DIRECCION',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12),
                    ),
                    TextField(
                      controller: _addressController, // <-- Usando Controller
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.edit, color: Colors.red[400], size: 18),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                        border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // 4. CONTACTO DE EMERGENCIA
                    const Text(
                      'CONTACTO DE EMERGENCIA',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12),
                    ),
                    TextField(
                      controller: _contactController, // <-- Usando Controller
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.edit, color: Colors.red[400], size: 18),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
                        border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                      ),
                    ),
                    
                    const SizedBox(height: 25), 
                    
                    // **BOTÓN GUARDAR**
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveAllUserData, // <-- Llama a la nueva función de guardado
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          'GUARDAR CAMBIOS',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // --- Sección General (Botones) ---
            const Text(
              'GENERAL',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            
            // ... (Resto de botones de ayuda y acerca de)
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
