import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../ui/screens/splash_screen.dart';
import '../../ui/screens/login_screen.dart';
import '../../ui/screens/menu_screen.dart';
import '../../ui/screens/clients_screen.dart';
import '../../ui/screens/tasks_screen.dart';
import '../../ui/screens/portfolio_screen.dart';
import '../../ui/screens/database_info_screen.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: '/splash',
    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Login Screen
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      
      // Menu Screen
      GoRoute(
        path: '/menu',
        name: 'menu',
        builder: (context, state) => const MenuScreen(),
      ),
      
      // Portfolio Screen
      GoRoute(
        path: '/portfolio',
        name: 'portfolio',
        builder: (context, state) => const PortfolioScreen(),
      ),
      
      // Clients Screen
      GoRoute(
        path: '/clients',
        name: 'clients',
        builder: (context, state) => const ClientsScreen(),
      ),
      
      // Tasks Screen
      GoRoute(
        path: '/tasks',
        name: 'tasks',
        builder: (context, state) => const TasksScreen(),
      ),
      
      // Stub routes for other menu options
      GoRoute(
        path: '/collections',
        name: 'collections',
        builder: (context, state) => _buildStubScreen('Cobranza', Colors.red, Icons.payment),
      ),
      
      GoRoute(
        path: '/requests',
        name: 'requests',
        builder: (context, state) => _buildStubScreen('Solicitudes', Colors.purple, Icons.description),
      ),
      
      GoRoute(
        path: '/reports',
        name: 'reports',
        builder: (context, state) => _buildStubScreen('Reportes', Colors.teal, Icons.analytics),
      ),
      
      GoRoute(
        path: '/visits',
        name: 'visits',
        builder: (context, state) => _buildStubScreen('Visitas', Colors.indigo, Icons.location_on),
      ),
      
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => _buildStubScreen('Configuración', Colors.grey, Icons.settings),
      ),
      
      // Base de datos
      GoRoute(
        path: '/database',
        name: 'database',
        builder: (context, state) => const DatabaseInfoScreen(),
      ),
    ],
  );

  static GoRouter get router => _router;

  static Widget _buildStubScreen(String title, Color color, IconData icon) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color,
        foregroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/menu'),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: color,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Funcionalidad en desarrollo',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
