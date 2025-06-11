/* import 'package:flutter/foundation.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/utils/enums.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final user = await AuthService.getStoredUser();
    if (user != null) {
      _currentUser = user;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final authResponse = await AuthService.login(email, password);
      _currentUser = authResponse.user;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register({
    required String nom,
    required String prenom,
    required String email,
    required String telephone,
    required String motDePasse,
    required TypeUtilisateur typeUtilisateur,
    String? adresse,
    String? ville,
    String? codePostal,
    String? numeroPermis,
    String? nomEntreprise,
    String? numeroSiret,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final authResponse = await AuthService.register(
        nom: nom,
        prenom: prenom,
        email: email,
        telephone: telephone,
        motDePasse: motDePasse,
        typeUtilisateur: typeUtilisateur,
        adresse: adresse,
        ville: ville,
        codePostal: codePostal,
        numeroPermis: numeroPermis,
        nomEntreprise: nomEntreprise,
        numeroSiret: numeroSiret,
      );
      _currentUser = authResponse.user;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    _currentUser = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
 */