class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:8080/api';
  static const String wsUrl = 'ws://localhost:8080/ws';
  
  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  
  // Commandes endpoints
  static const String commandes = '/commandes';
  static const String commandesClient = '/commandes/client';
  static const String commandesChauffeur = '/commandes/chauffeur';
  static const String commandesStatut = '/commandes/statut';
  
  // Véhicules endpoints
  static const String vehicules = '/vehicules';
  static const String vehiculesProprietaire = '/vehicules/proprietaire';
  static const String vehiculesDisponibles = '/vehicules/disponibles';
  
  // Géolocalisation endpoints
  static const String geolocation = '/geolocation';
  static const String updatePosition = '/geolocation/chauffeur';
  static const String calculateDistance = '/geolocation/distance';
  
  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}