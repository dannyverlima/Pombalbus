import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/index.dart';
import '../widgets/index.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _searchController;
  String _selectedCategory = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _loadServices();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadServices({String? category}) {
    final servicesProvider = context.read<ServicesProvider>();
    servicesProvider.loadServices(category: category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POMBUS'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login', (route) => false);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (query) {
                      context.read<ServicesProvider>().searchServices(query);
                    },
                    decoration: InputDecoration(
                      hintText: 'Procurar serviços...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                context.read<ServicesProvider>().clearSearch();
                              },
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildCategoryChip('Todos', ''),
                        _buildCategoryChip('Ónibus', 'onibus'),
                        _buildCategoryChip('Comboio', 'comboio'),
                        _buildCategoryChip('Avião', 'aviao'),
                        _buildCategoryChip('Barco', 'barco'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Consumer<ServicesProvider>(
              builder: (context, servicesProvider, _) {
                if (servicesProvider.isLoading) {
                  return const SizedBox(
                    height: 300,
                    child: LoadingWidget(message: 'Carregando serviços...'),
                  );
                }

                if (servicesProvider.services.isEmpty) {
                  return const SizedBox(
                    height: 300,
                    child: EmptyWidget(
                      message: 'Nenhum serviço encontrado',
                      icon: Icons.directions_bus_filled,
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: servicesProvider.services.length,
                  itemBuilder: (context, index) {
                    final service = servicesProvider.services[index];
                    return ServiceCard(
                      service: service,
                      onTap: () {
                        Navigator.of(
                          context,
                        ).pushNamed('/service-detail', arguments: service);
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Reservas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.of(context).pushNamed('/bookings');
          } else if (index == 2) {
            Navigator.of(context).pushNamed('/profile');
          }
        },
      ),
    );
  }

  Widget _buildCategoryChip(String label, String category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
          });
          _loadServices(category: category.isEmpty ? null : category);
        },
      ),
    );
  }
}
