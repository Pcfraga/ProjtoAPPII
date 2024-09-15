import 'package:flutter/material.dart';
import 'package:myapp/database/database_helper.dart';

@immutable
class TaskFormScreen extends StatefulWidget {
  final int? taskId; // ID da tarefa para edição ou adição
  final String? initialTitle;
  final String? initialDate;
  final String? initialTime;
  final String? initialDescription;
  final int userId; // userId como parâmetro obrigatório
  final DatabaseHelper databaseHelper; // DatabaseHelper como parâmetro obrigatório

  const TaskFormScreen({
    super.key,
    this.taskId,
    this.initialTitle,
    this.initialDate,
    this.initialTime,
    this.initialDescription,
    required this.userId, // userId requerido
    required this.databaseHelper, // DatabaseHelper requerido
  }); // Passa key para a classe base

  @override
  TaskFormScreenState createState() => TaskFormScreenState();
}

class TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _dateController = TextEditingController(text: widget.initialDate ?? '');
    _timeController = TextEditingController(text: widget.initialTime ?? '');
    _descriptionController = TextEditingController(text: widget.initialDescription ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Tarefa'),
        automaticallyImplyLeading: true,
      ),
      backgroundColor: const Color.fromARGB(255, 21, 11, 113),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: UnderlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um título';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Data (YYYY-MM-DD)',
                    border: UnderlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma data';
                    }
                    // Adicione validação de data aqui, se necessário
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _timeController,
                  decoration: const InputDecoration(
                    labelText: 'Hora (HH:MM)',
                    border: UnderlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma hora';
                    }
                    // Adicione validação de hora aqui, se necessário
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    border: UnderlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma descrição';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                Center(
                  child: ElevatedButton(
                    onPressed: _saveTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromARGB(255, 88, 17, 212),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Salvar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState?.validate() ?? false) {
      final task = {
        'title': _titleController.text,
        'date': _dateController.text,
        'time': _timeController.text,
        'description': _descriptionController.text,
        'userId': widget.userId, // Adiciona o userId aqui
      };

      if (widget.taskId == null) {
        // Cria uma nova tarefa
        await widget.databaseHelper.insertTask(task);
      } else {
        // Atualiza a tarefa existente
        await widget.databaseHelper.updateTask(widget.taskId!, task);
      }

      Navigator.pop(context, task); // Volta para a tela anterior com a tarefa
    }
  }
}
