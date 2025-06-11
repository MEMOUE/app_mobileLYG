/* import 'package:flutter/material.dart';
import '../../../core/utils/enums.dart';
import '../widgets/user_type_card.dart';
import 'register_screen.dart';

class UserTypeSelectionScreen extends StatelessWidget {
  const UserTypeSelectionScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                '🚚 LanaYaGo',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Choisissez votre profil',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sélectionnez le type de compte qui correspond à votre activité',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),
              
              Expanded(
                child: Column(
                  children: [
                    UserTypeCard(
                      icon: Icons.person,
                      title: 'Client',
                      description: 'Je veux faire transporter mes marchandises',
                      color: Colors.blue,
                      onTap: () => _navigateToRegister(context, TypeUtilisateur.CLIENT),
                    ),
                    const SizedBox(height: 16),
                    
                    UserTypeCard(
                      icon: Icons.local_shipping,
                      title: 'Chauffeur',
                      description: 'Je veux transporter des marchandises',
                      color: Colors.green,
                      onTap: () => _navigateToRegister(context, TypeUtilisateur.CHAUFFEUR),
                    ),
                    const SizedBox(height: 16),
                    
                    UserTypeCard(
                      icon: Icons.business,
                      title: 'Propriétaire de Flotte',
                      description: 'Je gère une flotte de véhicules',
                      color: Colors.orange,
                      onTap: () => _navigateToRegister(context, TypeUtilisateur.PROPRIETAIRE_VEHICULE),
                    ),
                  ],
                ),
              ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Déjà un compte ? ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Se connecter'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _navigateToRegister(BuildContext context, TypeUtilisateur type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterScreen(userType: type),
      ),
    );
  }
} */