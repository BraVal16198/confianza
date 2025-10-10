import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/advisor.dart';

class SessionManager {
  static SessionManager? _instance;
  Advisor? _currentAdvisor;
  SharedPreferences? _prefs;

  SessionManager._();

  static SessionManager get instance {
    _instance ??= SessionManager._();
    return _instance!;
  }

  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _loadSession();
  }

  Future<void> login(Advisor advisor) async {
    _currentAdvisor = advisor;
    await _saveSession();
  }

  Future<void> logout() async {
    _currentAdvisor = null;
    await _clearSession();
  }

  Advisor? get currentAdvisor => _currentAdvisor;

  bool get isLoggedIn => _currentAdvisor != null;

  Future<void> _saveSession() async {
    if (_prefs != null && _currentAdvisor != null) {
      await _prefs!.setString('advisor_code', _currentAdvisor!.code);
      await _prefs!.setString('advisor_name', _currentAdvisor!.fullName);
      await _prefs!.setString('advisor_email', _currentAdvisor!.email ?? '');
      await _prefs!.setString('advisor_phone', _currentAdvisor!.phone ?? '');
    }
  }

  Future<void> _loadSession() async {
    if (_prefs != null) {
      final code = _prefs!.getString('advisor_code');
      final name = _prefs!.getString('advisor_name');
      final email = _prefs!.getString('advisor_email');
      final phone = _prefs!.getString('advisor_phone');

      if (code != null && name != null) {
        _currentAdvisor = Advisor(
          code: code,
          fullName: name,
          email: email?.isEmpty == true ? null : email,
          phone: phone?.isEmpty == true ? null : phone,
        );
      }
    }
  }

  Future<void> _clearSession() async {
    if (_prefs != null) {
      await _prefs!.remove('advisor_code');
      await _prefs!.remove('advisor_name');
      await _prefs!.remove('advisor_email');
      await _prefs!.remove('advisor_phone');
    }
  }
}

