import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/enums.dart'; // Assurez-vous que cette ligne est présente
import '../../auth/providers/auth_provider.dart';
import '../../auth/screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Modifier le profil - Fonctionnalité à venir'),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.currentUser;
          
          if (user == null) {
            return const Center(
              child: Text('Utilisateur non connecté'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Photo de profil et informations principales
                _buildProfileHeader(context, user),
                
                const SizedBox(height: 24),
                
                // Informations personnelles
                _buildPersonalInfo(context, user),
                
                const SizedBox(height: 20),
                
                // Informations spécifiques selon le type
                _buildSpecificInfo(context, user),
                
                const SizedBox(height: 20),
                
                // Statistiques
                _buildStats(context, user),
                
                const SizedBox(height: 24),
                
                // Actions
                _buildActions(context, authProvider),
                
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, user) {
    // Fonction pour obtenir la couleur selon le type d'utilisateur
    Color getUserTypeColor(String typeUtilisateur) {
      switch (typeUtilisateur) {
        case 'CLIENT':
          return AppColors.info;
        case 'CHAUFFEUR':
          return AppColors.success;
        case 'PROPRIETAIRE_VEHICULE':
          return AppColors.warning;
        default:
          return AppColors.primary;
      }
    }

    // Fonction pour obtenir l'icône selon le type d'utilisateur
    IconData getUserTypeIcon(String typeUtilisateur) {
      switch (typeUtilisateur) {
        case 'CLIENT':
          return Icons.person;
        case 'CHAUFFEUR':
          return Icons.local_shipping;
        case 'PROPRIETAIRE_VEHICULE':
          return Icons.business;
        default:
          return Icons.person;
      }
    }

    // Fonction pour obtenir le libellé selon le type d'utilisateur
    String getUserTypeLibelle(String typeUtilisateur) {
      switch (typeUtilisateur) {
        case 'CLIENT':
          return 'Client';
        case 'CHAUFFEUR':
          return 'Chauffeur';
        case 'PROPRIETAIRE_VEHICULE':
          return 'Propriétaire de véhicule';
        default:
          return 'Utilisateur';
      }
    }

    final typeUtilisateurString = user.typeUtilisateur.toString().split('.').last;
    final color = getUserTypeColor(typeUtilisateurString);
    final icon = getUserTypeIcon(typeUtilisateurString);
    final libelle = getUserTypeLibelle(typeUtilisateurString);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: color.withOpacity(0.1),
              backgroundImage: user.photoUrl != null 
                  ? NetworkImage(user.photoUrl!)
                  : null,
              child: user.photoUrl == null 
                  ? Text(
                      Formatters.getInitials(user.prenom, user.nom),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    )
                  : null,
            ),
            
            const SizedBox(height: 16),
            
            Text(
              '${user.prenom} ${user.nom}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 16,
                    color: color,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    libelle,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            if (user.noteMoyenne != null) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.star,
                    color: AppColors.warning,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    user.noteMoyenne!.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '/5.0',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfo(BuildContext context, user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informations personnelles',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            _ProfileItem(
              icon: Icons.email,
              title: 'Email',
              value: user.email,
            ),
            
            _ProfileItem(
              icon: Icons.phone,
              title: 'Téléphone',
              value: Formatters.phone(user.telephone),
            ),
            
            if (user.adresse != null) ...[
              _ProfileItem(
                icon: Icons.location_on,
                title: 'Adresse',
                value: user.adresse!,
              ),
            ],
            
            if (user.ville != null) ...[
              _ProfileItem(
                icon: Icons.location_city,
                title: 'Ville',
                value: user.ville!,
              ),
            ],
            
            _ProfileItem(
              icon: Icons.calendar_today,
              title: 'Membre depuis',
              value: Formatters.date(user.dateCreation),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecificInfo(BuildContext context, user) {
    final typeUtilisateurString = user.typeUtilisateur.toString().split('.').last;
    
    if (typeUtilisateurString == 'CHAUFFEUR' && user.numeroPermis != null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Informations de conduite',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _ProfileItem(
                icon: Icons.credit_card,
                title: 'Numéro de permis',
                value: user.numeroPermis!,
              ),
              _ProfileItem(
                icon: Icons.check_circle,
                title: 'Statut',
                value: user.disponible == true ? 'Disponible' : 'Occupé',
              ),
            ],
          ),
        ),
      );
    }
    
    if (typeUtilisateurString == 'PROPRIETAIRE_VEHICULE') {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Informations de l\'entreprise',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (user.nomEntreprise != null) ...[
                _ProfileItem(
                  icon: Icons.business,
                  title: 'Nom de l\'entreprise',
                  value: user.nomEntreprise!,
                ),
              ],
              if (user.numeroSiret != null) ...[
                _ProfileItem(
                  icon: Icons.numbers,
                  title: 'Numéro SIRET',
                  value: user.numeroSiret!,
                ),
              ],
            ],
          ),
        ),
      );
    }
    
    return const SizedBox.shrink();
  }

  Widget _buildStats(BuildContext context, user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistiques',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                if (user.nombreCommandes != null) ...[
                  Expanded(
                    child: _StatItem(
                      icon: Icons.shopping_cart,
                      title: 'Commandes',
                      value: user.nombreCommandes.toString(),
                      color: AppColors.primary,
                    ),
                  ),
                ],
                
                if (user.noteMoyenne != null) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: _StatItem(
                      icon: Icons.star,
                      title: 'Note moyenne',
                      value: user.noteMoyenne!.toStringAsFixed(1),
                      color: AppColors.warning,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, AuthProvider authProvider) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.settings, color: AppColors.primary),
          title: const Text('Paramètres'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Paramètres - Fonctionnalité à venir'),
              ),
            );
          },
        ),
        
        ListTile(
          leading: const Icon(Icons.help, color: AppColors.info),
          title: const Text('Aide et support'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Aide - Fonctionnalité à venir'),
              ),
            );
          },
        ),
        
        ListTile(
          leading: const Icon(Icons.privacy_tip, color: AppColors.textSecondary),
          title: const Text('Politique de confidentialité'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Politique de confidentialité - Fonctionnalité à venir'),
              ),
            );
          },
        ),
        
        const Divider(),
        
        ListTile(
          leading: const Icon(Icons.logout, color: AppColors.error),
          title: const Text(
            'Déconnexion',
            style: TextStyle(color: AppColors.error),
          ),
          onTap: () => _showLogoutDialog(context, authProvider),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await authProvider.logout();
              
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text(
              'Déconnecter',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}