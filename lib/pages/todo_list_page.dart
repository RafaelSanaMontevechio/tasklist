import 'package:flutter/material.dart';

import '../models/task.dart';
import '../widgets/task_item.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({super.key});

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  final TextEditingController taskController = TextEditingController();
  final TextEditingController taskDescriptionController =
      TextEditingController();

  List<Task> tasks = [];
  Task? deletedTask;
  int? deletedTaskIndex;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: taskController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Título da tarefa",
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: taskDescriptionController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Descrição da tarefa",
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        String task = taskController.text;

                        if (task.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                "Você precisa informar o título da tarefa!",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: Colors.orange[400],
                              duration: const Duration(seconds: 3),
                            ),
                          );

                          return;
                        }

                        setState(() {
                          Task newTask = Task(
                              title: task,
                              date: DateTime.now(),
                              description: taskDescriptionController.text);
                          tasks.add(newTask);
                        });
                        taskController.clear();
                        taskDescriptionController.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00bff3),
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Task taskItem in tasks)
                        TaskItem(task: taskItem, onDelete: onDelete),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Você possui ${tasks.length} tarefas",
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: tasks.isNotEmpty ? handleConfirmDeleteTasksDialog : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFE4A49),
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        disabledBackgroundColor: Colors.grey[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        "Limpar tudo",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Task task) {
    deletedTask = task;
    deletedTaskIndex = tasks.indexOf(task);

    setState(() {
      tasks.remove(task);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Tarefa ${task.title} foi removida!",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green[300],
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: Colors.black,
          onPressed: () {
            setState(
              () {
                tasks.insert(deletedTaskIndex!, deletedTask!);
              },
            );
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void onDeleteAllTasks() {
    setState(() {
      tasks.clear();
    });
  }

  void handleConfirmDeleteTasksDialog() {
    if (tasks.isEmpty) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Deletar tudo?"),
        content: const Text("Tem certeza que deseja deletar todas as tarefas?"),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.of(context).pop();

              onDeleteAllTasks();
            },
            child: const Text("Deletar tudo"),
          ),
        ],
      ),
    );
  }
}
