import 'package:flutter/material.dart';
import 'package:myapp/database/database_helper.dart';

class DetailsScreen extends StatelessWidget {
  final int tarefaId;
  final String tarefaTitle;
  final String tarefaDate;
  final String tarefaTime;
  final String tarefaDescription;

  const DetailsScreen({
    super.key,
    required this.tarefaId,
    required this.tarefaTitle,
    required this.tarefaDate,
    required this.tarefaTime,
    required this.tarefaDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tarefaTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Data: $tarefaDate'),
            Text('Hora: $tarefaTime'),
            Text('Descrição: $tarefaDescription'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
  context,
  '/tarefaDetalhes',
  arguments: {
    'id': tarefaId,
    'tarefaTitle': tarefaTitle,
    'tarefaDate': tarefaDate,
    'tarefaTime': tarefaTime,
    'tarefaDescription': tarefaDescription,
  },
);

                  },
                  child: const Text('Editar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await DatabaseHelper().deleteTask(tarefaId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tarefa excluída com sucesso!')),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Excluir'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
