import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/index.dart';
import 'providers/index.dart';
import 'screens/index.dart';
import 'services/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        ProxyProvider<ApiService, AuthService>(
          create: (context) =>
              AuthService(apiService: context.read<ApiService>()),
          update: (context, apiService, previous) =>
              AuthService(apiService: apiService),
        ),
        ChangeNotifierProxyProvider<ApiService, AuthProvider>(
          create: (context) {
            final apiService = context.read<ApiService>();
            final authService = context.read<AuthService>();
            return AuthProvider(
              authService: authService,
              apiService: apiService,
            );
          },
          update: (context, apiService, previous) {
            final authService = context.read<AuthService>();
            return AuthProvider(
              authService: authService,
              apiService: apiService,
            );
          },
        ),
        ChangeNotifierProxyProvider<ApiService, ServicesProvider>(
          create: (context) {
            final apiService = context.read<ApiService>();
            return ServicesProvider(apiService: apiService);
          },
          update: (context, apiService, previous) {
            return ServicesProvider(apiService: apiService);
          },
        ),
        ChangeNotifierProxyProvider<ApiService, BookingsProvider>(
          create: (context) {
            final apiService = context.read<ApiService>();
            return BookingsProvider(apiService: apiService);
          },
          update: (context, apiService, previous) {
            return BookingsProvider(apiService: apiService);
          },
        ),
      ],
      child: MaterialApp(
        title: 'POMBUS',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.deepOrange,
          primaryColor: Colors.deepOrange,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/bookings': (context) => const BookingsScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/service-detail') {
            final service = settings.arguments as Service;
            return MaterialPageRoute(
              builder: (context) => ServiceDetailScreen(service: service),
            );
          } else if (settings.name == '/booking-detail') {
            final booking = settings.arguments as Booking;
            return MaterialPageRoute(
              builder: (context) => BookingDetailScreen(booking: booking),
            );
          }
          return null;
        },
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    await context.read<AuthProvider>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isLoggedIn) {
          return const HomeScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
