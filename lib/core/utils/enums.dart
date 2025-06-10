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
        return Colors.orange;
      case StatutCommande.ACCEPTEE:
        return Colors.blue;
      case StatutCommande.EN_COURS:
        return Colors.purple;
      case StatutCommande.RAMASSAGE:
        return Colors.indigo;
      case StatutCommande.EN_LIVRAISON:
        return Colors.amber;
      case StatutCommande.LIVREE:
        return Colors.green;
      case StatutCommande.ANNULEE:
        return Colors.red;
      case StatutCommande.REFUSEE:
        return Colors.grey;
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
