/* import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../constants/storage_keys.dart';
import '../../features/auth/models/auth_response_model.dart';
import '../../features/auth/models/user_model.dart';
import 'storage_service.dart';

class AuthService {
  static Future<AuthResponse> login(String email, String password) async {
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
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.register}'),
      headers: ApiConstants.headers,
      body: jsonEncode({
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'telephone': telephone,
        'motDePasse': motDePasse,
        'typeUtilisateur': typeUtilisateur.name,
        if (adresse != null) 'adresse': adresse,
        if (ville != null) 'ville': ville,
        if (codePostal != null) 'codePostal': codePostal,
        if (numeroPermis != null) 'numeroPermis': numeroPermis,
        if (nomEntreprise != null) 'nomEntreprise': nomEntreprise,
        if (numeroSiret != null) 'numeroSiret': numeroSiret,
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
      throw Exception(error['message'] ?? 'Erreur d\'inscription');
    }
  }
  
  static Future<String?> getStoredToken() async {
    return StorageService.getString(StorageKeys.authToken);
  }
  
  static Future<UserModel?> getStoredUser() async {
    final userJson = StorageService.getString(StorageKeys.userJson);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
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
} */