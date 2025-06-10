import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/proprietaire_provider.dart';

class ProprietaireHomeScreen extends StatefulWidget {
  const ProprietaireHomeScreen({super.key});

  @override
  State<ProprietaireHomeScreen> createState() => _ProprietaireHomeScreenState();
}

class _ProprietaireHomeScreenState extends State<ProprietaireHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProprietaireProvider>();
      provider.loadVehicules();
      provider.loadStatistics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🚚 Gestionnaire de Flotte'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navigate to add vehicle
            },
          ),
        ],
      ),
      body: Consumer<ProprietaireProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Statistiques
                if (provider.statistics != null) ...[
                  Text(
                    'Tableau de bord',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      _StatCard(
                        title: 'Véhicules',
                        value: provider.statistics!['totalVehicules'].toString(),
                        icon: Icons.local_shipping,
                        color: Colors.blue,
                      ),
                      _StatCard(
                        title: 'Disponibles',
                        value: provider.statistics!['vehiculesDisponibles'].toString(),
                        icon: Icons.check_circle,
                        color: Colors.green,
                      ),
                      _StatCard(
                        title: 'En cours',
                        value: provider.statistics!['commandesEnCours'].toString(),
                        icon: Icons.directions,
                        color: Colors.orange,
                      ),
                      _StatCard(
                        title: 'CA du mois',
                        value: '${provider.statistics!['chiffreAffairesMois']}€',
                        icon: Icons.euro,
                        color: Colors.purple,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],

                // Liste des véhicules
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mes véhicules',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        // TODO: Navigate to all vehicles
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Voir tout'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.vehicules.take(3).length,
                  itemBuilder: (context, index) {
                    final vehicule = provider.vehicules[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Icon(
                          vehicule.typeVehicule.icon,
                          size: 32,
                          color: vehicule.disponible ? Colors.green : Colors.red,
                        ),
                        title: Text('${vehicule.marque} ${vehicule.modele}'),
                        subtitle: Text(vehicule.immatriculation),
                        trailing: Switch(
                          value: vehicule.disponible,
                          onChanged: (value) {
                            provider.toggleVehiculeAvailability(vehicule.id, value);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
