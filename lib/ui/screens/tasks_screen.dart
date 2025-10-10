import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/task.dart';
import '../../core/services/session_manager.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Task> _allTasks = [];
  List<Task> _pendingTasks = [];
  List<Task> _completedTasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadTasks() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _allTasks = _getMockTasks();
        _pendingTasks = _allTasks.where((task) => task.status == TaskStatus.pending).toList();
        _completedTasks = _allTasks.where((task) => task.status == TaskStatus.completed).toList();
        _isLoading = false;
      });
    });
  }

  List<Task> _getMockTasks() {
    final now = DateTime.now();
    return [
      Task(
        id: 'T001',
        title: 'Visita a María González',
        description: 'Realizar seguimiento de pago y evaluar nueva solicitud',
        dueDate: now.add(const Duration(days: 1)),
        status: TaskStatus.pending,
        clientId: 'C001',
        advisorId: 'A001',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      Task(
        id: 'T002',
        title: 'Revisar documentación de Carlos',
        description: 'Verificar documentos para renovación de crédito',
        dueDate: now.add(const Duration(days: 3)),
        status: TaskStatus.pending,
        clientId: 'C002',
        advisorId: 'A001',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      Task(
        id: 'T003',
        title: 'Cobranza Pedro Martínez',
        description: 'Contactar cliente para pago pendiente',
        dueDate: now,
        status: TaskStatus.pending,
        clientId: 'C004',
        advisorId: 'A001',
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      Task(
        id: 'T004',
        title: 'Evaluación Ana López',
        description: 'Completar evaluación crediticia',
        dueDate: now.subtract(const Duration(days: 1)),
        status: TaskStatus.completed,
        clientId: 'C003',
        advisorId: 'A001',
        createdAt: now.subtract(const Duration(days: 5)),
        completedAt: now.subtract(const Duration(hours: 2)),
      ),
      Task(
        id: 'T005',
        title: 'Actualizar datos de contacto',
        description: 'Verificar y actualizar información de clientes',
        dueDate: now.add(const Duration(days: 7)),
        status: TaskStatus.pending,
        clientId: null,
        advisorId: 'A001',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final advisor = SessionManager.instance.currentAdvisor;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas'),
        backgroundColor: Colors.orange.shade600,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/menu'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTasks,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
          tabs: const [
            Tab(text: 'Todas', icon: Icon(Icons.list)),
            Tab(text: 'Pendientes', icon: Icon(Icons.pending)),
            Tab(text: 'Completadas', icon: Icon(Icons.check_circle)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Header con estadísticas
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.orange.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Asesor: ${advisor?.fullName ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard('Total', '${_allTasks.length}', Icons.list),
                    _buildStatCard('Pendientes', '${_pendingTasks.length}', Icons.pending),
                    _buildStatCard('Completadas', '${_completedTasks.length}', Icons.check_circle),
                  ],
                ),
              ],
            ),
          ),
          // Contenido de las pestañas
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTaskList(_allTasks, 'Todas las tareas'),
                _buildTaskList(_pendingTasks, 'Tareas pendientes'),
                _buildTaskList(_completedTasks, 'Tareas completadas'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(),
        backgroundColor: Colors.orange.shade600,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.orange.shade600),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.orange.shade700,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.orange.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildTaskList(List<Task> tasks, String emptyMessage) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskCard(task);
      },
    );
  }

  Widget _buildTaskCard(Task task) {
    final isOverdue = task.dueDate.isBefore(DateTime.now()) && task.status == TaskStatus.pending;
    final isDueToday = task.dueDate.day == DateTime.now().day && 
                      task.dueDate.month == DateTime.now().month && 
                      task.dueDate.year == DateTime.now().year;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: isOverdue ? Colors.red.shade50 : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(task.status),
          child: Icon(
            _getStatusIcon(task.status),
            color: Colors.white,
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isOverdue ? Colors.red.shade700 : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description != null)
              Text(task.description!),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: isOverdue ? Colors.red : Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatDate(task.dueDate),
                  style: TextStyle(
                    color: isOverdue ? Colors.red : Colors.grey,
                    fontWeight: isDueToday ? FontWeight.w600 : null,
                  ),
                ),
                if (isOverdue) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'VENCIDA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: task.status == TaskStatus.pending
            ? PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'complete',
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Text('Marcar como completada'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 8),
                        Text('Editar'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Eliminar'),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) => _handleTaskAction(value, task),
              )
            : Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
        onTap: () => _showTaskDetails(task),
      ),
    );
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Colors.orange;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.completed:
        return Colors.green;
      case TaskStatus.cancelled:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Icons.pending;
      case TaskStatus.inProgress:
        return Icons.play_circle;
      case TaskStatus.completed:
        return Icons.check_circle;
      case TaskStatus.cancelled:
        return Icons.cancel;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) {
      return 'Hoy';
    } else if (difference == 1) {
      return 'Mañana';
    } else if (difference == -1) {
      return 'Ayer';
    } else if (difference > 0) {
      return 'En $difference días';
    } else {
      return 'Hace ${-difference} días';
    }
  }

  void _handleTaskAction(dynamic value, Task task) {
    switch (value) {
      case 'complete':
        _completeTask(task);
        break;
      case 'edit':
        _showEditTaskDialog(task);
        break;
      case 'delete':
        _deleteTask(task);
        break;
    }
  }

  void _completeTask(Task task) {
    setState(() {
      final index = _allTasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _allTasks[index] = task.copyWith(
          status: TaskStatus.completed,
          completedAt: DateTime.now(),
        );
        _pendingTasks.removeWhere((t) => t.id == task.id);
        _completedTasks.add(_allTasks[index]);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tarea "${task.title}" completada'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _deleteTask(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Tarea'),
        content: Text('¿Está seguro de eliminar la tarea "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _allTasks.removeWhere((t) => t.id == task.id);
                _pendingTasks.removeWhere((t) => t.id == task.id);
                _completedTasks.removeWhere((t) => t.id == task.id);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tarea "${task.title}" eliminada'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showTaskDetails(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description != null) ...[
              Text('Descripción: ${task.description}'),
              const SizedBox(height: 8),
            ],
            Text('Fecha límite: ${_formatDate(task.dueDate)}'),
            Text('Estado: ${_getStatusText(task.status)}'),
            Text('Creada: ${_formatDate(task.createdAt)}'),
            if (task.completedAt != null)
              Text('Completada: ${_formatDate(task.completedAt!)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  String _getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'Pendiente';
      case TaskStatus.inProgress:
        return 'En Progreso';
      case TaskStatus.completed:
        return 'Completada';
      case TaskStatus.cancelled:
        return 'Cancelada';
    }
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva Tarea'),
        content: const Text('Funcionalidad de agregar tarea en desarrollo'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showEditTaskDialog(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Tarea'),
        content: Text('Editar "${task.title}" - En desarrollo'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
