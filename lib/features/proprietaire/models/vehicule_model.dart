import '../../../core/utils/enums.dart';
import '../../auth/models/user_model.dart';

class VehiculeModel {
  final int id;
  final String immatriculation;
  final String marque;
  final String modele;
  final int annee;
  final double capacitePoids;
  final double capaciteVolume;
  final TypeVehicule typeVehicule;
  final bool disponible;
  final double? latitudeActuelle;
  final double? longitudeActuelle;
  final DateTime dateCreation;
  final String? photoUrl;
  final UserModel? proprietaire;

  VehiculeModel({
    required this.id,
    required this.immatriculation,
    required this.marque,
    required this.modele,
    required this.annee,
    required this.capacitePoids,
    required this.capaciteVolume,
    required this.typeVehicule,
    required this.disponible,
    this.latitudeActuelle,
    this.longitudeActuelle,
    required this.dateCreation,
    this.photoUrl,
    this.proprietaire,
  });

  factory VehiculeModel.fromJson(Map<String, dynamic> json) {
    return VehiculeModel(
      id: json['id'],
      immatriculation: json['immatriculation'],
      marque: json['marque'],
      modele: json['modele'],
      annee: json['annee'],
      capacitePoids: (json['capacitePoids'] as num).toDouble(),
      capaciteVolume: (json['capaciteVolume'] as num).toDouble(),
      typeVehicule: TypeVehicule.values.firstWhere(
        (e) => e.name == json['typeVehicule'],
        orElse: () => TypeVehicule.CAMIONNETTE,
      ),
      disponible: json['disponible'] ?? true,
      latitudeActuelle: json['latitudeActuelle']?.toDouble(),
      longitudeActuelle: json['longitudeActuelle']?.toDouble(),
      dateCreation: DateTime.parse(json['dateCreation']),
      photoUrl: json['photoUrl'],
      proprietaire: json['proprietaire'] != null 
          ? UserModel.fromJson(json['proprietaire']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'immatriculation': immatriculation,
      'marque': marque,
      'modele': modele,
      'annee': annee,
      'capacitePoids': capacitePoids,
      'capaciteVolume': capaciteVolume,
      'typeVehicule': typeVehicule.name,
      'disponible': disponible,
      'latitudeActuelle': latitudeActuelle,
      'longitudeActuelle': longitudeActuelle,
      'dateCreation': dateCreation.toIso8601String(),
      'photoUrl': photoUrl,
      'proprietaire': proprietaire?.toJson(),
    };
  }

  VehiculeModel copyWith({
    int? id,
    String? immatriculation,
    String? marque,
    String? modele,
    int? annee,
    double? capacitePoids,
    double? capaciteVolume,
    TypeVehicule? typeVehicule,
    bool? disponible,
    double? latitudeActuelle,
    double? longitudeActuelle,
    DateTime? dateCreation,
    String? photoUrl,
    UserModel? proprietaire,
  }) {
    return VehiculeModel(
      id: id ?? this.id,
      immatriculation: immatriculation ?? this.immatriculation,
      marque: marque ?? this.marque,
      modele: modele ?? this.modele,
      annee: annee ?? this.annee,
      capacitePoids: capacitePoids ?? this.capacitePoids,
      capaciteVolume: capaciteVolume ?? this.capaciteVolume,
      typeVehicule: typeVehicule ?? this.typeVehicule,
      disponible: disponible ?? this.disponible,
      latitudeActuelle: latitudeActuelle ?? this.latitudeActuelle,
      longitudeActuelle: longitudeActuelle ?? this.longitudeActuelle,
      dateCreation: dateCreation ?? this.dateCreation,
      photoUrl: photoUrl ?? this.photoUrl,
      proprietaire: proprietaire ?? this.proprietaire,
    );
  }
}

class CreateVehiculeRequest {
  final String immatriculation;
  final String marque;
  final String modele;
  final int annee;
  final double capacitePoids;
  final double capaciteVolume;
  final TypeVehicule typeVehicule;
  final String? numeroAssurance;
  final String? numeroCarteGrise;

  CreateVehiculeRequest({
    required this.immatriculation,
    required this.marque,
    required this.modele,
    required this.annee,
    required this.capacitePoids,
    required this.capaciteVolume,
    required this.typeVehicule,
    this.numeroAssurance,
    this.numeroCarteGrise,
  });

  Map<String, dynamic> toJson() {
    return {
      'immatriculation': immatriculation,
      'marque': marque,
      'modele': modele,
      'annee': annee,
      'capacitePoids': capacitePoids,
      'capaciteVolume': capaciteVolume,
      'typeVehicule': typeVehicule.name,
      if (numeroAssurance != null) 'numeroAssurance': numeroAssurance,
      if (numeroCarteGrise != null) 'numeroCarteGrise': numeroCarteGrise,
    };
  }
}