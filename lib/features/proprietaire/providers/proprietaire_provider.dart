import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../../core/services/auth_service.dart';
import '../models/vehicule_model.dart';
import '../../client/models/commande_model.dart';
import '../../../core/utils/enums.dart';

class ProprietaireProvider extends ChangeNotifier {
  List<VehiculeModel> _vehicules = [];
  List<CommandeModel> _commandes = [];
  Map<String, dynamic>? _statistics;
  bool _isLoading = false;
  String? _error;

  List<VehiculeModel> get vehicules => _vehicules;
  List<CommandeModel> get commandes => _commandes;
  Map<String, dynamic>? get statistics => _statistics;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadVehicules() async {
    _setLoading(true);
    _clearError();

    try {
      final user = await AuthService.getStoredUser();
      if (user == null) throw Exception('Utilisateur non connecté');

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.vehiculesProprietaire}/${user.id}'),
        headers: AuthService.getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _vehicules = data.map((json) => VehiculeModel.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addVehicule(CreateVehiculeRequest request) async {
    try {
      final user = await AuthService.getStoredUser();
      if (user == null) throw Exception('Utilisateur non connecté');

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.vehiculesProprietaire}/${user.id}'),
        headers: AuthService.getAuthHeaders(),
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final VehiculeModel newVehicule = VehiculeModel.fromJson(jsonDecode(response.body));
        _vehicules.insert(0, newVehicule);
        notifyListeners();
        return true;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Erreur lors de l\'ajout du véhicule');
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> toggleVehiculeAvailability(int vehiculeId, bool available) async {
    try {
      await http.put(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.vehicules}/$vehiculeId/disponibilite?disponible=$available'),
        headers: AuthService.getAuthHeaders(),
      );

      // Mettre à jour localement
      final index = _vehicules.indexWhere((v) => v.id == vehiculeId);
      if (index != -1) {
        _vehicules[index] = _vehicules[index].copyWith(disponible: available);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadStatistics() async {
    try {
      // TODO: Implement statistics loading from backend
      _statistics = {
        'totalVehicules': _vehicules.length,
        'vehiculesDisponibles': _vehicules.where((v) => v.disponible).length,
        'commandesEnCours': _commandes.where((c) => c.statut.isActive).length,
        'chiffreAffairesMois': 15420.50,
      };
      notifyListeners();
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

  void clearError() {
    _clearError();
    notifyListeners();
  }
}