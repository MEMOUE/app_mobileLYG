/* import '../../../core/utils/enums.dart';
import '../../auth/models/user_model.dart';
import '../../proprietaire/models/vehicule_model.dart';

class CommandeModel {
  final int id;
  final String numeroCommande;
  final UserModel? client;
  final UserModel? chauffeur;
  final VehiculeModel? vehicule;
  
  final double latitudeDepart;
  final double longitudeDepart;
  final String adresseDepart;
  final double latitudeArrivee;
  final double longitudeArrivee;
  final String adresseArrivee;
  
  final double poidsMarchandise;
  final double? volumeMarchandise;
  final String? descriptionMarchandise;
  final bool urgent;
  
  final DateTime dateCreation;
  final DateTime? dateRamassageSouhaitee;
  final DateTime? dateRamassageEffective;
  final DateTime? dateLivraisonSouhaitee;
  final DateTime? dateLivraisonEffective;
  
  final double distance;
  final double tarifCalcule;
  final double? tarifFinal;
  final StatutCommande statut;
  
  final double? noteClient;
  final double? noteChauffeur;
  final String? commentaireClient;
  final String? commentaireChauffeur;
  
  CommandeModel({
    required this.id,
    required this.numeroCommande,
    this.client,
    this.chauffeur,
    this.vehicule,
    required this.latitudeDepart,
    required this.longitudeDepart,
    required this.adresseDepart,
    required this.latitudeArrivee,
    required this.longitudeArrivee,
    required this.adresseArrivee,
    required this.poidsMarchandise,
    this.volumeMarchandise,
    this.descriptionMarchandise,
    required this.urgent,
    required this.dateCreation,
    this.dateRamassageSouhaitee,
    this.dateRamassageEffective,
    this.dateLivraisonSouhaitee,
    this.dateLivraisonEffective,
    required this.distance,
    required this.tarifCalcule,
    this.tarifFinal,
    required this.statut,
    this.noteClient,
    this.noteChauffeur,
    this.commentaireClient,
    this.commentaireChauffeur,
  });
  
  factory CommandeModel.fromJson(Map<String, dynamic> json) {
    return CommandeModel(
      id: json['id'],
      numeroCommande: json['numeroCommande'],
      client: json['client'] != null ? UserModel.fromJson(json['client']) : null,
      chauffeur: json['chauffeur'] != null ? UserModel.fromJson(json['chauffeur']) : null,
      vehicule: json['vehicule'] != null ? VehiculeModel.fromJson(json['vehicule']) : null,
      latitudeDepart: json['latitudeDepart'].toDouble(),
      longitudeDepart: json['longitudeDepart'].toDouble(),
      adresseDepart: json['adresseDepart'],
      latitudeArrivee: json['latitudeArrivee'].toDouble(),
      longitudeArrivee: json['longitudeArrivee'].toDouble(),
      adresseArrivee: json['adresseArrivee'],
      poidsMarchandise: json['poidsMarchandise'].toDouble(),
      volumeMarchandise: json['volumeMarchandise']?.toDouble(),
      descriptionMarchandise: json['descriptionMarchandise'],
      urgent: json['urgent'],
      dateCreation: DateTime.parse(json['dateCreation']),
      dateRamassageSouhaitee: json['dateRamassageSouhaitee'] != null 
          ? DateTime.parse(json['dateRamassageSouhaitee']) : null,
      dateRamassageEffective: json['dateRamassageEffective'] != null 
          ? DateTime.parse(json['dateRamassageEffective']) : null,
      dateLivraisonSouhaitee: json['dateLivraisonSouhaitee'] != null 
          ? DateTime.parse(json['dateLivraisonSouhaitee']) : null,
      dateLivraisonEffective: json['dateLivraisonEffective'] != null 
          ? DateTime.parse(json['dateLivraisonEffective']) : null,
      distance: json['distance'].toDouble(),
      tarifCalcule: json['tarifCalcule'].toDouble(),
      tarifFinal: json['tarifFinal']?.toDouble(),
      statut: StatutCommande.values.firstWhere(
        (e) => e.name == json['statut'],
      ),
      noteClient: json['noteClient']?.toDouble(),
      noteChauffeur: json['noteChauffeur']?.toDouble(),
      commentaireClient: json['commentaireClient'],
      commentaireChauffeur: json['commentaireChauffeur'],
    );
  }
}

class CreateCommandeRequest {
  final double latitudeDepart;
  final double longitudeDepart;
  final String adresseDepart;
  final double latitudeArrivee;
  final double longitudeArrivee;
  final String adresseArrivee;
  final double poidsMarchandise;
  final double? volumeMarchandise;
  final String? descriptionMarchandise;
  final bool urgent;
  final DateTime? dateRamassageSouhaitee;
  final DateTime? dateLivraisonSouhaitee;
  
  CreateCommandeRequest({
    required this.latitudeDepart,
    required this.longitudeDepart,
    required this.adresseDepart,
    required this.latitudeArrivee,
    required this.longitudeArrivee,
    required this.adresseArrivee,
    required this.poidsMarchandise,
    this.volumeMarchandise,
    this.descriptionMarchandise,
    this.urgent = false,
    this.dateRamassageSouhaitee,
    this.dateLivraisonSouhaitee,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'latitudeDepart': latitudeDepart,
      'longitudeDepart': longitudeDepart,
      'adresseDepart': adresseDepart,
      'latitudeArrivee': latitudeArrivee,
      'longitudeArrivee': longitudeArrivee,
      'adresseArrivee': adresseArrivee,
      'poidsMarchandise': poidsMarchandise,
      if (volumeMarchandise != null) 'volumeMarchandise': volumeMarchandise,
      if (descriptionMarchandise != null) 'descriptionMarchandise': descriptionMarchandise,
      'urgent': urgent,
      if (dateRamassageSouhaitee != null) 'dateRamassageSouhaitee': dateRamassageSouhaitee!.toIso8601String(),
      if (dateLivraisonSouhaitee != null) 'dateLivraisonSouhaitee': dateLivraisonSouhaitee!.toIso8601String(),
    };
  }
} */