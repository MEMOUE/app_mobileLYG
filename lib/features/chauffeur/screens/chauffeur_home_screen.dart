import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chauffeur_provider.dart';
import '../../../core/services/websocket_service.dart';

class ChauffeurHomeScreen extends StatefulWidget {
  const ChauffeurHomeScreen({super.key});

  @override
  State<ChauffeurHomeScreen> createState() => _ChauffeurHomeScreenState();
}

class _ChauffeurHomeScreenState extends State<ChauffeurHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChauffeurProvider>().loadMyCommandes();
      context.read<ChauffeurProvider>().loadAvailableCommandes();
      
      // Connexion WebSocket pour les nouvelles commandes
      WebSocketService().connect();
      WebSocketService().addListener('NOUVELLE_COMMANDE', (message) {
        context.read<ChauffeurProvider>().loadAvailableCommandes();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🚚 Chauffeur'),
        actions: [
          Consumer<ChauffeurProvider>(
            builder: (context, provider, child) {
              return Row(
                children: [
                  Switch(
                    value: provider.isOnline,
                    onChanged: (value) {
                      if (value) {
                        provider.goOnline();
                      } else {
                        provider.goOffline();
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    provider.isOnline ? 'En ligne' : 'Hors ligne',
                    style: TextStyle(
                      color: provider.isOnline ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<ChauffeurProvider>(
        builder: (context, provider, child) {
          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Container(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: TabBar(
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(
                        text: 'Disponibles (${provider.availableCommandes.length})',
                        icon: const Icon(Icons.list),
                      ),
                      Tab(
                        text: 'Mes commandes (${provider.myCommandes.length})',
                        icon: const Icon(Icons.assignment),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      // Commandes disponibles
                      RefreshIndicator(
                        onRefresh: provider.loadAvailableCommandes,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: provider.availableCommandes.length,
                          itemBuilder: (context, index) {
                            final commande = provider.availableCommandes[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                title: Text(commande.numeroCommande),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('De: ${commande.adresseDepart}'),
                                    Text('Vers: ${commande.adresseArrivee}'),
                                    Text('Poids: ${commande.poidsMarchandise} kg'),
                                  ],
                                ),
                                trailing: ElevatedButton(
                                  onPressed: () => _acceptCommande(commande.id),
                                  child: const Text('Accepter'),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      
                      // Mes commandes
                      RefreshIndicator(
                        onRefresh: provider.loadMyCommandes,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: provider.myCommandes.length,
                          itemBuilder: (context, index) {
                            final commande = provider.myCommandes[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                title: Text(commande.numeroCommande),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Statut: ${commande.statut.libelle}'),
                                    Text('Client: ${commande.client?.fullName ?? 'N/A'}'),
                                  ],
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: commande.statut.color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: commande.statut.color),
                                  ),
                                  child: Text(
                                    commande.statut.libelle,
                                    style: TextStyle(
                                      color: commande.statut.color,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _acceptCommande(int commandeId) {
    context.read<ChauffeurProvider>().loadMyCommandes();
    // TODO: Implement accept commande logic
  }
}
