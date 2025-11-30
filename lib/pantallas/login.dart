import 'package:flutter/material.dart';
import 'package:proyectofinal_grupo10_avansado/componentes/barra_de_navegacion.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();
  
  bool _mostrarPassword = false; 

  // --- BASE DE DATOS SIMULADA ---
  List<Map<String, String>> usuariosRegistrados = [
    {'nombre': 'Josue Chino', 'codigo': 'CODIGO2025'},
    {'nombre': 'Maria Lopez', 'codigo': '1234'},
    {'nombre': 'Admin', 'codigo': 'CODIGO2025'}
  ];

  void _iniciarSesion() {
    String usuarioIngresado = _usuarioController.text.trim();
    String codigoIngresado = _codigoController.text.trim();

    if (usuarioIngresado.isEmpty || codigoIngresado.isEmpty) {
      _mostrarSnack("Por favor llena todos los campos.", Colors.orange);
      return;
    }

    bool credencialesValidas = false;
    String nombreReal = usuarioIngresado;

    if (codigoIngresado == "CODIGO2025") {
      credencialesValidas = true;
    } else {
      for (var usuario in usuariosRegistrados) {
        if (usuario['codigo'] == codigoIngresado) {
          credencialesValidas = true;
          break;
        }
      }
    }

    if (credencialesValidas) {
      _mostrarSnack("¡Bienvenido, $nombreReal!", Colors.green);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NavigationBarApp(),
        ),
      );
    } else {
      _mostrarSnack("Código incorrecto.", Colors.redAccent);
    }
  }

  void _mostrarDialogoRegistro() {
    TextEditingController nuevoNombreCtrl = TextEditingController();
    TextEditingController nuevoCodigoCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 10,
          backgroundColor: Colors.white,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: 420, 
            padding: EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_add_outlined, size: 50, color: Colors.blueAccent),
                SizedBox(height: 10),
                Text(
                  "CREAR CUENTA",
                  style: TextStyle(
                    fontSize: 22, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.blue[900],
                    letterSpacing: 1.2
                  ),
                ),
                SizedBox(height: 5),
                Text("Únete a la protección comunitaria", style: TextStyle(color: Colors.grey)),
                SizedBox(height: 25),
                
                _buildModernTextField(
                  controller: nuevoNombreCtrl, 
                  hint: "Nuevo Usuario", 
                  icon: Icons.account_circle
                ),
                SizedBox(height: 15),
                _buildModernTextField(
                  controller: nuevoCodigoCtrl, 
                  hint: "Nueva Contraseña", 
                  icon: Icons.vpn_key
                ),
                
                Spacer(),
                
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          side: BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                        ),
                        child: Text("CANCELAR", style: TextStyle(color: Colors.grey[700])),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (nuevoNombreCtrl.text.isNotEmpty && nuevoCodigoCtrl.text.isNotEmpty) {
                            setState(() {
                              usuariosRegistrados.add({
                                'nombre': nuevoNombreCtrl.text.trim(),
                                'codigo': nuevoCodigoCtrl.text.trim(),
                              });
                              _usuarioController.text = nuevoNombreCtrl.text;
                              _codigoController.text = nuevoCodigoCtrl.text;
                            });
                            Navigator.pop(context);
                            _mostrarSnack("¡Registro Exitoso!", Colors.blue);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                        ),
                        child: Text("REGISTRAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _mostrarSnack(String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(10),
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller, 
    required String hint, 
    required IconData icon, 
    bool isPassword = false,
    Widget? suffixIcon, 
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: hint,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0D47A1),
                  Color(0xFF1976D2),
                  Color(0xFF42A5F5),
                ],
              ),
            ),
          ),
          
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                      border: Border.all(color: Colors.white.withOpacity(0.5), width: 2)
                    ),
                    child: Icon(Icons.security, size: 60, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'POLICÍA DE BOLSILLO',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.white,
                      letterSpacing: 1.5,
                      shadows: [Shadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))]
                    ),
                  ),
                  SizedBox(height: 40),

                  // --- TARJETA DE LOGIN ---
                  Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        )
                      ]
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Bienvenido",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22, 
                            fontWeight: FontWeight.bold, 
                            color: Colors.grey[800]
                          ),
                        ),
                        SizedBox(height: 25),
                        
                        _buildModernTextField(
                          controller: _usuarioController, 
                          hint: 'Usuario', 
                          icon: Icons.person
                        ),
                        SizedBox(height: 15),
                        
                        _buildModernTextField(
                          controller: _codigoController, 
                          hint: 'Contraseña', 
                          icon: Icons.lock, 
                          isPassword: !_mostrarPassword, 
                          suffixIcon: IconButton(
                            icon: Icon(
                              _mostrarPassword ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _mostrarPassword = !_mostrarPassword;
                              });
                            },
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 10),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, size: 16, color: Colors.blueAccent),
                              SizedBox(width: 5),
                              Text(
                                "Código actual: CODIGO2025",
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic
                                ),
                              ),
                            ],
                          ),
                        ),
                        // ----------------------------------------------

                        SizedBox(height: 25),

                        ElevatedButton(
                          onPressed: _iniciarSesion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF1565C0),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 18),
                            elevation: 5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: Text(
                            'INGRESAR', 
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),
                  
                  TextButton.icon(
                    onPressed: _mostrarDialogoRegistro,
                    icon: Icon(Icons.person_add_alt, color: Colors.white),
                    label: Text(
                      "¿No tienes cuenta? Regístrate aquí", 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}