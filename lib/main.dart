import 'package:flutter/material.dart';
import 'package:myapp/database/database_helper.dart';
import 'package:myapp/screens/cadastro_screen.dart';
import 'package:myapp/screens/datails_screen.dart'; // Corrigido: details_screen
import 'package:myapp/screens/edit_screen.dart';
import 'package:myapp/screens/login_screen.dart';
import 'package:myapp/screens/tarefas_screen.dart';
import 'package:myapp/screens/task_form_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o DatabaseHelper
  final databaseHelper = DatabaseHelper();

  runApp(MyApp(databaseHelper: databaseHelper));
}

class MyApp extends StatelessWidget {
  final DatabaseHelper databaseHelper;

  const MyApp({super.key, required this.databaseHelper});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarefas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(databaseHelper: databaseHelper),
        '/cadastro': (context) => CadastroScreen(databaseHelper: databaseHelper),
        '/tarefas': (context) => TarefasScreen(databaseHelper: databaseHelper, userId: 0),
        '/tarefaDetalhes': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ?? {};
          return DetailsScreen(
            tarefaId: args['id'] != null ? int.tryParse(args['id'].toString()) ?? 0 : 0, tarefaTitle: '', tarefaDate: '', tarefaTime: '', tarefaDescription: '',
          );
        },
        '/editTask': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ?? {};
          return EditScreen(
            tarefaId: args['id'] != null ? int.tryParse(args['id'].toString()) ?? 0 : 0,
            tarefaTitle: args['title'] ?? '',
            tarefaDate: args['date'] ?? '',
            tarefaTime: args['time'] ?? '',
            tarefaDescription: args['description'] ?? '',
            databaseHelper: databaseHelper,
          );
        },
        '/taskForm': (context) {
  final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ?? {};
  
  // Obtendo o userId do contexto atual ou de outra fonte.
  // Este valor precisa ser passado corretamente ao criar o TaskFormScreen.
  const int userId = 0; // Substitua este valor pelo `userId` apropriado que você deve passar.

  return TaskFormScreen(
    taskId: args['id'] != null ? int.tryParse(args['id'].toString()) ?? 0 : 0,
    initialTitle: args['title'] ?? '',
    initialDate: args['date'] ?? '',
    initialTime: args['time'] ?? '',
    initialDescription: args['description'] ?? '',
    userId: userId, // Adicione o userId aqui
    databaseHelper: databaseHelper, // Certifique-se de que databaseHelper está sendo passado corretamente
  );
},

      },
    );
  }
}
