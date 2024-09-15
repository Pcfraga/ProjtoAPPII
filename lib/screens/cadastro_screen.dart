import 'package:flutter/material.dart';
import 'package:myapp/database/database_helper.dart'; // Importa o DatabaseHelper para lidar com o SQLite
import 'package:bcrypt/bcrypt.dart'; // Importa o bcrypt para hashing de senhas

class CadastroScreen extends StatefulWidget {
  final DatabaseHelper databaseHelper; // Adiciona a dependência como um campo

  const CadastroScreen({
    super.key,
    required this.databaseHelper, // Recebe o DatabaseHelper no construtor
  });

  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _repitaSenhaController = TextEditingController();

  // Função para cadastrar o usuário no banco de dados SQLite
  Future<void> _cadastrarUsuario() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Verifica se as senhas coincidem
      if (_senhaController.text != _repitaSenhaController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('As senhas não coincidem!')),
        );
        return;
      }

      // Hash da senha
      final hashedPassword = BCrypt.hashpw(_senhaController.text, BCrypt.gensalt());

      // Insere o novo usuário no banco de dados
      await widget.databaseHelper.insertUser(
        _emailController.text,
        hashedPassword, // Armazena a senha hash no banco de dados
      );

      // Exibe mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );

      // Navega para a tela de login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cadastro',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 52, 20, 235),
        centerTitle: true,
        leading: const SizedBox.shrink(), // Remove o ícone de navegação
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color.fromARGB(255, 15, 23, 184),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Imagem acima dos campos
                  Image.asset(
                    'lib/assets/logo.png',
                    height: 200,
                    width: 300,
                  ),
                  const SizedBox(height: 32),

                  // Campo de Nome
                  _buildTextField(
                    label: 'Nome',
                    obscureText: false,
                    textInputAction: TextInputAction.next,
                    controller: _nomeController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu nome';
                      }
                      return null;
                    },
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16),

                  // Campo de Email
                  _buildTextField(
                    label: 'Email',
                    obscureText: false,
                    textInputAction: TextInputAction.next,
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um email';
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Por favor, insira um email válido';
                      }
                      return null;
                    },
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 16),

                  // Campo de Senha
                  _buildTextField(
                    label: 'Senha',
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    controller: _senhaController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma senha';
                      }
                      return null;
                    },
                    icon: Icons.lock,
                  ),
                  const SizedBox(height: 16),

                  // Campo de Repita a Senha
                  _buildTextField(
                    label: 'Repita a Senha',
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    controller: _repitaSenhaController,
                    validator: (value) {
                      if (value != _senhaController.text) {
                        return 'As senhas não coincidem';
                      }
                      return null;
                    },
                    icon: Icons.lock_outline,
                  ),
                  const SizedBox(height: 20),

                  // Botão de Cadastro
                  ElevatedButton(
                    onPressed: _cadastrarUsuario, // Função que cadastra o usuário no SQLite
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Cor de fundo
                      foregroundColor: const Color.fromARGB(255, 88, 17, 212), // Cor do texto
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Cadastrar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required bool obscureText,
    required TextInputAction textInputAction,
    required TextEditingController controller,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.center,
      obscureText: obscureText,
      textInputAction: textInputAction,
      style: const TextStyle(color: Colors.white), // Define a cor do texto digitado
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white), // Adiciona ícone ao campo
        border: const UnderlineInputBorder(),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        contentPadding: const EdgeInsets.only(bottom: 10),
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      validator: validator,
    );
  }
}
