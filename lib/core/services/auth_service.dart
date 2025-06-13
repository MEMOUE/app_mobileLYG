import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../constants/storage_keys.dart';
import '../../features/auth/models/auth_response_model.dart';
import '../../features/auth/models/user_model.dart';
import 'storage_service.dart';
import '../utils/enums.dart';

class AuthService {
  static Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}'),
        headers: ApiConstants.headers,
        body: jsonEncode({
          'email': email,
          'motDePasse': password,
        }),
      );
      
      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(jsonDecode(response.body));
        
        // Stocker les données d'authentification
        await StorageService.setString(StorageKeys.authToken, authResponse.token);
        await StorageService.setString(StorageKeys.refreshToken, authResponse.refreshToken);
        await StorageService.setString(StorageKeys.userJson, jsonEncode(authResponse.user.toJson()));
        
        return authResponse;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Erreur de connexion');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Erreur de connexion réseau');
      }
      rethrow;
    }
  }
  
  static Future<AuthResponse> register({
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
    try {
      final body = {
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'telephone': telephone,
        'motDePasse': motDePasse,
        'typeUtilisateur': typeUtilisateur.name,
      };
      
      // Ajouter les champs spécifiques selon le type
      if (adresse != null && adresse.isNotEmpty) body['adresse'] = adresse;
      if (ville != null && ville.isNotEmpty) body['ville'] = ville;
      if (codePostal != null && codePostal.isNotEmpty) body['codePostal'] = codePostal;
      if (numeroPermis != null && numeroPermis.isNotEmpty) body['numeroPermis'] = numeroPermis;
      if (nomEntreprise != null && nomEntreprise.isNotEmpty) body['nomEntreprise'] = nomEntreprise;
      if (numeroSiret != null && numeroSiret.isNotEmpty) body['numeroSiret'] = numeroSiret;
      
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.register}'),
        headers: ApiConstants.headers,
        body: jsonEncode(body),
      );
      
      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(jsonDecode(response.body));
        
        // Stocker les données d'authentification
        await StorageService.setString(StorageKeys.authToken, authResponse.token);
        await StorageService.setString(StorageKeys.refreshToken, authResponse.refreshToken);
        await StorageService.setString(StorageKeys.userJson, jsonEncode(authResponse.user.toJson()));
        
        return authResponse;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Erreur d\'inscription');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Erreur de connexion réseau');
      }
      rethrow;
    }
  }
  
  static Future<String?> getStoredToken() async {
    return StorageService.getString(StorageKeys.authToken);
  }
  
  static Future<UserModel?> getStoredUser() async {
    final userJson = StorageService.getString(StorageKeys.userJson);
    if (userJson != null) {
      try {
        return UserModel.fromJson(jsonDecode(userJson));
      } catch (e) {
        // Si erreur de parsing, on supprime les données corrompues
        await logout();
        return null;
      }
    }
    return null;
  }
  
  static Future<void> logout() async {
    await StorageService.remove(StorageKeys.authToken);
    await StorageService.remove(StorageKeys.refreshToken);
    await StorageService.remove(StorageKeys.userJson);
  }
  
  static Map<String, String> getAuthHeaders() {
    final token = StorageService.getString(StorageKeys.authToken);
    return {
      ...ApiConstants.headers,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
  
  static Future<bool> isTokenValid() async {
    final token = await getStoredToken();
    if (token == null) return false;
    
    try {
      // Test simple de validation du token
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/auth/validate'),
        headers: getAuthHeaders(),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}