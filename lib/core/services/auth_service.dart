// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/advisor.dart';

class AuthService {
  // Comentamos Firebase temporalmente para debugging
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream del usuario actual (comentado temporalmente)
  // Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Usuario actual (comentado temporalmente)
  // User? get currentUser => _auth.currentUser;

  // Login con email y contraseña (comentado temporalmente)
  /*
  Future<Advisor?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        // Obtener datos del asesor desde Firestore
        final advisorDoc = await _firestore
            .collection('advisors')
            .doc(result.user!.uid)
            .get();

        if (advisorDoc.exists) {
          final data = advisorDoc.data()!;
          return Advisor(
            code: data['code'] ?? '',
            fullName: data['fullName'] ?? '',
            email: data['email'],
            phone: data['phone'],
          );
        }
      }
      return null;
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }
  */

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

  // Registro de nuevo asesor (comentado temporalmente)
  /*
  Future<Advisor?> registerAdvisor({
    required String code,
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        // Guardar datos del asesor en Firestore
        await _firestore.collection('advisors').doc(result.user!.uid).set({
          'code': code,
          'fullName': fullName,
          'email': email,
          'phone': phone,
          'createdAt': FieldValue.serverTimestamp(),
        });

        return Advisor(
          code: code,
          fullName: fullName,
          email: email,
          phone: phone,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Error al registrar asesor: $e');
    }
  }
  */

  // Cerrar sesión (comentado temporalmente)
  // Future<void> signOut() async {
  //   await _auth.signOut();
  // }

  // Verificar si el usuario está autenticado (comentado temporalmente)
  // bool get isAuthenticated => _auth.currentUser != null;
}
