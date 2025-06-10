
// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'core/services/storage_service.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/client/providers/commande_provider.dart';
import 'features/chauffeur/providers/chauffeur_provider.dart';
import 'features/proprietaire/providers/proprietaire_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser le service de stockage
  await StorageService.init();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CommandeProvider()),
        ChangeNotifierProvider(create: (_) => ChauffeurProvider()),
        ChangeNotifierProvider(create: (_) => ProprietaireProvider()),
      ],
      child: const LanaYaGoApp(),
    ),
  );
}