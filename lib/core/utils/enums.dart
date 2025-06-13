import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum TypeUtilisateur {
  CLIENT,
  CHAUFFEUR,
  PROPRIETAIRE_VEHICULE,
}

enum StatutCommande {
  EN_ATTENTE,
  ACCEPTEE,
  EN_COURS,
  RAMASSAGE,
  EN_LIVRAISON,
  LIVREE,
  ANNULEE,
  REFUSEE,
}

enum TypeVehicule {
  CAMIONNETTE,
  CAMION_LEGER,
  CAMION_MOYEN,
  CAMION_LOURD,
  CAMION_FRIGORIFIQUE,
  CAMION_BENNE,
}

extension TypeUtilisateurExtension on TypeUtilisateur {
  String get libelle {
    switch (this) {
      case TypeUtilisateur.CLIENT:
        return 'Client';
      case TypeUtilisateur.CHAUFFEUR:
        return 'Chauffeur';
      case TypeUtilisateur.PROPRIETAIRE_VEHICULE:
        return 'Propriétaire de véhicule';
    }
  }
  
  String get description {
    switch (this) {
      case TypeUtilisateur.CLIENT:
        return 'Je veux faire transporter mes marchandises';
      case TypeUtilisateur.CHAUFFEUR:
        return 'Je veux transporter des marchandises';
      case TypeUtilisateur.PROPRIETAIRE_VEHICULE:
        return 'Je gère une flotte de véhicules';
    }
  }
  
  IconData get icon {
    switch (this) {
      case TypeUtilisateur.CLIENT:
        return Icons.person;
      case TypeUtilisateur.CHAUFFEUR:
        return Icons.local_shipping;
      case TypeUtilisateur.PROPRIETAIRE_VEHICULE:
        return Icons.business;
    }
  }
  
  Color get color {
    switch (this) {
      case TypeUtilisateur.CLIENT:
        return AppColors.info;
      case TypeUtilisateur.CHAUFFEUR:
        return AppColors.success;
      case TypeUtilisateur.PROPRIETAIRE_VEHICULE:
        return AppColors.warning;
    }
  }
}

extension StatutCommandeExtension on StatutCommande {
  String get libelle {
    switch (this) {
      case StatutCommande.EN_ATTENTE:
        return 'En attente';
      case StatutCommande.ACCEPTEE:
        return 'Acceptée';
      case StatutCommande.EN_COURS:
        return 'En cours';
      case StatutCommande.RAMASSAGE:
        return 'Ramassage';
      case StatutCommande.EN_LIVRAISON:
        return 'En livraison';
      case StatutCommande.LIVREE:
        return 'Livrée';
      case StatutCommande.ANNULEE:
        return 'Annulée';
      case StatutCommande.REFUSEE:
        return 'Refusée';
    }
  }

  Color get color {
    switch (this) {
      case StatutCommande.EN_ATTENTE:
        return AppColors.statusPending;
      case StatutCommande.ACCEPTEE:
        return AppColors.statusAccepted;
      case StatutCommande.EN_COURS:
        return AppColors.statusInProgress;
      case StatutCommande.RAMASSAGE:
        return AppColors.statusPickup;
      case StatutCommande.EN_LIVRAISON:
        return AppColors.statusDelivery;
      case StatutCommande.LIVREE:
        return AppColors.statusDelivered;
      case StatutCommande.ANNULEE:
        return AppColors.statusCancelled;
      case StatutCommande.REFUSEE:
        return AppColors.statusRefused;
    }
  }

  bool get isActive {
    return [
      StatutCommande.EN_ATTENTE,
      StatutCommande.ACCEPTEE,
      StatutCommande.EN_COURS,
      StatutCommande.RAMASSAGE,
      StatutCommande.EN_LIVRAISON,
    ].contains(this);
  }

  bool get isFinished {
    return [
      StatutCommande.LIVREE,
      StatutCommande.ANNULEE,
      StatutCommande.REFUSEE,
    ].contains(this);
  }
}

extension TypeVehiculeExtension on TypeVehicule {
  String get libelle {
    switch (this) {
      case TypeVehicule.CAMIONNETTE:
        return 'Camionnette';
      case TypeVehicule.CAMION_LEGER:
        return 'Camion Léger';
      case TypeVehicule.CAMION_MOYEN:
        return 'Camion Moyen';
      case TypeVehicule.CAMION_LOURD:
        return 'Camion Lourd';
      case TypeVehicule.CAMION_FRIGORIFIQUE:
        return 'Camion Frigorifique';
      case TypeVehicule.CAMION_BENNE:
        return 'Camion Benne';
    }
  }

  IconData get icon {
    switch (this) {
      case TypeVehicule.CAMIONNETTE:
        return Icons.local_shipping;
      case TypeVehicule.CAMION_LEGER:
        return Icons.fire_truck;
      case TypeVehicule.CAMION_MOYEN:
        return Icons.local_shipping;
      case TypeVehicule.CAMION_LOURD:
        return Icons.airport_shuttle;
      case TypeVehicule.CAMION_FRIGORIFIQUE:
        return Icons.ac_unit;
      case TypeVehicule.CAMION_BENNE:
        return Icons.engineering;
    }
  }
}