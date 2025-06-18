 import 'package:flutter/material.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/user_type_selection_screen.dart';
import '../features/client/screens/client_home_screen.dart';
import '../features/chauffeur/screens/chauffeur_home_screen.dart';
import '../features/proprietaire/screens/proprietaire_home_screen.dart';
import '../features/shared/screens/profile_screen.dart';
import 'route_names.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      
      case RouteNames.userTypeSelection:
        return MaterialPageRoute(builder: (_) => const UserTypeSelectionScreen());
      
      case RouteNames.clientHome:
        return MaterialPageRoute(builder: (_) => const ClientHomeScreen());
      
      case RouteNames.chauffeurHome:
        return MaterialPageRoute(builder: (_) => const ChauffeurHomeScreen());
      
      case RouteNames.proprietaireHome:
        return MaterialPageRoute(builder: (_) => const ProprietaireHomeScreen());
      
      case RouteNames.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Page non trouvée: ${settings.name}'),
            ),
          ),
        );
    }
  }
} 