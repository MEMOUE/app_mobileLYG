/* import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/enums.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../providers/auth_provider.dart';
import 'user_type_selection_screen.dart';
import '../../../routes/route_names.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                
                // Logo et titre
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.local_shipping,
                        size: 80,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '🚚 LanaYaGo',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Transport et Livraison',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 60),
                
                Text(
                  'Connexion',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Connectez-vous à votre compte',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Champ email
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  prefixIcon: Icons.email,
                  validator: Validators.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                
                // Champ mot de passe
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Mot de passe',
                  prefixIcon: Icons.lock,
                  obscureText: true,
                  validator: Validators.password,
                ),
                const SizedBox(height: 24),
                
                // Bouton de connexion
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return CustomButton(
                      text: 'Se connecter',
                      isLoading: authProvider.isLoading,
                      onPressed: () => _handleLogin(context, authProvider),
                    );
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Lien mot de passe oublié
                Center(
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implement forgot password
                    },
                    child: const Text('Mot de passe oublié ?'),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Lien vers inscription
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Pas encore de compte ?',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserTypeSelectionScreen(),
                            ),
                          );
                        },
                        child: const Text('Créer un compte'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin(BuildContext context, AuthProvider authProvider) async {
    if (_formKey.currentState!.validate()) {
      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      
      if (success && mounted) {
        final userType = authProvider.currentUser!.typeUtilisateur;
        
        String route;
        switch (userType) {
          case TypeUtilisateur.CLIENT:
            route = RouteNames.clientHome;
            break;
          case TypeUtilisateur.CHAUFFEUR:
            route = RouteNames.chauffeurHome;
            break;
          case TypeUtilisateur.PROPRIETAIRE_VEHICULE:
            route = RouteNames.proprietaireHome;
            break;
        }
        
        Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
      } else if (authProvider.error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
} */