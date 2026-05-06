import 'package:flutter/material.dart';

void main() {
  runApp(const PombalBusApp());
}

class AppColors {
  static const primary = Color(0xFF1B4F8A);
  static const primaryLight = Color(0xFF2E6CB8);
  static const accentGreen = Color(0xFF27AE60);
  static const accentRed = Color(0xFFE74C3C);
  static const accent = Color(0xFFF5A623);
  static const surface = Color(0xFFF4F6FA);
  static const card = Colors.white;
  static const text = Color(0xFF1A1D23);
  static const muted = Color(0xFF6B7280);
  static const border = Color(0xFFE2E8F0);
  static const badgeBg = Color(0xFFEBF4FF);
}

class Tariff {
  const Tariff({
    required this.label,
    required this.single,
    required this.day,
    required this.month,
  });

  final String label;
  final double single;
  final double day;
  final double month;
}

class LiveBus {
  const LiveBus({
    required this.line,
    required this.route,
    required this.minutes,
    required this.stop,
    required this.status,
    required this.statusColor,
  });

  final String line;
  final String route;
  final int minutes;
  final String stop;
  final String status;
  final Color statusColor;
}

class PombalBusApp extends StatelessWidget {
  const PombalBusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pombal Bus',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.surface,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface: AppColors.surface,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.text),
        ),
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      HomeScreen(onTabChange: _onTabChange),
      const MapScreen(),
      const RoutesScreen(),
      const TicketsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _currentTab, children: screens),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        selectedIndex: _currentTab,
        indicatorColor: AppColors.badgeBg,
        onDestinationSelected: _onTabChange,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Mapa',
          ),
          NavigationDestination(
            icon: Icon(Icons.alt_route_outlined),
            selectedIcon: Icon(Icons.alt_route),
            label: 'Rotas',
          ),
          NavigationDestination(
            icon: Icon(Icons.confirmation_number_outlined),
            selectedIcon: Icon(Icons.confirmation_number),
            label: 'Bilhetes',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  void _onTabChange(int index) {
    setState(() {
      _currentTab = index;
    });
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onTabChange});

  final ValueChanged<int> onTabChange;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? from;
  String? to;

  final live = const [
    LiveBus(
      line: 'L1',
      route: 'Pombal -> Redinha -> Soure',
      minutes: 3,
      stop: 'Camara Municipal',
      status: 'A tempo',
      statusColor: AppColors.accentGreen,
    ),
    LiveBus(
      line: 'L3',
      route: 'Pombal -> Carnide -> Ansiao',
      minutes: 18,
      stop: 'Terminal Central',
      status: '+8 min',
      statusColor: AppColors.accentRed,
    ),
    LiveBus(
      line: 'L7',
      route: 'Pombal -> Albergaria -> Leiria',
      minutes: 1,
      stop: 'Terminal Central',
      status: 'A chegar',
      statusColor: AppColors.accent,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.primary,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pombal, Leiria',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      SizedBox(height: 4),
                      Chip(
                        label: Text(
                          'Pombal Bus',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: Color(0x33FFFFFF),
                        side: BorderSide.none,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0x33FFFFFF),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AlertsScreen()),
                    ),
                    icon: const Icon(Icons.notifications_outlined),
                  ),
                ],
              ),
              _RouteSelector(
                from: from,
                to: to,
                onSelectFrom: () => _pickPlace(true),
                onSelectTo: () => _pickPlace(false),
                onSwap: _swap,
                onSearch: _search,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 12),
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8),
                  border: const Border(
                    left: BorderSide(color: Color(0xFFF59E0B), width: 4),
                  ),
                ),
                child: const Text(
                  'Linha 3 - atraso de 8 min por obras na Av. Principal',
                  style: TextStyle(fontSize: 12, color: Color(0xFF92400E)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Em tempo real',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextButton(
                      onPressed: () => widget.onTabChange(1),
                      child: const Text('ver mapa'),
                    ),
                  ],
                ),
              ),
              ...live.map(
                (item) => _LiveCard(
                  item: item,
                  onTap: () => Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const StopScreen())),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Text(
                  'Paragens recentes',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _RecentStopCard(
                        title: 'Hospital Pombal',
                        lines: 'L1, L3, L5',
                        icon: Icons.local_hospital,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const StopScreen()),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _RecentStopCard(
                        title: 'Camara Municipal',
                        lines: 'L1, L2',
                        icon: Icons.account_balance,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _pickPlace(bool isFrom) async {
    final selected = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => PlacePickerScreen(isFrom: isFrom)),
    );
    if (selected == null) return;
    setState(() {
      if (isFrom) {
        from = selected;
      } else {
        to = selected;
      }
    });
  }

  void _swap() {
    setState(() {
      final tmp = from;
      from = to;
      to = tmp;
    });
  }

  void _search() {
    if (from == null || to == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleciona origem e destino.')),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ResultsScreen(from: from!, to: to!),
      ),
    );
  }
}

class _RouteSelector extends StatelessWidget {
  const _RouteSelector({
    required this.from,
    required this.to,
    required this.onSelectFrom,
    required this.onSelectTo,
    required this.onSwap,
    required this.onSearch,
  });

  final String? from;
  final String? to;
  final VoidCallback onSelectFrom;
  final VoidCallback onSelectTo;
  final VoidCallback onSwap;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          _SelectorField(
            icon: Icons.trip_origin,
            label: 'Partida',
            value: from ?? 'Selecionar local de origem...',
            onTap: onSelectFrom,
          ),
          Row(
            children: [
              const Expanded(child: Divider()),
              IconButton(
                onPressed: onSwap,
                icon: const Icon(Icons.swap_vert_circle_outlined),
                color: AppColors.primary,
              ),
              const Expanded(child: Divider()),
            ],
          ),
          _SelectorField(
            icon: Icons.location_on_outlined,
            label: 'Destino',
            value: to ?? 'Selecionar destino...',
            onTap: onSelectTo,
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onSearch,
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Ver ligacoes disponiveis'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectorField extends StatelessWidget {
  const _SelectorField({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final placeholder = value.contains('Selecionar');
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      color: placeholder ? AppColors.muted : AppColors.text,
                      fontWeight: placeholder
                          ? FontWeight.w400
                          : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveCard extends StatelessWidget {
  const _LiveCard({required this.item, required this.onTap});

  final LiveBus item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.line,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.route,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: item.statusColor.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      item.status,
                      style: TextStyle(
                        fontSize: 11,
                        color: item.statusColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${item.minutes} ',
                      style: TextStyle(
                        fontSize: 26,
                        color: item.statusColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const TextSpan(
                      text: 'min para ',
                      style: TextStyle(fontSize: 12, color: AppColors.muted),
                    ),
                    TextSpan(
                      text: item.stop,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.text,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentStopCard extends StatelessWidget {
  const _RecentStopCard({
    required this.title,
    required this.lines,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String lines;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                lines,
                style: const TextStyle(fontSize: 11, color: AppColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlacePickerScreen extends StatefulWidget {
  const PlacePickerScreen({super.key, required this.isFrom});

  final bool isFrom;

  @override
  State<PlacePickerScreen> createState() => _PlacePickerScreenState();
}

class _PlacePickerScreenState extends State<PlacePickerScreen> {
  final places = const [
    'A minha localizacao',
    'Hospital Pombal',
    'Camara Municipal',
    'Terminal Central',
    'Escola Secundaria de Pombal',
    'Mercado Municipal',
    'Parque Industrial Norte',
    'Redinha',
    'Carnide',
    'Ansiao',
    'Leiria',
    'Soure',
  ];
  String query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = places
        .where((p) => p.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isFrom ? 'Selecionar partida' : 'Selecionar destino',
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) => setState(() => query = value),
              decoration: const InputDecoration(
                hintText: 'Pesquisar paragem ou local...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final name = filtered[index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.badgeBg,
                    child: Icon(Icons.place, color: AppColors.primary),
                  ),
                  title: Text(name),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).pop(name),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key, required this.from, required this.to});

  final String from;
  final String to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ligacoes disponiveis'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Partida\n$from',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward, color: Colors.white70),
                Expanded(
                  child: Text(
                    'Destino\n$to',
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '3 ligacoes encontradas',
                style: TextStyle(color: AppColors.muted),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                TripCard(
                  time: '09:44 -> 10:22',
                  details: '38 min - 1 autocarro direto',
                  eta: '3 min',
                  line: 'L1',
                  footer: '12 paragens | Lugares disponiveis | EUR 1.80',
                ),
                TripCard(
                  time: '10:00 -> 10:55',
                  details: '55 min - 1 transbordo',
                  eta: '18 min',
                  line: 'L3 + L7',
                  footer: '8 paragens | Atrasado | EUR 1.80',
                ),
                TripCard(
                  time: '10:30 -> 11:05',
                  details: '35 min - 1 autocarro direto',
                  eta: '49 min',
                  line: 'L7',
                  footer: '6 paragens | Acessivel | EUR 1.80',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TripCard extends StatelessWidget {
  const TripCard({
    super.key,
    required this.time,
    required this.details,
    required this.eta,
    required this.line,
    required this.footer,
  });

  final String time;
  final String details;
  final String eta;
  final String line;
  final String footer;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      time,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      details,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
                Chip(
                  label: Text(eta),
                  backgroundColor: AppColors.badgeBg,
                  side: BorderSide.none,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                line,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Divider(height: 18),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                footer,
                style: const TextStyle(fontSize: 12, color: AppColors.muted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StopScreen extends StatelessWidget {
  const StopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Camara Municipal'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Proximos'),
              Tab(text: 'Horarios'),
              Tab(text: 'Alertas'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _StopTimes(nowMode: true),
            _StopTimes(nowMode: false),
            _StopAlerts(),
          ],
        ),
      ),
    );
  }
}

class _StopTimes extends StatelessWidget {
  const _StopTimes({required this.nowMode});
  final bool nowMode;

  @override
  Widget build(BuildContext context) {
    final entries = nowMode
        ? const [
            ['L1', '09:44', 'Soure', '3 min'],
            ['L2', '09:52', 'Redinha', '11 min'],
            ['L3', '10:00', 'Ansiao', '+8 min'],
            ['L5', '10:15', 'Carnide', '34 min'],
          ]
        : const [
            ['L1', '06:30', 'Camara Municipal', ''],
            ['L1', '07:15', 'Camara Municipal', ''],
            ['L3', '07:30', 'Camara Municipal', ''],
            ['L7', '10:30', 'Camara Municipal', ''],
          ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final e = entries[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: AppColors.border),
          ),
          child: ListTile(
            leading: Container(
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                e[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            title: Text(
              e[1],
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text('-> ${e[2]}'),
            trailing: Text(
              e[3],
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StopAlerts extends StatelessWidget {
  const _StopAlerts();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _AlertTile(
          title: 'L3 atrasado +8 min',
          message: 'Obras na Av. Principal',
          color: Color(0xFF991B1B),
          bg: Color(0xFFFEE2E2),
        ),
        _AlertTile(
          title: 'Servico reduzido 10 jun.',
          message: 'Feriado nacional - horario domingo',
          color: Color(0xFF92400E),
          bg: Color(0xFFFEF3C7),
        ),
      ],
    );
  }
}

class _AlertTile extends StatelessWidget {
  const _AlertTile({
    required this.title,
    required this.message,
    required this.color,
    required this.bg,
  });

  final String title;
  final String message;
  final Color color;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(message, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.primary,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          width: double.infinity,
          child: const Text(
            'Mapa em Tempo Real',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Container(color: const Color(0xFFE8EDF3)),
              Positioned.fill(child: CustomPaint(painter: _MapPainter())),
              Positioned(
                top: 12,
                left: 12,
                child: Wrap(
                  spacing: 8,
                  children: const [
                    Chip(
                      label: Text('Todos'),
                      backgroundColor: AppColors.primary,
                      labelStyle: TextStyle(color: Colors.white),
                      side: BorderSide.none,
                    ),
                    Chip(label: Text('L1'), side: BorderSide.none),
                    Chip(label: Text('L3'), side: BorderSide.none),
                    Chip(label: Text('L7'), side: BorderSide.none),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: const Row(
            children: [
              Expanded(
                child: _MapInfoCard(
                  title: 'L1 - A tempo',
                  value: '3 min',
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _MapInfoCard(
                  title: 'L3 - Atrasado',
                  value: '+8 min',
                  color: AppColors.accentRed,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 5;
    final route1 = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3;
    final route2 = Paint()
      ..color = AppColors.accentGreen
      ..strokeWidth = 3;

    canvas.drawLine(
      Offset(0, size.height * 0.30),
      Offset(size.width, size.height * 0.30),
      road,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.55),
      Offset(size.width, size.height * 0.55),
      road,
    );
    canvas.drawLine(
      Offset(size.width * 0.28, 0),
      Offset(size.width * 0.28, size.height),
      road,
    );

    canvas.drawLine(
      Offset(size.width * 0.08, size.height * 0.30),
      Offset(size.width * 0.82, size.height * 0.30),
      route1,
    );
    canvas.drawLine(
      Offset(size.width * 0.28, size.height * 0.06),
      Offset(size.width * 0.28, size.height * 0.88),
      route2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapInfoCard extends StatelessWidget {
  const _MapInfoCard({
    required this.title,
    required this.value,
    required this.color,
  });
  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 11, color: AppColors.muted),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class RoutesScreen extends StatelessWidget {
  const RoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          color: AppColors.primary,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          child: const Text(
            'Rotas & Linhas',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Linhas Urbanas',
            style: TextStyle(
              color: AppColors.muted,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const _RouteTile(
          line: 'L1',
          route: 'Terminal -> Soure',
          details: '12 paragens - 38 min',
          state: 'Ativo',
        ),
        const _RouteTile(
          line: 'L3',
          route: 'Pombal -> Ansiao',
          details: '8 paragens - 25 min',
          state: 'Atrasado',
          stateColor: AppColors.accentRed,
        ),
        const _RouteTile(
          line: 'L7',
          route: 'Pombal -> Leiria',
          details: '6 paragens - 55 min',
          state: 'Ativo',
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: Text(
            'Linhas Escolares',
            style: TextStyle(
              color: AppColors.muted,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const _RouteTile(
          line: 'E1',
          route: 'Escolar - Pombal Centro',
          details: 'Dias letivos - 7:30 e 16:30',
          state: 'Inativo',
          stateColor: AppColors.muted,
        ),
      ],
    );
  }
}

class _RouteTile extends StatelessWidget {
  const _RouteTile({
    required this.line,
    required this.route,
    required this.details,
    required this.state,
    this.stateColor = AppColors.accentGreen,
  });

  final String line;
  final String route;
  final String details;
  final String state;
  final Color stateColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: ListTile(
        leading: Container(
          width: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            line,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        title: Text(route, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(details, style: const TextStyle(fontSize: 12)),
        trailing: Text(
          state,
          style: TextStyle(color: stateColor, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  String currentAge = 'adulto';

  final tariffs = const {
    'crianca': Tariff(label: 'Crianca (gratuito)', single: 0, day: 0, month: 0),
    'jovem': Tariff(label: 'Jovem (-50%)', single: 0.90, day: 2.20, month: 18),
    'adulto': Tariff(label: 'Adulto', single: 1.80, day: 4.40, month: 36),
    'senior': Tariff(
      label: 'Senior (-50%)',
      single: 0.90,
      day: 2.20,
      month: 18,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final t = tariffs[currentAge]!;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Perfil do utilizador',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ageChip('crianca', 'Crianca'),
                  _ageChip('jovem', 'Jovem'),
                  _ageChip('adulto', 'Adulto'),
                  _ageChip('senior', 'Senior'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _TicketCard(
          title: 'Bilhete simples',
          subtitle: '1 viagem - Qualquer linha',
          price: _price(t.single),
          badge: t.label,
          gradient: const [AppColors.primary, AppColors.primaryLight],
        ),
        _TicketCard(
          title: 'Bilhete diario',
          subtitle: 'Viagens ilimitadas - 1 dia',
          price: _price(t.day),
          badge: 'Popular',
          gradient: const [AppColors.accentGreen, Color(0xFF1E8449)],
        ),
        _TicketCard(
          title: 'Passe mensal',
          subtitle: 'Viagens ilimitadas - 30 dias',
          price: '${_price(t.month)}/mes',
          gradient: const [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: () {},
          style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
          child: const Text('Comprar agora'),
        ),
      ],
    );
  }

  Widget _ageChip(String id, String label) {
    final selected = currentAge == id;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() => currentAge = id),
      selectedColor: AppColors.badgeBg,
      side: BorderSide(color: selected ? AppColors.primary : AppColors.border),
      labelStyle: TextStyle(
        color: selected ? AppColors.primary : AppColors.text,
        fontWeight: FontWeight.w600,
      ),
      showCheckmark: false,
    );
  }

  String _price(double value) =>
      value == 0 ? 'Gratis' : 'EUR ${value.toStringAsFixed(2)}';
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.gradient,
    this.badge,
  });

  final String title;
  final String subtitle;
  final String price;
  final List<Color> gradient;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (badge != null)
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            price,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          color: AppColors.primary,
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 28),
          child: const Column(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: Color(0x33FFFFFF),
                child: Text(
                  'JS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Joao Silva',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Adulto - Passe mensal ativo',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
        Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saldo cartao',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'EUR 12.40',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    FilledButton(
                      onPressed: () {},
                      child: const Text('Carregar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        _ProfileTile(
          icon: Icons.accessibility_new,
          text: 'Acessibilidade',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AccessibilityScreen()),
          ),
        ),
        _ProfileTile(
          icon: Icons.notifications_none,
          text: 'Notificacoes e alertas',
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const AlertsScreen())),
        ),
        const _ProfileTile(
          icon: Icons.favorite_border,
          text: 'Paragens favoritas',
        ),
        const _ProfileTile(icon: Icons.history, text: 'Historico de viagens'),
        const _ProfileTile(icon: Icons.settings, text: 'Definicoes'),
      ],
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({required this.icon, required this.text, this.onTap});
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(text),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  final toggles = {
    'Modo alto contraste': true,
    'Texto grande': false,
    'Leitura em voz alta': true,
    'Vibracao para chegadas': true,
    'Filtrar acessiveis': false,
    'Modo escuro': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acessibilidade'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: toggles.keys
            .map(
              (key) => Card(
                child: SwitchListTile(
                  title: Text(
                    key,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text('Preferencia de acessibilidade'),
                  value: toggles[key]!,
                  onChanged: (value) => setState(() => toggles[key] = value),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alertas e Noticias'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _AlertTile(
            title: 'INTERRUPCAO - Linha L3',
            message: 'Atraso de 8 min por obras na Av. Principal.',
            color: Color(0xFF991B1B),
            bg: Color(0xFFFEE2E2),
          ),
          _AlertTile(
            title: 'AVISO - Servico reduzido',
            message:
                'No feriado de 10 jun as linhas L1 e L7 operam horario domingo.',
            color: Color(0xFF92400E),
            bg: Color(0xFFFEF3C7),
          ),
          _AlertTile(
            title: 'NOVIDADE - Nova paragem',
            message: 'Parque Industrial Norte foi adicionado a linha L7.',
            color: Color(0xFF065F46),
            bg: Color(0xFFD1FAE5),
          ),
          _AlertTile(
            title: 'PROMOCAO - Passe Jovem',
            message: '50% desconto no passe mensal para jovens ate 25 anos.',
            color: AppColors.primary,
            bg: AppColors.badgeBg,
          ),
        ],
      ),
    );
  }
}
