import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/models/client.dart';
import '../../domain/models/task.dart';
import '../../domain/models/visit.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'confianza_micro.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabla de clientes
    await db.execute('''
      CREATE TABLE clients (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT,
        phone TEXT,
        score REAL NOT NULL DEFAULT 0.0,
        balance REAL NOT NULL DEFAULT 0.0,
        next_visit INTEGER,
        address TEXT,
        notes TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    // Tabla de tareas
    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        due_date INTEGER NOT NULL,
        status TEXT NOT NULL DEFAULT 'pending',
        client_id TEXT,
        advisor_id TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        completed_at INTEGER,
        FOREIGN KEY (client_id) REFERENCES clients (id)
      )
    ''');

    // Tabla de visitas
    await db.execute('''
      CREATE TABLE visits (
        id TEXT PRIMARY KEY,
        client_id TEXT NOT NULL,
        advisor_id TEXT NOT NULL,
        notes TEXT,
        photo_url TEXT,
        latitude REAL,
        longitude REAL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER,
        is_pending_sync INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (client_id) REFERENCES clients (id)
      )
    ''');

    // Insertar datos iniciales
    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    
    // Insertar clientes iniciales
    final clients = [
      {
        'id': 'C001',
        'name': 'María González',
        'email': 'maria@email.com',
        'phone': '+51987654321',
        'score': 85.5,
        'balance': 2500.0,
        'next_visit': null,
        'address': 'Av. Principal 123, Lima',
        'notes': 'Cliente puntual en pagos, excelente historial',
        'created_at': now,
        'updated_at': now,
      },
      {
        'id': 'C002',
        'name': 'Carlos Rodríguez',
        'email': 'carlos@email.com',
        'phone': '+51987654322',
        'score': 72.0,
        'balance': 1800.0,
        'next_visit': null,
        'address': 'Jr. Libertad 456, Arequipa',
        'notes': 'Requiere seguimiento, pagos irregulares',
        'created_at': now,
        'updated_at': now,
      },
      {
        'id': 'C003',
        'name': 'Ana López',
        'email': 'ana@email.com',
        'phone': '+51987654323',
        'score': 95.0,
        'balance': 3200.0,
        'next_visit': null,
        'address': 'Calle Real 789, Trujillo',
        'notes': 'Excelente historial crediticio, cliente premium',
        'created_at': now,
        'updated_at': now,
      },
      {
        'id': 'C004',
        'name': 'Pedro Martínez',
        'email': 'pedro@email.com',
        'phone': '+51987654324',
        'score': 68.0,
        'balance': 1200.0,
        'next_visit': null,
        'address': 'Av. Industrial 321, Chiclayo',
        'notes': 'En proceso de recuperación, pagos atrasados',
        'created_at': now,
        'updated_at': now,
      },
      {
        'id': 'C005',
        'name': 'Lucía Fernández',
        'email': 'lucia@email.com',
        'phone': '+51987654325',
        'score': 78.5,
        'balance': 0.0,
        'next_visit': null,
        'address': 'Plaza Mayor 654, Cusco',
        'notes': 'Cliente nuevo, sin historial crediticio',
        'created_at': now,
        'updated_at': now,
      },
    ];

    for (final client in clients) {
      await db.insert('clients', client);
    }

    // Insertar tareas iniciales
    final tasks = [
      {
        'id': 'T001',
        'title': 'Visita a María González',
        'description': 'Realizar seguimiento de pago y evaluar nueva solicitud',
        'due_date': DateTime.now().add(const Duration(days: 1)).millisecondsSinceEpoch,
        'status': 'pending',
        'client_id': 'C001',
        'advisor_id': 'A001',
        'created_at': DateTime.now().subtract(const Duration(days: 2)).millisecondsSinceEpoch,
        'completed_at': null,
      },
      {
        'id': 'T002',
        'title': 'Revisar documentación de Carlos',
        'description': 'Verificar documentos para renovación de crédito',
        'due_date': DateTime.now().add(const Duration(days: 3)).millisecondsSinceEpoch,
        'status': 'pending',
        'client_id': 'C002',
        'advisor_id': 'A001',
        'created_at': DateTime.now().subtract(const Duration(days: 1)).millisecondsSinceEpoch,
        'completed_at': null,
      },
      {
        'id': 'T003',
        'title': 'Cobranza Pedro Martínez',
        'description': 'Contactar cliente para pago pendiente',
        'due_date': DateTime.now().millisecondsSinceEpoch,
        'status': 'pending',
        'client_id': 'C004',
        'advisor_id': 'A001',
        'created_at': DateTime.now().subtract(const Duration(days: 3)).millisecondsSinceEpoch,
        'completed_at': null,
      },
      {
        'id': 'T004',
        'title': 'Evaluación Ana López',
        'description': 'Completar evaluación crediticia',
        'due_date': DateTime.now().subtract(const Duration(days: 1)).millisecondsSinceEpoch,
        'status': 'completed',
        'client_id': 'C003',
        'advisor_id': 'A001',
        'created_at': DateTime.now().subtract(const Duration(days: 5)).millisecondsSinceEpoch,
        'completed_at': DateTime.now().subtract(const Duration(hours: 2)).millisecondsSinceEpoch,
      },
    ];

    for (final task in tasks) {
      await db.insert('tasks', task);
    }
  }

  // Métodos para clientes
  Future<List<Client>> getAllClients() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('clients', orderBy: 'name ASC');
    return List.generate(maps.length, (i) => _clientFromMap(maps[i]));
  }

  Future<Client?> getClientById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'clients',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return _clientFromMap(maps.first);
    }
    return null;
  }

  Future<String> insertClient(Client client) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;
    
    final clientMap = {
      'id': client.id,
      'name': client.name,
      'email': client.email,
      'phone': client.phone,
      'score': client.score,
      'balance': client.balance,
      'next_visit': client.nextVisit?.millisecondsSinceEpoch,
      'address': client.address,
      'notes': client.notes,
      'created_at': now,
      'updated_at': now,
    };
    
    await db.insert('clients', clientMap);
    return client.id;
  }

  Future<int> updateClient(Client client) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;
    
    return await db.update(
      'clients',
      {
        'name': client.name,
        'email': client.email,
        'phone': client.phone,
        'score': client.score,
        'balance': client.balance,
        'next_visit': client.nextVisit?.millisecondsSinceEpoch,
        'address': client.address,
        'notes': client.notes,
        'updated_at': now,
      },
      where: 'id = ?',
      whereArgs: [client.id],
    );
  }

  Future<int> deleteClient(String id) async {
    final db = await database;
    return await db.delete(
      'clients',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Client>> searchClients(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'clients',
      where: 'name LIKE ? OR email LIKE ? OR phone LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'name ASC',
    );
    return List.generate(maps.length, (i) => _clientFromMap(maps[i]));
  }

  // Métodos para tareas
  Future<List<Task>> getAllTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks', orderBy: 'due_date ASC');
    return List.generate(maps.length, (i) => _taskFromMap(maps[i]));
  }

  Future<String> insertTask(Task task) async {
    final db = await database;
    
    final taskMap = {
      'id': task.id,
      'title': task.title,
      'description': task.description,
      'due_date': task.dueDate.millisecondsSinceEpoch,
      'status': task.status.name,
      'client_id': task.clientId,
      'advisor_id': task.advisorId,
      'created_at': task.createdAt.millisecondsSinceEpoch,
      'completed_at': task.completedAt?.millisecondsSinceEpoch,
    };
    
    await db.insert('tasks', taskMap);
    return task.id;
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    
    return await db.update(
      'tasks',
      {
        'title': task.title,
        'description': task.description,
        'due_date': task.dueDate.millisecondsSinceEpoch,
        'status': task.status.name,
        'client_id': task.clientId,
        'advisor_id': task.advisorId,
        'completed_at': task.completedAt?.millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(String id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Métodos para visitas
  Future<List<Visit>> getAllVisits() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('visits', orderBy: 'created_at DESC');
    return List.generate(maps.length, (i) => _visitFromMap(maps[i]));
  }

  Future<String> insertVisit(Visit visit) async {
    final db = await database;
    
    final visitMap = {
      'id': visit.id,
      'client_id': visit.clientId,
      'advisor_id': visit.advisorId,
      'notes': visit.notes,
      'photo_url': visit.photoUrl,
      'latitude': visit.latitude,
      'longitude': visit.longitude,
      'created_at': visit.createdAt.millisecondsSinceEpoch,
      'updated_at': visit.updatedAt?.millisecondsSinceEpoch,
      'is_pending_sync': visit.isPendingSync ? 1 : 0,
    };
    
    await db.insert('visits', visitMap);
    return visit.id;
  }

  // Métodos de conversión
  Client _clientFromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      score: map['score'],
      balance: map['balance'],
      nextVisit: map['next_visit'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['next_visit'])
          : null,
      address: map['address'],
      notes: map['notes'],
    );
  }

  Task _taskFromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.fromMillisecondsSinceEpoch(map['due_date']),
      status: TaskStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => TaskStatus.pending,
      ),
      clientId: map['client_id'],
      advisorId: map['advisor_id'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      completedAt: map['completed_at'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['completed_at'])
          : null,
    );
  }

  Visit _visitFromMap(Map<String, dynamic> map) {
    return Visit(
      id: map['id'],
      clientId: map['client_id'],
      advisorId: map['advisor_id'],
      notes: map['notes'],
      photoUrl: map['photo_url'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      updatedAt: map['updated_at'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['updated_at'])
          : null,
      isPendingSync: map['is_pending_sync'] == 1,
    );
  }

  // Método para obtener estadísticas de la base de datos
  Future<Map<String, dynamic>> getDatabaseStats() async {
    final db = await database;
    
    final clientCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM clients')) ?? 0;
    final taskCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM tasks')) ?? 0;
    final visitCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM visits')) ?? 0;
    final pendingSyncCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM visits WHERE is_pending_sync = 1')) ?? 0;
    
    return {
      'clients': clientCount,
      'tasks': taskCount,
      'visits': visitCount,
      'pending_sync': pendingSyncCount,
    };
  }

  // Método para limpiar la base de datos (solo para desarrollo)
  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('visits');
    await db.delete('tasks');
    await db.delete('clients');
  }
}

