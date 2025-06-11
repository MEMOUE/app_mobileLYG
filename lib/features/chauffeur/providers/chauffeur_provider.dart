/* import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/location_service.dart';
import '../../client/models/commande_model.dart';

class ChauffeurProvider extends ChangeNotifier {
  bool _isAvailable = true;
  bool _isOnline = false;
  List<CommandeModel> _availableCommandes = [];
  List<CommandeModel> _myCommandes = [];
  bool _isLoading = false;
  String? _error;

  bool get isAvailable => _isAvailable;
  bool get isOnline => _isOnline;
  List<CommandeModel> get availableCommandes => _availableCommandes;
  List<CommandeModel> get myCommandes => _myCommandes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> toggleAvailability() async {
    _isAvailable = !_isAvailable;
    notifyListeners();
    
    // TODO: Envoyer la disponibilité au serveur
  }

  Future<void> goOnline() async {
    try {
      final position = await LocationService.getCurrentPosition();
      if (position != null) {
        await _updatePosition(position.latitude, position.longitude);
        _isOnline = true;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Impossible de se mettre en ligne: $e';
      notifyListeners();
    }
  }

  Future<void> goOffline() async {
    _isOnline = false;
    notifyListeners();
  }

  Future<void> _updatePosition(double latitude, double longitude) async {
    try {
      final user = await AuthService.getStoredUser();
      if (user == null) return;

      await http.put(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.updatePosition}/${user.id}/position?latitude=$latitude&longitude=$longitude'),
        headers: AuthService.getAuthHeaders(),
      );
    } catch (e) {
      debugPrint('Erreur lors de la mise à jour de position: $e');
    }
  }

  Future<void> loadAvailableCommandes() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.commandesStatut}/EN_ATTENTE'),
        headers: AuthService.getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _availableCommandes = data.map((json) => CommandeModel.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadMyCommandes() async {
    try {
      final user = await AuthService.getStoredUser();
      if (user == null) return;

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.commandesChauffeur}/${user.id}'),
        headers: AuthService.getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _myCommandes = data.map((json) => CommandeModel.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
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