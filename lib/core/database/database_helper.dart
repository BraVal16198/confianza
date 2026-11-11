import '../../domain/models/client.dart';
import '../../domain/models/task.dart';
import '../../domain/models/visit.dart';

/// Almacén en memoria compatible con web/móvil para la demo de portafolio.
/// Sustituye sqflite (no soportado en Flutter web sin FFI) para que la app
/// corra en GitHub Pages / Vercel sin backend.
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  final List<Client> _clients = [];
  final List<Task> _tasks = [];
  final List<Visit> _visits = [];
  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    _seed();
    _initialized = true;
  }

  void _seed() {
    final now = DateTime.now();
    _clients.addAll([
      Client(
        id: 'C001',
        name: 'María González',
        email: 'maria@email.com',
        phone: '+51987654321',
        score: 85.5,
        balance: 2500.0,
        address: 'Av. Principal 123, Lima',
        notes: 'Cliente puntual en pagos, excelente historial',
      ),
      Client(
        id: 'C002',
        name: 'Carlos Rodríguez',
        email: 'carlos@email.com',
        phone: '+51987654322',
        score: 72.0,
        balance: 1800.0,
        address: 'Jr. Libertad 456, Arequipa',
        notes: 'Requiere seguimiento, pagos irregulares',
      ),
      Client(
        id: 'C003',
        name: 'Ana López',
        email: 'ana@email.com',
        phone: '+51987654323',
        score: 95.0,
        balance: 3200.0,
        address: 'Calle Real 789, Trujillo',
        notes: 'Excelente historial crediticio, cliente premium',
      ),
      Client(
        id: 'C004',
        name: 'Pedro Martínez',
        email: 'pedro@email.com',
        phone: '+51987654324',
        score: 68.0,
        balance: 1200.0,
        address: 'Av. Industrial 321, Chiclayo',
        notes: 'En proceso de recuperación, pagos atrasados',
      ),
      Client(
        id: 'C005',
        name: 'Lucía Fernández',
        email: 'lucia@email.com',
        phone: '+51987654325',
        score: 78.5,
        balance: 0.0,
        address: 'Plaza Mayor 654, Cusco',
        notes: 'Cliente nuevo, sin historial crediticio',
      ),
    ]);

    _tasks.addAll([
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
    ]);
  }

  Future<List<Client>> getAllClients() async {
    await _ensureInitialized();
    final list = List<Client>.from(_clients);
    list.sort((a, b) => a.name.compareTo(b.name));
    return list;
  }

  Future<Client?> getClientById(String id) async {
    await _ensureInitialized();
    try {
      return _clients.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<String> insertClient(Client client) async {
    await _ensureInitialized();
    _clients.removeWhere((c) => c.id == client.id);
    _clients.add(client);
    return client.id;
  }

  Future<int> updateClient(Client client) async {
    await _ensureInitialized();
    final index = _clients.indexWhere((c) => c.id == client.id);
    if (index < 0) return 0;
    _clients[index] = client;
    return 1;
  }

  Future<int> deleteClient(String id) async {
    await _ensureInitialized();
    final before = _clients.length;
    _clients.removeWhere((c) => c.id == id);
    return before - _clients.length;
  }

  Future<List<Client>> searchClients(String query) async {
    await _ensureInitialized();
    final q = query.toLowerCase();
    final list = _clients.where((c) {
      return c.name.toLowerCase().contains(q) ||
          (c.email?.toLowerCase().contains(q) ?? false) ||
          (c.phone?.toLowerCase().contains(q) ?? false);
    }).toList();
    list.sort((a, b) => a.name.compareTo(b.name));
    return list;
  }

  Future<List<Task>> getAllTasks() async {
    await _ensureInitialized();
    final list = List<Task>.from(_tasks);
    list.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return list;
  }

  Future<String> insertTask(Task task) async {
    await _ensureInitialized();
    _tasks.removeWhere((t) => t.id == task.id);
    _tasks.add(task);
    return task.id;
  }

  Future<int> updateTask(Task task) async {
    await _ensureInitialized();
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index < 0) return 0;
    _tasks[index] = task;
    return 1;
  }

  Future<int> deleteTask(String id) async {
    await _ensureInitialized();
    final before = _tasks.length;
    _tasks.removeWhere((t) => t.id == id);
    return before - _tasks.length;
  }

  Future<List<Visit>> getAllVisits() async {
    await _ensureInitialized();
    final list = List<Visit>.from(_visits);
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Future<String> insertVisit(Visit visit) async {
    await _ensureInitialized();
    _visits.removeWhere((v) => v.id == visit.id);
    _visits.add(visit);
    return visit.id;
  }

  Future<Map<String, dynamic>> getDatabaseStats() async {
    await _ensureInitialized();
    return {
      'clients': _clients.length,
      'tasks': _tasks.length,
      'visits': _visits.length,
      'pending_sync': _visits.where((v) => v.isPendingSync).length,
      'backend': 'in-memory (demo web)',
    };
  }

  Future<void> clearDatabase() async {
    await _ensureInitialized();
    _visits.clear();
    _tasks.clear();
    _clients.clear();
  }
}
