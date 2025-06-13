import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/enums.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../providers/auth_provider.dart';
import '../../client/screens/client_home_screen.dart';
import '../../chauffeur/screens/chauffeur_home_screen.dart';
import '../../proprietaire/screens/proprietaire_home_screen.dart';

class RegisterScreen extends StatefulWidget {
  final TypeUtilisateur userType;
  
  const RegisterScreen({
    super.key,
    required this.userType,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  
  // Contrôleurs pour les champs communs
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // Contrôleurs pour les champs spécifiques
  final _adresseController = TextEditingController();
  final _villeController = TextEditingController();
  final _codePostalController = TextEditingController();
  final _numeroPermisController = TextEditingController();
  final _nomEntrepriseController = TextEditingController();
  final _numeroSiretController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header fixe
            _buildHeader(context),
            
            // Formulaire scrollable
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Titre
                      _buildTitle(context),
                      
                      const SizedBox(height: 32),
                      
                      // Champs communs
                      _buildCommonFields(),
                      
                      // Champs spécifiques selon le type
                      _buildSpecificFields(),
                      
                      const SizedBox(height: 32),
                      
                      // Bouton d'inscription
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                          return Column(
                            children: [
                              CustomButton(
                                text: AppStrings.signUp,
                                isLoading: authProvider.isLoading,
                                onPressed: () => _handleRegister(context, authProvider),
                                icon: Icons.person_add,
                                backgroundColor: widget.userType.color,
                              ),
                              
                              // Affichage des erreurs
                              if (authProvider.error != null) ...[
                                const SizedBox(height: 16),
                                _buildErrorMessage(authProvider.error!),
                              ],
                            ],
                          );
                        },
                      ),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.userType.color.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: widget.userType.color.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            style: IconButton.styleFrom(
              backgroundColor: widget.userType.color.withOpacity(0.1),
              foregroundColor: widget.userType.color,
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.userType.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              widget.userType.icon,
              color: widget.userType.color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userType.libelle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: widget.userType.color,
                  ),
                ),
                Text(
                  widget.userType.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.register,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Créez votre compte ${widget.userType.libelle.toLowerCase()}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCommonFields() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _prenomController,
                labelText: AppStrings.firstName,
                prefixIcon: Icons.person_outline,
                validator: Validators.name,
                textCapitalization: TextCapitalization.words,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                controller: _nomController,
                labelText: AppStrings.lastName,
                prefixIcon: Icons.person_outline,
                validator: Validators.name,
                textCapitalization: TextCapitalization.words,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        CustomTextField(
          controller: _emailController,
          labelText: AppStrings.email,
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: Validators.email,
        ),
        
        const SizedBox(height: 16),
        
        CustomTextField(
          controller: _telephoneController,
          labelText: AppStrings.phone,
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: Validators.phone,
          hintText: '+221 XX XXX XX XX',
        ),
        
        const SizedBox(height: 16),
        
        CustomTextField(
          controller: _passwordController,
          labelText: AppStrings.password,
          prefixIcon: Icons.lock_outline,
          obscureText: true,
          validator: Validators.password,
        ),
        
        const SizedBox(height: 16),
        
        CustomTextField(
          controller: _confirmPasswordController,
          labelText: AppStrings.confirmPassword,
          prefixIcon: Icons.lock_outline,
          obscureText: true,
          validator: (value) => Validators.confirmPassword(value, _passwordController.text),
        ),
      ],
    );
  }

  Widget _buildSpecificFields() {
    switch (widget.userType) {
      case TypeUtilisateur.CLIENT:
        return _buildClientFields();
      case TypeUtilisateur.CHAUFFEUR:
        return _buildChauffeurFields();
      case TypeUtilisateur.PROPRIETAIRE_VEHICULE:
        return _buildOwnerFields();
    }
  }

  Widget _buildClientFields() {
    return Column(
      children: [
        const SizedBox(height: 24),
        
        _buildSectionTitle('Informations d\'adresse (optionnel)'),
        
        const SizedBox(height: 16),
        
        CustomTextField(
          controller: _adresseController,
          labelText: AppStrings.address,
          prefixIcon: Icons.location_on_outlined,
          textCapitalization: TextCapitalization.words,
        ),
        
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomTextField(
                controller: _villeController,
                labelText: AppStrings.city,
                prefixIcon: Icons.location_city_outlined,
                textCapitalization: TextCapitalization.words,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                controller: _codePostalController,
                labelText: AppStrings.postalCode,
                keyboardType: TextInputType.number,
                validator: Validators.postalCode,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChauffeurFields() {
    return Column(
      children: [
        const SizedBox(height: 24),
        
        _buildSectionTitle('Informations de conduite'),
        
        const SizedBox(height: 16),
        
        CustomTextField(
          controller: _numeroPermisController,
          labelText: AppStrings.licenseNumber,
          prefixIcon: Icons.credit_card_outlined,
          validator: Validators.licenseNumber,
          textCapitalization: TextCapitalization.characters,
        ),
      ],
    );
  }

  Widget _buildOwnerFields() {
    return Column(
      children: [
        const SizedBox(height: 24),
        
        _buildSectionTitle('Informations de l\'entreprise'),
        
        const SizedBox(height: 16),
        
        CustomTextField(
          controller: _nomEntrepriseController,
          labelText: AppStrings.companyName,
          prefixIcon: Icons.business_outlined,
          validator: Validators.required,
          textCapitalization: TextCapitalization.words,
        ),
        
        const SizedBox(height: 16),
        
        CustomTextField(
          controller: _numeroSiretController,
          labelText: AppStrings.siretNumber,
          prefixIcon: Icons.numbers_outlined,
          validator: Validators.siretNumber,
          textCapitalization: TextCapitalization.characters,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Expanded(
          child: Divider(color: AppColors.divider),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: AppColors.divider),
        ),
      ],
    );
  }

  Widget _buildErrorMessage(String error) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRegister(BuildContext context, AuthProvider authProvider) async {
    authProvider.clearError();
    
    if (_formKey.currentState!.validate()) {
      final success = await authProvider.register(
        nom: _nomController.text.trim(),
        prenom: _prenomController.text.trim(),
        email: _emailController.text.trim(),
        telephone: _telephoneController.text.trim(),
        motDePasse: _passwordController.text,
        typeUtilisateur: widget.userType,
        adresse: _adresseController.text.trim().isNotEmpty 
            ? _adresseController.text.trim() : null,
        ville: _villeController.text.trim().isNotEmpty 
            ? _villeController.text.trim() : null,
        codePostal: _codePostalController.text.trim().isNotEmpty 
            ? _codePostalController.text.trim() : null,
        numeroPermis: _numeroPermisController.text.trim().isNotEmpty 
            ? _numeroPermisController.text.trim() : null,
        nomEntreprise: _nomEntrepriseController.text.trim().isNotEmpty 
            ? _nomEntrepriseController.text.trim() : null,
        numeroSiret: _numeroSiretController.text.trim().isNotEmpty 
            ? _numeroSiretController.text.trim() : null,
      );
      
      if (success && mounted) {
        _navigateToHome(widget.userType);
      }
    }
  }

  void _navigateToHome(TypeUtilisateur userType) {
    Widget homeScreen;
    switch (userType) {
      case TypeUtilisateur.CLIENT:
        homeScreen = const ClientHomeScreen();
        break;
      case TypeUtilisateur.CHAUFFEUR:
        homeScreen = const ChauffeurHomeScreen();
        break;
      case TypeUtilisateur.PROPRIETAIRE_VEHICULE:
        homeScreen = const ProprietaireHomeScreen();
        break;
    }

    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => homeScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _adresseController.dispose();
    _villeController.dispose();
    _codePostalController.dispose();
    _numeroPermisController.dispose();
    _nomEntrepriseController.dispose();
    _numeroSiretController.dispose();
    super.dispose();
  }
}