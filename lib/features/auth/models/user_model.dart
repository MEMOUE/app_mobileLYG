/* import '../../../core/utils/enums.dart';

class UserModel {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String telephone;
  final TypeUtilisateur typeUtilisateur;
  final bool actif;
  final DateTime dateCreation;
  final String? photoUrl;
  
  // Champs spécifiques selon le type
  final String? adresse;
  final String? ville;
  final String? codePostal;
  final double? noteMoyenne;
  final int? nombreCommandes;
  final String? numeroPermis;
  final bool? disponible;
  final String? nomEntreprise;
  final String? numeroSiret;
  
  UserModel({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.telephone,
    required this.typeUtilisateur,
    required this.actif,
    required this.dateCreation,
    this.photoUrl,
    this.adresse,
    this.ville,
    this.codePostal,
    this.noteMoyenne,
    this.nombreCommandes,
    this.numeroPermis,
    this.disponible,
    this.nomEntreprise,
    this.numeroSiret,
  });
  
  String get fullName => '$prenom $nom';
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      telephone: json['telephone'],
      typeUtilisateur: TypeUtilisateur.values.firstWhere(
        (e) => e.name == json['typeUtilisateur'],
      ),
      actif: json['actif'],
      dateCreation: DateTime.parse(json['dateCreation']),
      photoUrl: json['photoUrl'],
      adresse: json['adresse'],
      ville: json['ville'],
      codePostal: json['codePostal'],
      noteMoyenne: json['noteMoyenne']?.toDouble(),
      nombreCommandes: json['nombreCommandes'],
      numeroPermis: json['numeroPermis'],
      disponible: json['disponible'],
      nomEntreprise: json['nomEntreprise'],
      numeroSiret: json['numeroSiret'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'telephone': telephone,
      'typeUtilisateur': typeUtilisateur.name,
      'actif': actif,
      'dateCreation': dateCreation.toIso8601String(),
      'photoUrl': photoUrl,
      'adresse': adresse,
      'ville': ville,
      'codePostal': codePostal,
      'noteMoyenne': noteMoyenne,
      'nombreCommandes': nombreCommandes,
      'numeroPermis': numeroPermis,
      'disponible': disponible,
      'nomEntreprise': nomEntreprise,
      'numeroSiret': numeroSiret,
    };
  }
} */