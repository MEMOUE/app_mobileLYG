import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/enums.dart';
import '../models/vehicule_model.dart';

class VehiculeCard extends StatelessWidget {
  final VehiculeModel vehicule;
  final VoidCallback? onTap;
  final VoidCallback? onToggleDisponibilite;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const VehiculeCard({
    super.key,
    required this.vehicule,
    this.onTap,
    this.onToggleDisponibilite,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec immatriculation et statut
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: vehicule.typeVehicule.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            vehicule.typeVehicule.icon,
                            color: vehicule.typeVehicule.color,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vehicule.immatriculation,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${vehicule.marque} ${vehicule.modele}',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Badge de disponibilité
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: vehicule.disponible 
                          ? AppColors.success.withOpacity(0.1)
                          : AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: vehicule.disponible 
                            ? AppColors.success 
                            : AppColors.error,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          vehicule.disponible ? Icons.check_circle : Icons.cancel,
                          size: 12,
                          color: vehicule.disponible 
                              ? AppColors.success 
                              : AppColors.error,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          vehicule.disponible ? 'Disponible' : 'Occupé',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: vehicule.disponible 
                                ? AppColors.success 
                                : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Type de véhicule et année
              Row(
                children: [
                  Expanded(
                    child: _InfoItem(
                      icon: Icons.category,
                      label: 'Type',
                      value: vehicule.typeVehicule.libelle,
                    ),
                  ),
                  Expanded(
                    child: _InfoItem(
                      icon: Icons.calendar_today,
                      label: 'Année',
                      value: vehicule.annee.toString(),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Capacités
              Row(
                children: [
                  Expanded(
                    child: _InfoItem(
                      icon: Icons.scale,
                      label: 'Poids',
                      value: '${vehicule.capacitePoids.toString()} t',
                    ),
                  ),
                  Expanded(
                    child: _InfoItem(
                      icon: Icons.inventory,
                      label: 'Volume',
                      value: '${vehicule.capaciteVolume.toString()} m³',
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Actions
              Row(
                children: [
                  // Bouton toggle disponibilité
                  if (onToggleDisponibilite != null) ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onToggleDisponibilite,
                        icon: Icon(
                          vehicule.disponible ? Icons.pause : Icons.play_arrow,
                          size: 16,
                        ),
                        label: Text(
                          vehicule.disponible ? 'Mettre hors service' : 'Remettre en service',
                          style: const TextStyle(fontSize: 12),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: vehicule.disponible 
                              ? AppColors.warning 
                              : AppColors.success,
                          side: BorderSide(
                            color: vehicule.disponible 
                                ? AppColors.warning 
                                : AppColors.success,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  
                  // Bouton modifier
                  if (onEdit != null) ...[
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit),
                      style: IconButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                      ),
                      tooltip: 'Modifier',
                    ),
                    const SizedBox(width: 4),
                  ],
                  
                  // Bouton supprimer
                  if (onDelete != null) ...[
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete),
                      style: IconButton.styleFrom(
                        foregroundColor: AppColors.error,
                        backgroundColor: AppColors.error.withOpacity(0.1),
                      ),
                      tooltip: 'Supprimer',
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Extension pour ajouter la couleur aux types de véhicules
extension TypeVehiculeColorExtension on TypeVehicule {
  Color get color {
    switch (this) {
      case TypeVehicule.CAMIONNETTE:
        return AppColors.info;
      case TypeVehicule.CAMION_LEGER:
        return AppColors.success;
      case TypeVehicule.CAMION_MOYEN:
        return AppColors.warning;
      case TypeVehicule.CAMION_LOURD:
        return AppColors.error;
      case TypeVehicule.CAMION_FRIGORIFIQUE:
        return AppColors.primary;
      case TypeVehicule.CAMION_BENNE:
        return const Color(0xFF795548); // Brown
    }
  }
}