import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/enums.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../providers/proprietaire_provider.dart';
import '../models/vehicule_model.dart';

class AddVehiculeScreen extends StatefulWidget {
  const AddVehiculeScreen({super.key});

  @override
  State<AddVehiculeScreen> createState() => _AddVehiculeScreenState();
}

class _AddVehiculeScreenState extends State<AddVehiculeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Contrôleurs pour les champs
  final _immatriculationController = TextEditingController();
  final _marqueController = TextEditingController();
  final _modeleController = TextEditingController();
  final _anneeController = TextEditingController();
  final _capacitePoidsController = TextEditingController();
  final _capaciteVolumeController = TextEditingController();
  final _numeroAssuranceController = TextEditingController();
  final _numeroCarteGriseController = TextEditingController();

  TypeVehicule? _selectedTypeVehicule;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un véhicule'),
        backgroundColor: AppColors.warning,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ProprietaireProvider>(
        builder: (context, proprietaireProvider, child) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                // Contenu scrollable
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // En-tête informatif
                        _buildInfoHeader(),
                        
                        const SizedBox(height: 24),
                        
                        // Informations générales
                        _buildGeneralInfoSection(),
                        
                        const SizedBox(height: 24),
                        
                        // Capacités
                        _buildCapacitySection(),
                        
                        const SizedBox(height: 24),
                        
                        // Type de véhicule
                        _buildVehicleTypeSection(),
                        
                        const SizedBox(height: 24),
                        
                        // Documents (optionnels)
                        _buildDocumentsSection(),
                        
                        const SizedBox(height: 32),
                        
                        // Message d'erreur
                        if (proprietaireProvider.error != null) ...[
                          _buildErrorMessage(proprietaireProvider.error!),
                          const SizedBox(height: 16),
                        ],
                      ],
                    ),
                  ),
                ),
                
                // Bouton fixe en bas
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: CustomButton(
                      text: 'Ajouter le véhicule',
                      isLoading: proprietaireProvider.isLoading,
                      onPressed: () => _handleAddVehicule(context, proprietaireProvider),
                      icon: Icons.add,
                      backgroundColor: AppColors.warning,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoHeader() {
    return Card(
      color: AppColors.warning.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: AppColors.warning,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ajout d\'un nouveau véhicule',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.warning,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Remplissez tous les champs obligatoires pour ajouter ce véhicule à votre flotte.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Informations générales'),
        const SizedBox(height: 16),
        
        CustomTextField(
          controller: _immatriculationController,
          labelText: 'Immatriculation *',
          prefixIcon: Icons.confirmation_number,
          validator: Validators.required,
          textCapitalization: TextCapitalization.characters,
          hintText: 'Ex: AA-123-BB',
        ),
        
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _marqueController,
                labelText: 'Marque *',
                prefixIcon: Icons.business,
                validator: Validators.required,
                textCapitalization: TextCapitalization.words,
                hintText: 'Ex: Mercedes',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                controller: _modeleController,
                labelText: 'Modèle *',
                prefixIcon: Icons.local_shipping,
                validator: Validators.required,
                textCapitalization: TextCapitalization.words,
                hintText: 'Ex: Sprinter',
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        CustomTextField(
          controller: _anneeController,
          labelText: 'Année *',
          prefixIcon: Icons.calendar_today,
          keyboardType: TextInputType.number,
          validator: _validateAnnee,
          hintText: 'Ex: 2020',
        ),
      ],
    );
  }

  Widget _buildCapacitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Capacités'),
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _capacitePoidsController,
                labelText: 'Capacité poids (tonnes) *',
                prefixIcon: Icons.scale,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: _validateCapacitePoids,
                hintText: 'Ex: 3.5',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                controller: _capaciteVolumeController,
                labelText: 'Capacité volume (m³) *',
                prefixIcon: Icons.inventory,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: _validateCapaciteVolume,
                hintText: 'Ex: 15.0',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVehicleTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Type de véhicule'),
        const SizedBox(height: 16),
        
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: TypeVehicule.values.map((type) {
              return RadioListTile<TypeVehicule>(
                title: Row(
                  children: [
                    Icon(type.icon, color: AppColors.warning, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            type.libelle,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${type.capaciteMaxPoids}t - ${type.capaciteMaxVolume}m³',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                value: type,
                groupValue: _selectedTypeVehicule,
                onChanged: (TypeVehicule? value) {
                  setState(() {
                    _selectedTypeVehicule = value;
                    // Auto-compléter les capacités selon le type
                    if (value != null) {
                      _capacitePoidsController.text = value.capaciteMaxPoids.toString();
                      _capaciteVolumeController.text = value.capaciteMaxVolume.toString();
                    }
                  });
                },
                activeColor: AppColors.warning,
              );
            }).toList(),
          ),
        ),
        
        if (_selectedTypeVehicule == null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Veuillez sélectionner un type de véhicule',
              style: TextStyle(
                color: AppColors.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDocumentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Documents (optionnel)'),
        const SizedBox(height: 16),
        
        CustomTextField(
          controller: _numeroAssuranceController,
          labelText: 'Numéro d\'assurance',
          prefixIcon: Icons.security,
          textCapitalization: TextCapitalization.characters,
          hintText: 'Numéro de police d\'assurance',
        ),
        
        const SizedBox(height: 16),
        
        CustomTextField(
          controller: _numeroCarteGriseController,
          labelText: 'Numéro carte grise',
          prefixIcon: Icons.credit_card,
          textCapitalization: TextCapitalization.characters,
          hintText: 'Numéro du certificat d\'immatriculation',
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.warning,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
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

  String? _validateAnnee(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'L\'année est obligatoire';
    }
    
    final int? annee = int.tryParse(value.trim());
    if (annee == null) {
      return 'Année invalide';
    }
    
    final int currentYear = DateTime.now().year;
    if (annee < 1990 || annee > currentYear + 1) {
      return 'L\'année doit être entre 1990 et ${currentYear + 1}';
    }
    
    return null;
  }

  String? _validateCapacitePoids(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La capacité de poids est obligatoire';
    }
    
    final double? capacite = double.tryParse(value.trim());
    if (capacite == null || capacite <= 0) {
      return 'La capacité doit être supérieure à 0';
    }
    
    return null;
  }

  String? _validateCapaciteVolume(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La capacité de volume est obligatoire';
    }
    
    final double? capacite = double.tryParse(value.trim());
    if (capacite == null || capacite <= 0) {
      return 'La capacité doit être supérieure à 0';
    }
    
    return null;
  }

  Future<void> _handleAddVehicule(BuildContext context, ProprietaireProvider proprietaireProvider) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (_selectedTypeVehicule == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner un type de véhicule'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Effacer les erreurs précédentes
    proprietaireProvider.clearError();

    final request = CreateVehiculeRequest(
      immatriculation: _immatriculationController.text.trim(),
      marque: _marqueController.text.trim(),
      modele: _modeleController.text.trim(),
      annee: int.parse(_anneeController.text.trim()),
      capacitePoids: double.parse(_capacitePoidsController.text.trim()),
      capaciteVolume: double.parse(_capaciteVolumeController.text.trim()),
      typeVehicule: _selectedTypeVehicule!,
      numeroAssurance: _numeroAssuranceController.text.trim().isNotEmpty 
          ? _numeroAssuranceController.text.trim() : null,
      numeroCarteGrise: _numeroCarteGriseController.text.trim().isNotEmpty 
          ? _numeroCarteGriseController.text.trim() : null,
    );

    final success = await proprietaireProvider.addVehicule(request);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Véhicule ajouté avec succès !'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _immatriculationController.dispose();
    _marqueController.dispose();
    _modeleController.dispose();
    _anneeController.dispose();
    _capacitePoidsController.dispose();
    _capaciteVolumeController.dispose();
    _numeroAssuranceController.dispose();
    _numeroCarteGriseController.dispose();
    super.dispose();
  }
}