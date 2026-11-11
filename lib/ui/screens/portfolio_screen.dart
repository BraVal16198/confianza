import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/client.dart';
import '../../core/services/session_manager.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  List<Client> _clients = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  void _loadClients() {
    // Simular carga de datos
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _clients = _getMockClients();
        _isLoading = false;
      });
    });
  }

  List<Client> _getMockClients() {
    return [
      const Client(
        id: 'C001',
        name: 'María González',
        email: 'maria@email.com',
        phone: '+51987654321',
        score: 85.5,
        balance: 2500.0,
        nextVisit: null,
        address: 'Av. Principal 123',
        notes: 'Cliente puntual en pagos',
      ),
      const Client(
        id: 'C002',
        name: 'Carlos Rodríguez',
        email: 'carlos@email.com',
        phone: '+51987654322',
        score: 72.0,
        balance: 1800.0,
        nextVisit: null,
        address: 'Jr. Libertad 456',
        notes: 'Requiere seguimiento',
      ),
      const Client(
        id: 'C003',
        name: 'Ana López',
        email: 'ana@email.com',
        phone: '+51987654323',
        score: 95.0,
        balance: 3200.0,
        nextVisit: null,
        address: 'Calle Real 789',
        notes: 'Excelente historial crediticio',
      ),
      const Client(
        id: 'C004',
        name: 'Pedro Martínez',
        email: 'pedro@email.com',
        phone: '+51987654324',
        score: 68.0,
        balance: 1200.0,
        nextVisit: null,
        address: 'Av. Industrial 321',
        notes: 'En proceso de recuperación',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final advisor = SessionManager.instance.currentAdvisor;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portafolio'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/menu'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadClients,
          ),
        ],
      ),
      body: Column(
        children: [
          // Header con resumen
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Asesor: ${advisor?.fullName ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard('Total Clientes', '${_clients.length}', Icons.people),
                    _buildStatCard('Cartera Total', '\$${_getTotalBalance().toStringAsFixed(0)}', Icons.account_balance_wallet),
                    _buildStatCard('Score Promedio', _getAverageScore().toStringAsFixed(1), Icons.trending_up),
                  ],
                ),
              ],
            ),
          ),
          // Lista de clientes
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _clients.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people_outline, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No hay clientes en el portafolio',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _clients.length,
                        itemBuilder: (context, index) {
                          final client = _clients[index];
                          return _buildClientCard(client);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddClientDialog(),
        backgroundColor: Colors.blue.shade600,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue.shade600),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade700,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.blue.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildClientCard(Client client) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getScoreColor(client.score),
          child: Text(
            client.name.substring(0, 1).toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          client.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tel: ${client.phone}'),
            Text('Balance: \$${client.balance.toStringAsFixed(0)}'),
            Row(
              children: [
                Icon(Icons.star, size: 16, color: _getScoreColor(client.score)),
                const SizedBox(width: 4),
                Text('Score: ${client.score.toStringAsFixed(1)}'),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility),
                  SizedBox(width: 8),
                  Text('Ver Detalles'),
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
              value: 'visit',
              child: Row(
                children: [
                  Icon(Icons.location_on),
                  SizedBox(width: 8),
                  Text('Programar Visita'),
                ],
              ),
            ),
          ],
          onSelected: (value) => _handleClientAction(value, client),
        ),
        onTap: () => _showClientDetails(client),
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  double _getTotalBalance() {
    return _clients.fold(0.0, (sum, client) => sum + client.balance);
  }

  double _getAverageScore() {
    if (_clients.isEmpty) return 0.0;
    return _clients.fold(0.0, (sum, client) => sum + client.score) / _clients.length;
  }

  void _handleClientAction(dynamic value, Client client) {
    switch (value) {
      case 'view':
        _showClientDetails(client);
        break;
      case 'edit':
        _showEditClientDialog(client);
        break;
      case 'visit':
        _showScheduleVisitDialog(client);
        break;
    }
  }

  void _showClientDetails(Client client) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(client.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${client.email}'),
            Text('Teléfono: ${client.phone}'),
            Text('Dirección: ${client.address}'),
            Text('Balance: \$${client.balance.toStringAsFixed(2)}'),
            Text('Score: ${client.score.toStringAsFixed(1)}'),
            if (client.notes != null) ...[
              const SizedBox(height: 8),
              Text('Notas: ${client.notes}'),
            ],
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

  void _showAddClientDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar Cliente'),
        content: const Text('Funcionalidad de agregar cliente en desarrollo'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showEditClientDialog(Client client) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Cliente'),
        content: Text('Editar ${client.name} - En desarrollo'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showScheduleVisitDialog(Client client) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Programar Visita'),
        content: Text('Programar visita para ${client.name} - En desarrollo'),
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
