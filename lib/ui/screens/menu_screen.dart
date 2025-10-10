import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/session_manager.dart';
import '../../domain/models/menu_option.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final advisor = SessionManager.instance.currentAdvisor;
    
    final menuOptions = [
      MenuOption(
        title: 'Portafolio',
        icon: Icons.dashboard,
        route: '/portfolio',
        color: Colors.blue,
      ),
      MenuOption(
        title: 'Clientes',
        icon: Icons.people,
        route: '/clients',
        color: Colors.green,
      ),
      MenuOption(
        title: 'Tareas',
        icon: Icons.assignment,
        route: '/tasks',
        color: Colors.orange,
      ),
      MenuOption(
        title: 'Cobranza',
        icon: Icons.payment,
        route: '/collections',
        color: Colors.red,
      ),
      MenuOption(
        title: 'Solicitudes',
        icon: Icons.description,
        route: '/requests',
        color: Colors.purple,
      ),
      MenuOption(
        title: 'Reportes',
        icon: Icons.analytics,
        route: '/reports',
        color: Colors.teal,
      ),
      MenuOption(
        title: 'Visitas',
        icon: Icons.location_on,
        route: '/visits',
        color: Colors.indigo,
      ),
      MenuOption(
        title: 'Configuración',
        icon: Icons.settings,
        route: '/settings',
        color: Colors.grey,
      ),
      MenuOption(
        title: 'Base de Datos',
        icon: Icons.storage,
        route: '/database',
        color: Colors.purple,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('ConfianzaMicro'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header con información del asesor
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.blue.shade800],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bienvenido',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            advisor?.fullName ?? 'Sin sesión',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Código: ${advisor?.code ?? 'N/A'}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Grid de opciones del menú
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemCount: menuOptions.length,
                itemBuilder: (context, index) {
                  final option = menuOptions[index];
                  return _buildMenuCard(context, option);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, MenuOption option) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _navigateToRoute(context, option.route),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                option.color!.withValues(alpha: 0.1),
                option.color!.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: option.color!.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  option.icon,
                  size: 32,
                  color: option.color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                option.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: option.color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToRoute(BuildContext context, String route) {
    // Navegar a las rutas reales
    context.go(route);
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Está seguro que desea cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await SessionManager.instance.logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}
