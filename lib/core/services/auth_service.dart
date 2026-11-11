import '../../domain/models/advisor.dart';

/// Autenticación mock para la demo de portafolio (sin backend).
class AuthService {
  Future<Advisor?> mockLogin({
    required String code,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (code == 'A001' && password == '1234') {
      return const Advisor(
        code: 'A001',
        fullName: 'Asesor Confianza',
        email: 'asesor@confianza.com',
        phone: '+51987654321',
      );
    }
    if (code == 'A002' && password == '5678') {
      return const Advisor(
        code: 'A002',
        fullName: 'María González',
        email: 'maria@confianza.com',
        phone: '+51987654322',
      );
    }

    throw Exception('Credenciales inválidas');
  }

  Future<void> signOut() async {}

  bool get isAuthenticated => false;
}
