import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/index.dart';
import '../widgets/index.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({Key? key}) : super(key: key);

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  void _loadBookings() {
    context.read<BookingsProvider>().loadBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Reservas'), elevation: 0),
      body: Consumer<BookingsProvider>(
        builder: (context, bookingsProvider, _) {
          if (bookingsProvider.isLoading) {
            return const LoadingWidget(message: 'Carregando reservas...');
          }

          if (bookingsProvider.bookings.isEmpty) {
            return const EmptyWidget(
              message: 'Nenhuma reserva encontrada',
              icon: Icons.bookmark,
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _loadBookings();
            },
            child: ListView.builder(
              itemCount: bookingsProvider.bookings.length,
              itemBuilder: (context, index) {
                final booking = bookingsProvider.bookings[index];
                return BookingCard(
                  booking: booking,
                  onTap: () {
                    Navigator.of(
                      context,
                    ).pushNamed('/booking-detail', arguments: booking);
                  },
                  onCancel: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Cancelar Reserva'),
                        content: const Text(
                          'Tem a certeza que deseja cancelar esta reserva?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Não'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              bookingsProvider.cancelBooking(booking.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Reserva cancelada com sucesso',
                                  ),
                                ),
                              );
                            },
                            child: const Text('Sim'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Reservas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushNamed('/home');
          } else if (index == 2) {
            Navigator.of(context).pushNamed('/profile');
          }
        },
      ),
    );
  }
}
