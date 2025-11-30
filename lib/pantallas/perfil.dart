import 'package:flutter/material.dart';
import 'package:proyectofinal_grupo10_avansado/componentes/acerca_de.dart';
import 'package:proyectofinal_grupo10_avansado/componentes/ayuda_soporte.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  // Claves para SharedPreferences (Coinciden con el Login)
  static const String _imagePathKey = 'profile_image_path';
  static const String _nameKey = 'user_name_key'; 
  static const String _bloodKey = 'blood_type_key';
  static const String _addressKey = 'address_key';
  static const String _contactKey = 'emergency_contact_key';

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  String _userName = 'Juan Pérez';
  String _bloodType = 'O+';
  String _address = 'Av. 6 de Agosto #123';
  String _emergencyContact = '70012345';
  
  late final TextEditingController _nameController;
  late final TextEditingController _bloodController;
  late final TextEditingController _addressController;
  late final TextEditingController _contactController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _userName);
    _bloodController = TextEditingController(text: _bloodType);
    _addressController = TextEditingController(text: _address);
    _contactController = TextEditingController(text: _emergencyContact);
    
    _loadProfileImagePath();
    _loadAllUserData(); // Esto cargará el nombre que pusiste en el Login
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bloodController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  // --- LOGICA DE DATOS ---
  Future<void> _loadAllUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Aquí recuperamos el nombre guardado en el Login
      _userName = prefs.getString(_nameKey) ?? 'Juan Pérez';
      _bloodType = prefs.getString(_bloodKey) ?? 'O+';
      _address = prefs.getString(_addressKey) ?? 'Av. 6 de Agosto #123';
      _emergencyContact = prefs.getString(_contactKey) ?? '70012345';

      _nameController.text = _userName;
      _bloodController.text = _bloodType;
      _addressController.text = _address;
      _contactController.text = _emergencyContact;
    });
  }

  Future<void> _saveAllUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, _nameController.text.trim());
    await prefs.setString(_bloodKey, _bloodController.text.trim());
    await prefs.setString(_addressKey, _addressController.text.trim());
    await prefs.setString(_contactKey, _contactController.text.trim());
    
    FocusScope.of(context).unfocus(); 

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text('Perfil actualizado correctamente'),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  // --- LOGICA IMAGEN ---
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
    }
  }

  // --- WIDGET BUILD ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('CONFIGURAR PERFIL', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            
            // --- SECCIÓN 1: AVATAR ---
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
                            ]
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                            child: _profileImage == null
                                ? Icon(Icons.person, size: 60, color: Colors.grey[600])
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3)
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    _nameController.text.isEmpty ? "Usuario" : _nameController.text,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const Text(
                    "Editar información personal",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // --- SECCIÓN 2: FORMULARIO ---
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("INFORMACIÓN PERSONAL", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12, letterSpacing: 1)),
                  const SizedBox(height: 20),
                  
                  _buildModernInput(
                    controller: _nameController, 
                    label: "Nombre Completo", 
                    icon: Icons.person_outline
                  ),
                  const SizedBox(height: 20),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildModernInput(
                          controller: _bloodController, 
                          label: "Tipo Sangre", 
                          icon: Icons.bloodtype_outlined
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildModernInput(
                          controller: _contactController, 
                          label: "Tel. Emergencia", 
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildModernInput(
                    controller: _addressController, 
                    label: "Dirección de Domicilio", 
                    icon: Icons.location_on_outlined
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _saveAllUserData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent.shade700,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 5,
                        shadowColor: Colors.blueAccent.withOpacity(0.4),
                      ),
                      child: const Text(
                        'GUARDAR CAMBIOS',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // --- SECCIÓN 3: MENÚ (CON CERRAR SESIÓN) ---
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
                ]
              ),
              child: Column(
                children: [
                  _buildMenuOption(Icons.help_outline, "Ayuda y Soporte", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AyudaSoporte()),
                    );
                  }),
                  const Divider(height: 1, indent: 20, endIndent: 20),
                  _buildMenuOption(Icons.info_outline, "Acerca de la App", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AcercaDe()),
                    );
                  }),
                  const Divider(height: 1, indent: 20, endIndent: 20),
                  
                  ],
              ),
            ),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildModernInput({
    required TextEditingController controller, 
    required String label, 
    required IconData icon,
    TextInputType keyboardType = TextInputType.text
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        filled: true,
        fillColor: Colors.grey[50], 
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildMenuOption(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red[50] : Colors.blue[50],
          borderRadius: BorderRadius.circular(8)
        ),
        child: Icon(icon, color: isDestructive ? Colors.red : Colors.blueAccent, size: 22),
      ),
      title: Text(
        title, 
        style: TextStyle(
          fontWeight: FontWeight.w600, 
          color: isDestructive ? Colors.red : Colors.black87
        )
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    );
  }
}