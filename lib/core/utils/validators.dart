class Validators {
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ce champ est requis';
    }
    if (value.trim().length < 2) {
      return 'Le nom doit contenir au moins 2 caractères';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ce champ est requis';
    }
    
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Email invalide';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ce champ est requis';
    }
    
    final cleanPhone = value.replaceAll(RegExp(r'[^\d+]'), '');
    final phoneRegex = RegExp(r'^\+221[0-9]{9}$|^[0-9]{9}$');
    
    if (!phoneRegex.hasMatch(cleanPhone)) {
      return 'Numéro de téléphone invalide';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est requis';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  static String? confirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est requis';
    }
    if (value != originalPassword) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ce champ est requis';
    }
    return null;
  }

  static String? postalCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optionnel
    }
    
    final postalCodeRegex = RegExp(r'^[0-9]{5}$');
    
    if (!postalCodeRegex.hasMatch(value.trim())) {
      return 'Code postal invalide';
    }
    return null;
  }

  static String? licenseNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ce champ est requis';
    }
    
    final licenseRegex = RegExp(r'^[A-Z]{2}[0-9]{9}$');
    
    if (!licenseRegex.hasMatch(value.trim().toUpperCase())) {
      return 'Numéro de permis invalide';
    }
    return null;
  }

  static String? siretNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ce champ est requis';
    }
    
    final siretRegex = RegExp(r'^[0-9]{14}$');
    
    if (!siretRegex.hasMatch(value.trim())) {
      return 'Numéro SIRET invalide';
    }
    return null;
  }
}