import 'package:flutter/material.dart';
import 'package:myapp/database/database_helper.dart';

class EditScreen extends StatefulWidget {
  final int tarefaId;
  final String tarefaTitle;
  final String tarefaDate;
  final String tarefaTime;
  final String tarefaDescription;
  final DatabaseHelper databaseHelper; // Adiciona o DatabaseHelper como uma propriedade

  const EditScreen({
    super.key,
    required this.tarefaId,
    required this.tarefaTitle,
    required this.tarefaDate,
    required this.tarefaTime,
    required this.tarefaDescription,
    required this.databaseHelper, // Adiciona o DatabaseHelper como uma propriedade obrigatória
  });

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.tarefaTitle);
    _dateController = TextEditingController(text: widget.tarefaDate);
    _timeController = TextEditingController(text: widget.tarefaTime);
    _descriptionController = TextEditingController(text: widget.tarefaDescription);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Função para salvar as mudanças no banco de dados
  Future<void> _salvarEdicao() async {
    // Cria um mapa com as informações da tarefa editada
    final updatedTask = {
      'title': _titleController.text,
      'date': _dateController.text,
      'time': _timeController.text,
      'description': _descriptionController.text,
    };

    // Chama o método de atualização do DatabaseHelper
    await widget.databaseHelper.updateTask(widget.tarefaId, updatedTask);

    // Retorna à tela anterior
    Navigator.pop(context, true); // Passa "true" para indicar que a edição foi salva
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: 'Data'),
            ),
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(labelText: 'Hora'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarEdicao,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
