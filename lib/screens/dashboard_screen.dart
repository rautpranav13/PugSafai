import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pug_safai/models/cleaning_task.dart';
import 'package:pug_safai/providers/auth_provider.dart';
import 'package:pug_safai/models/user.dart';
import 'package:pug_safai/screens/start_task_screen.dart';
import 'package:pug_safai/screens/complete_task_screen.dart';
import 'package:pug_safai/services/api_services.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  User? currentUser;
  List<CleaningTask> ongoingTasks = [];
  List<CleaningTask> completedTasks = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      currentUser = Provider.of<AuthProvider>(context, listen: false).user;
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      if (currentUser == null || currentUser!.id.isEmpty) {
        setState(() {
          errorMessage = "User not logged in.";
        });
        return;
      }

      print(currentUser?.id);
      // Fetch ongoing and completed tasks
      ongoingTasks = await ApiService.getTasks(currentUser!.id, "ongoing");
      completedTasks = await ApiService.getTasks(currentUser!.id, "completed");

    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        errorMessage = "Failed to load tasks.";
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _navigateToStartTaskScreen() {
    if (isLoading) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StartTaskScreen()),
    ).then((_) => _fetchData());
  }

  void _navigateToCompleteTaskScreen(String taskId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CompleteTaskScreen(taskId: taskId)),
    ).then((_) => _fetchData());
  }

  @override
  Widget build(BuildContext context) {
    String userName = currentUser?.name ?? 'Not logged in';
    String userEmail = currentUser?.email ?? 'No email available';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchData,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('User Name: $userName', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text('User Email: $userEmail', style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: _navigateToStartTaskScreen,
                child: const Text('Start New Task'),
              ),
            ),
            const SizedBox(height: 20),

            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text(errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 16)),
                ),
              ),

            Expanded(
              child: ListView(
                children: [
                  Text('Ongoing Work', style: Theme.of(context).textTheme.headlineSmall),
                  if (isLoading && ongoingTasks.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: Text("Loading ongoing tasks...")),
                    )
                  else if (ongoingTasks.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: Text("No ongoing tasks.")),
                    )
                  else
                    ...ongoingTasks.map((task) => Card(
                      child: ListTile(
                        title: Text(task.name),
                        subtitle: Text(task.address ?? 'No address details'),
                        onTap: () => _navigateToCompleteTaskScreen(task.id),
                      ),
                    )),

                  const SizedBox(height: 20),

                  Text('Completed Work', style: Theme.of(context).textTheme.headlineSmall),
                  if (isLoading && completedTasks.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: Text("Loading completed tasks...")),
                    )
                  else if (completedTasks.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: Text("No completed tasks.")),
                    )
                  else
                    ...completedTasks.map((task) => Card(
                      child: ListTile(
                        title: Text(task.name),
                        subtitle: Text(
                          "Status: ${task.status?.trim() ?? 'N/A'}\n"
                              "Address: ${task.address ?? 'No address'}\n"
                              "Remarks: ${task.remarks ?? 'No remarks'}",
                        ),
                      ),
                    )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
