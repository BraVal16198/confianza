import '../../domain/models/advisor.dart';

class AuthService {
  // Versión simplificada sin Firebase para debugging

  // Login mock para desarrollo (como en tu guía)
  Future<Advisor?> mockLogin({
    required String code,
    required String password,
  }) async {
    // Simular delay de red
    await Future.delayed(const Duration(seconds: 1));

    // Credenciales mock (como en tu ejemplo)
    if (code == 'A001' && password == '1234') {
      return const Advisor(
        code: 'A001',
        fullName: 'Asesor Confianza',
        email: 'asesor@confianza.com',
        phone: '+51987654321',
      );
    } else if (code == 'A002' && password == '5678') {
      return const Advisor(
        code: 'A002',
        fullName: 'María González',
        email: 'maria@confianza.com',
        phone: '+51987654322',
      );
    }
    
    throw Exception('Credenciales inválidas');
  }

  // Cerrar sesión
  Future<void> signOut() async {
    // Implementación simple
  }

  // Verificar si el usuario está autenticado
  bool get isAuthenticated => false; // Siempre false para esta versión simple
}

