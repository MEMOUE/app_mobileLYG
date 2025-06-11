/* import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../../core/services/auth_service.dart';
import '../models/commande_model.dart';
import '../../../core/utils/enums.dart';

class CommandeProvider extends ChangeNotifier {
  List<CommandeModel> _commandes = [];
  List<CommandeModel> _availableCommandes = [];
  bool _isLoading = false;
  String? _error;

  List<CommandeModel> get commandes => _commandes;
  List<CommandeModel> get availableCommandes => _availableCommandes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Charger mes commandes (client ou chauffeur)
  Future<void> loadMyCommandes() async {
    _setLoading(true);
    _clearError();

    try {
      final user = await AuthService.getStoredUser();
      if (user == null) throw Exception('Utilisateur non connecté');

      String endpoint;
      if (user.typeUtilisateur == TypeUtilisateur.CLIENT) {
        endpoint = '${ApiConstants.baseUrl}${ApiConstants.commandesClient}/${user.id}';
      } else if (user.typeUtilisateur == TypeUtilisateur.CHAUFFEUR) {
        endpoint = '${ApiConstants.baseUrl}${ApiConstants.commandesChauffeur}/${user.id}';
      } else {
        throw Exception('Type d\'utilisateur non supporté');
      }

      final response = await http.get(
        Uri.parse(endpoint),
        headers: AuthService.getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _commandes = data.map((json) => CommandeModel.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception('Erreur lors du chargement des commandes');
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Créer une nouvelle commande (client)
  Future<bool> createCommande(CreateCommandeRequest request) async {
    _setLoading(true);
    _clearError();

    try {
      final user = await AuthService.getStoredUser();
      if (user == null) throw Exception('Utilisateur non connecté');

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.commandesClient}/${user.id}'),
        headers: AuthService.getAuthHeaders(),
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final CommandeModel newCommande = CommandeModel.fromJson(jsonDecode(response.body));
        _commandes.insert(0, newCommande);
        notifyListeners();
        return true;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Erreur lors de la création de la commande');
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Accepter une commande (chauffeur)
  Future<bool> acceptCommande(int commandeId) async {
    try {
      final user = await AuthService.getStoredUser();
      if (user == null) throw Exception('Utilisateur non connecté');

      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.commandes}/$commandeId/accepter?chauffeurId=${user.id}'),
        headers: AuthService.getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final CommandeModel updatedCommande = CommandeModel.fromJson(jsonDecode(response.body));
        
        // Retirer de la liste des commandes disponibles
        _availableCommandes.removeWhere((c) => c.id == commandeId);
        
        // Ajouter à mes commandes
        _commandes.insert(0, updatedCommande);
        
        notifyListeners();
        return true;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Erreur lors de l\'acceptation');
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Changer le statut d'une commande
  Future<bool> updateCommandeStatus(int commandeId, StatutCommande newStatus) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.commandes}/$commandeId/statut?statut=${newStatus.name}'),
        headers: AuthService.getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final CommandeModel updatedCommande = CommandeModel.fromJson(jsonDecode(response.body));
        
        // Mettre à jour dans la liste
        final index = _commandes.indexWhere((c) => c.id == commandeId);
        if (index != -1) {
          _commandes[index] = updatedCommande;
          notifyListeners();
        }
        
        return true;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Erreur lors de la mise à jour');
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Charger les commandes disponibles (chauffeur)
  Future<void> loadAvailableCommandes() async {
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
    }
  }

  // Évaluer une commande
  Future<bool> evaluateCommande(int commandeId, double note, String? commentaire) async {
    try {
      final user = await AuthService.getStoredUser();
      if (user == null) throw Exception('Utilisateur non connecté');

      String typeEvaluateur = user.typeUtilisateur == TypeUtilisateur.CLIENT ? 'CLIENT' : 'CHAUFFEUR';

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.commandes}/$commandeId/evaluer'),
        headers: AuthService.getAuthHeaders(),
        body: jsonEncode({
          'note': note,
          'commentaire': commentaire,
          'typeEvaluateur': typeEvaluateur,
        }),
      );

      if (response.statusCode == 200) {
        final CommandeModel updatedCommande = CommandeModel.fromJson(jsonDecode(response.body));
        
        final index = _commandes.indexWhere((c) => c.id == commandeId);
        if (index != -1) {
          _commandes[index] = updatedCommande;
          notifyListeners();
        }
        
        return true;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Erreur lors de l\'évaluation');
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
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
} */