import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/client.dart';
import '../../core/services/client_service.dart';
import '../../core/services/session_manager.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final ClientService _clientService = ClientService();
  List<Client> _clients = [];
  List<Client> _filteredClients = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedFilter = 'Todos';

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> _loadClients() async {
    setState(() => _isLoading = true);
    
    try {
      final clients = await _clientService.getAllClients();
      setState(() {
        _clients = clients;
        _filteredClients = clients;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Error al cargar clientes: $e');
    }
  }

  void _filterClients() {
    setState(() {
      _filteredClients = _clients.where((client) {
        // Filtro de búsqueda
        final matchesSearch = _searchQuery.isEmpty ||
            client.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            client.email?.toLowerCase().contains(_searchQuery.toLowerCase()) == true ||
            client.phone?.contains(_searchQuery) == true;

        // Filtro por categoría
        bool matchesFilter = true;
        switch (_selectedFilter) {
          case 'Excelentes (80-100)':
            matchesFilter = client.score >= 80;
            break;
          case 'Buenos (60-79)':
            matchesFilter = client.score >= 60 && client.score < 80;
            break;
          case 'Regulares (40-59)':
            matchesFilter = client.score >= 40 && client.score < 60;
            break;
          case 'Con Deuda':
            matchesFilter = client.balance > 0;
            break;
          case 'Sin Deuda':
            matchesFilter = client.balance == 0;
            break;
        }

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final advisor = SessionManager.instance.currentAdvisor;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Clientes'),
        backgroundColor: Colors.green.shade600,
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
          // Header con estadísticas
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.green.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Asesor: ${advisor?.fullName ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard('Total', '${_clients.length}', Icons.people),
                    _buildStatCard('Con Deuda', '${_clients.where((c) => c.balance > 0).length}', Icons.warning),
                    _buildStatCard('Score Prom.', _getAverageScore().toStringAsFixed(1), Icons.trending_up),
                  ],
                ),
              ],
            ),
          ),
          // Barra de búsqueda y filtros
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Barra de búsqueda
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre, email o teléfono...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() => _searchQuery = '');
                              _filterClients();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                    _filterClients();
                  },
                ),
                const SizedBox(height: 12),
                // Filtros
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      'Todos',
                      'Excelentes (80-100)',
                      'Buenos (60-79)',
                      'Regulares (40-59)',
                      'Con Deuda',
                      'Sin Deuda',
                    ].map((filter) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(filter),
                        selected: _selectedFilter == filter,
                        onSelected: (selected) {
                          setState(() => _selectedFilter = filter);
                          _filterClients();
                        },
                        selectedColor: Colors.green.shade100,
                        checkmarkColor: Colors.green.shade700,
                      ),
                    )).toList(),
                  ),
                ),
              ],
            ),
          ),
          // Lista de clientes
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredClients.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people_outline, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isNotEmpty || _selectedFilter != 'Todos'
                                  ? 'No se encontraron clientes'
                                  : 'No hay clientes registrados',
                              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredClients.length,
                        itemBuilder: (context, index) {
                          final client = _filteredClients[index];
                          return _buildClientCard(client);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddClientDialog(),
        backgroundColor: Colors.green.shade600,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.green.shade600),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade700,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.green.shade600,
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
            Text('${client.email} • ${client.phone}'),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.star, size: 16, color: _getScoreColor(client.score)),
                const SizedBox(width: 4),
                Text('Score: ${client.score.toStringAsFixed(1)}'),
                const SizedBox(width: 16),
                Icon(Icons.account_balance_wallet, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('Balance: \$${client.balance.toStringAsFixed(0)}'),
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
      case 'delete':
        _showDeleteClientDialog(client);
        break;
    }
  }

  void _showClientDetails(Client client) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(client.name),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Email', client.email ?? 'No especificado'),
              _buildDetailRow('Teléfono', client.phone ?? 'No especificado'),
              _buildDetailRow('Dirección', client.address ?? 'No especificado'),
              _buildDetailRow('Score', client.score.toStringAsFixed(1)),
              _buildDetailRow('Balance', '\$${client.balance.toStringAsFixed(2)}'),
              if (client.notes != null) ...[
                const SizedBox(height: 8),
                const Text('Notas:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(client.notes!),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showEditClientDialog(client);
            },
            child: const Text('Editar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showAddClientDialog() {
    _showClientFormDialog();
  }

  void _showEditClientDialog(Client client) {
    _showClientFormDialog(client: client);
  }

  void _showClientFormDialog({Client? client}) {
    final isEditing = client != null;
    final formKey = GlobalKey<FormState>();
    
    final nameController = TextEditingController(text: client?.name ?? '');
    final emailController = TextEditingController(text: client?.email ?? '');
    final phoneController = TextEditingController(text: client?.phone ?? '');
    final addressController = TextEditingController(text: client?.address ?? '');
    final scoreController = TextEditingController(text: client?.score.toString() ?? '');
    final balanceController = TextEditingController(text: client?.balance.toString() ?? '');
    final notesController = TextEditingController(text: client?.notes ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Editar Cliente' : 'Nuevo Cliente'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre Completo *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El nombre es requerido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Dirección',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: scoreController,
                        decoration: const InputDecoration(
                          labelText: 'Score (0-100)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            final score = double.tryParse(value);
                            if (score == null || score < 0 || score > 100) {
                              return 'Score debe estar entre 0 y 100';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: balanceController,
                        decoration: const InputDecoration(
                          labelText: 'Balance',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            final balance = double.tryParse(value);
                            if (balance == null) {
                              return 'Balance inválido';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notas',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final existing = isEditing ? client : null;
                await _saveClient(
                  existing,
                  nameController.text.trim(),
                  emailController.text.trim().isEmpty ? null : emailController.text.trim(),
                  phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
                  addressController.text.trim().isEmpty ? null : addressController.text.trim(),
                  double.tryParse(scoreController.text) ?? 0.0,
                  double.tryParse(balanceController.text) ?? 0.0,
                  notesController.text.trim().isEmpty ? null : notesController.text.trim(),
                );
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              }
            },
            child: Text(isEditing ? 'Actualizar' : 'Crear'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveClient(
    Client? existingClient,
    String name,
    String? email,
    String? phone,
    String? address,
    double score,
    double balance,
    String? notes,
  ) async {
    try {
      if (existingClient != null) {
        // Actualizar cliente existente
        final updatedClient = existingClient.copyWith(
          name: name,
          email: email,
          phone: phone,
          address: address,
          score: score,
          balance: balance,
          notes: notes,
        );
        await _clientService.updateClient(updatedClient);
        _showSuccessSnackBar('Cliente actualizado exitosamente');
      } else {
        // Crear nuevo cliente
        final newClient = Client(
          id: '',
          name: name,
          email: email,
          phone: phone,
          score: score,
          balance: balance,
          nextVisit: null,
          address: address,
          notes: notes,
        );
        await _clientService.createClient(newClient);
        _showSuccessSnackBar('Cliente creado exitosamente');
      }
      
      await _loadClients();
    } catch (e) {
      _showErrorSnackBar('Error al guardar cliente: $e');
    }
  }

  void _showDeleteClientDialog(Client client) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Cliente'),
        content: Text('¿Está seguro de eliminar a "${client.name}"?\n\nEsta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _deleteClient(client);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteClient(Client client) async {
    try {
      final success = await _clientService.deleteClient(client.id);
      if (success) {
        _showSuccessSnackBar('Cliente eliminado exitosamente');
        await _loadClients();
      } else {
        _showErrorSnackBar('No se pudo eliminar el cliente');
      }
    } catch (e) {
      _showErrorSnackBar('Error al eliminar cliente: $e');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
