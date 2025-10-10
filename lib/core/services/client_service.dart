import '../../domain/models/client.dart';
import '../database/database_helper.dart';

class ClientService {
  static final ClientService _instance = ClientService._internal();
  factory ClientService() => _instance;
  ClientService._internal();

  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Obtener todos los clientes
  Future<List<Client>> getAllClients() async {
    return await _dbHelper.getAllClients();
  }

  // Obtener cliente por ID
  Future<Client?> getClientById(String id) async {
    return await _dbHelper.getClientById(id);
  }

  // Crear nuevo cliente
  Future<Client> createClient(Client client) async {
    // Generar ID único si no se proporciona
    final newClient = client.id.isEmpty 
        ? client.copyWith(id: _generateId())
        : client;
    
    await _dbHelper.insertClient(newClient);
    return newClient;
  }

  // Actualizar cliente
  Future<Client> updateClient(Client client) async {
    final rowsAffected = await _dbHelper.updateClient(client);
    if (rowsAffected == 0) {
      throw Exception('Cliente no encontrado');
    }
    return client;
  }

  // Eliminar cliente
  Future<bool> deleteClient(String id) async {
    final rowsAffected = await _dbHelper.deleteClient(id);
    return rowsAffected > 0;
  }

  // Buscar clientes
  Future<List<Client>> searchClients(String query) async {
    if (query.isEmpty) return await getAllClients();
    return await _dbHelper.searchClients(query);
  }

  // Obtener clientes por score
  Future<List<Client>> getClientsByScoreRange(double minScore, double maxScore) async {
    final allClients = await getAllClients();
    return allClients.where((client) {
      return client.score >= minScore && client.score <= maxScore;
    }).toList();
  }

  // Obtener clientes con pagos pendientes
  Future<List<Client>> getClientsWithPendingPayments() async {
    final allClients = await getAllClients();
    return allClients.where((client) {
      return client.balance > 0;
    }).toList();
  }

  // Obtener estadísticas de la base de datos
  Future<Map<String, dynamic>> getDatabaseStats() async {
    return await _dbHelper.getDatabaseStats();
  }

  String _generateId() {
    return 'C${DateTime.now().millisecondsSinceEpoch}';
  }
}

// Extensión para Client
extension ClientExtension on Client {
  Client copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    double? score,
    double? balance,
    DateTime? nextVisit,
    String? address,
    String? notes,
  }) {
    return Client(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      score: score ?? this.score,
      balance: balance ?? this.balance,
      nextVisit: nextVisit ?? this.nextVisit,
      address: address ?? this.address,
      notes: notes ?? this.notes,
    );
  }
}
