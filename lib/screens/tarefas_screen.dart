import 'package:flutter/material.dart';
import 'package:myapp/database/database_helper.dart';

class TarefasScreen extends StatefulWidget {
  final int userId;
  final DatabaseHelper databaseHelper;

  const TarefasScreen({
    super.key,
    required this.userId,
    required this.databaseHelper,
  });

  @override
  _TarefasScreenState createState() => _TarefasScreenState();
}

class _TarefasScreenState extends State<TarefasScreen> {
  List<Map<String, dynamic>> _tarefas = [];

  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  Future<void> _carregarTarefas() async {
    try {
      final tarefas = await widget.databaseHelper.getTasks(widget.userId);
      setState(() {
        _tarefas = tarefas;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar tarefas: $e')),
      );
    }
  }

  Future<void> _deletarTarefa(int id) async {
    try {
      await widget.databaseHelper.deleteTask(id);
      _carregarTarefas(); // Atualize a lista de tarefas após a exclusão
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao deletar tarefa: $e')),
      );
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Você tem certeza que deseja excluir esta tarefa?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Excluir'),
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o diálogo antes de deletar
                _deletarTarefa(id);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Tarefas',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 62, 11, 216),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _tarefas.length,
          itemBuilder: (context, index) {
            final tarefa = _tarefas[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: Text(
                  tarefa['title'] ?? 'Sem título',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Descrição: ${tarefa['description'] ?? 'Nenhuma descrição'}',
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/tarefaDetalhes',
                    arguments: tarefa,
                  );
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      child: const Text(
                        'Editar',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/editTask',
                          arguments: tarefa,
                        );
                      },
                    ),
                    TextButton(
                      child: const Text(
                        'Excluir',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () {
                        _showDeleteConfirmationDialog(context, tarefa['id']);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
  onPressed: () async {
    final result = await Navigator.pushNamed(
      context,
      '/taskForm',
      arguments: {
        'userId': widget.userId,
      },
    );
    if (result != null) {
      // Se uma nova tarefa foi adicionada ou uma tarefa foi editada, atualize a lista
      _carregarTarefas();
    }
  },
  backgroundColor: Colors.white,
  child: const Icon(Icons.add, color: Colors.blue),
),
    );
  }
}
