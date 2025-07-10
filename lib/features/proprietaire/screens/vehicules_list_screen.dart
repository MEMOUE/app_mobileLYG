import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../providers/proprietaire_provider.dart';
import '../widgets/vehicule_card.dart';
import 'add_vehicule_screen.dart';

class VehiculesListScreen extends StatefulWidget {
  const VehiculesListScreen({super.key});

  @override
  State<VehiculesListScreen> createState() => _VehiculesListScreenState();
}

class _VehiculesListScreenState extends State<VehiculesListScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les véhicules au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProprietaireProvider>().loadVehicules();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Véhicules'),
        backgroundColor: AppColors.warning,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddVehiculeScreen(),
                ),
              ).then((_) {
                // Recharger la liste après ajout
                context.read<ProprietaireProvider>().loadVehicules();
              });
            },
            tooltip: 'Ajouter un véhicule',
          ),
        ],
      ),
      body: Consumer<ProprietaireProvider>(
        builder: (context, proprietaireProvider, child) {
          if (proprietaireProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.warning,
              ),
            );
          }

          if (proprietaireProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erreur de chargement',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    proprietaireProvider.error!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      proprietaireProvider.loadVehicules();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Réessayer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warning,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          if (proprietaireProvider.vehicules.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            color: AppColors.warning,
            onRefresh: () async {
              await proprietaireProvider.loadVehicules();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: proprietaireProvider.vehicules.length,
              itemBuilder: (context, index) {
                final vehicule = proprietaireProvider.vehicules[index];
                
                return VehiculeCard(
                  vehicule: vehicule,
                  onTap: () {
                    _showVehiculeDetails(context, vehicule);
                  },
                  onToggleDisponibilite: () {
                    _toggleDisponibilite(context, proprietaireProvider, vehicule);
                  },
                  onEdit: () {
                    _editVehicule(context, vehicule);
                  },
                  onDelete: () {
                    _confirmDeleteVehicule(context, proprietaireProvider, vehicule);
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddVehiculeScreen(),
            ),
          ).then((_) {
            // Recharger la liste après ajout
            context.read<ProprietaireProvider>().loadVehicules();
          });
        },
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
        backgroundColor: AppColors.warning,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.garage_outlined,
              size: 80,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Aucun véhicule',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Vous n\'avez pas encore ajouté de véhicule à votre flotte.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddVehiculeScreen(),
                  ),
                ).then((_) {
                  // Recharger la liste après ajout
                  context.read<ProprietaireProvider>().loadVehicules();
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Ajouter mon premier véhicule'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.warning,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showVehiculeDetails(BuildContext context, vehicule) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle de drag
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Titre
              Text(
                'Détails du véhicule',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              // Contenu scrollable
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DetailSection(
                        title: 'Informations générales',
                        items: [
                          _DetailItem('Immatriculation', vehicule.immatriculation),
                          _DetailItem('Marque', vehicule.marque),
                          _DetailItem('Modèle', vehicule.modele),
                          _DetailItem('Année', vehicule.annee.toString()),
                          _DetailItem('Type', vehicule.typeVehicule.libelle),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _DetailSection(
                        title: 'Capacités',
                        items: [
                          _DetailItem('Poids maximum', '${vehicule.capacitePoids} tonnes'),
                          _DetailItem('Volume maximum', '${vehicule.capaciteVolume} m³'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _DetailSection(
                        title: 'Statut',
                        items: [
                          _DetailItem('Disponibilité', vehicule.disponible ? 'Disponible' : 'Occupé'),
                          _DetailItem('Date d\'ajout', _formatDate(vehicule.dateCreation)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleDisponibilite(BuildContext context, ProprietaireProvider provider, vehicule) async {
    await provider.toggleVehiculeAvailability(vehicule.id, !vehicule.disponible);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            vehicule.disponible 
                ? 'Véhicule mis hors service'
                : 'Véhicule remis en service',
          ),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _editVehicule(BuildContext context, vehicule) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Modification de véhicule - Fonctionnalité à venir'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _confirmDeleteVehicule(BuildContext context, ProprietaireProvider provider, vehicule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le véhicule'),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer le véhicule ${vehicule.immatriculation} ?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteVehicule(context, provider, vehicule);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _deleteVehicule(BuildContext context, ProprietaireProvider provider, vehicule) {
    // TODO: Implémenter la suppression
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Suppression de véhicule - Fonctionnalité à venir'),
        backgroundColor: AppColors.warning,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final List<_DetailItem> items;

  const _DetailSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.warning,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: item,
        )),
      ],
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const _DetailItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const Text(' : '),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}