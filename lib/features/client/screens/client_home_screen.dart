/* import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/enums.dart';
import '../providers/commande_provider.dart';
import '../widgets/commande_card.dart';
import 'create_commande_screen.dart';
import 'commandes_list_screen.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});
  
  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommandeProvider>().loadMyCommandes();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => context.read<CommandeProvider>().loadMyCommandes(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text('🚚 LanaYaGo'),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    // TODO: Notifications
                  },
                ),
              ],
            ),
            
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Actions rapides
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Actions rapides',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _createNewCommande(context),
                                    icon: const Icon(Icons.add),
                                    label: const Text('Nouvelle commande'),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(16),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => _viewAllCommandes(context),
                                    icon: const Icon(Icons.list),
                                    label: const Text('Mes commandes'),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.all(16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Statistiques
                    Consumer<CommandeProvider>(
                      builder: (context, provider, child) {
                        return Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                title: 'Commandes',
                                value: provider.commandes.length.toString(),
                                icon: Icons.shopping_cart,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                title: 'En cours',
                                value: provider.commandes
                                    .where((c) => c.statut.isActive)
                                    .length
                                    .toString(),
                                icon: Icons.local_shipping,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Commandes récentes
                    Text(
                      'Commandes récentes',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Liste des commandes récentes
            Consumer<CommandeProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }
                
                if (provider.commandes.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.inbox,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Aucune commande',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Créez votre première commande pour commencer',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[500],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                
                final recentCommandes = provider.commandes.take(5).toList();
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                        child: CommandeCard(
                          commande: recentCommandes[index],
                          onTap: () => _viewCommandeDetail(context, recentCommandes[index]),
                        ),
                      );
                    },
                    childCount: recentCommandes.length,
                  ),
                );
              },
            ),
            
            const SliverToBoxAdapter(
              child: SizedBox(height: 100), // Espace pour le FAB
            ),
          ],
        ),
      ),
      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createNewCommande(context),
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle commande'),
      ),
    );
  }
  
  void _createNewCommande(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateCommandeScreen(),
      ),
    );
  }
  
  void _viewAllCommandes(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CommandesListScreen(),
      ),
    );
  }
  
  void _viewCommandeDetail(BuildContext context, commande) {
    // TODO: Navigate to commande detail
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
} */