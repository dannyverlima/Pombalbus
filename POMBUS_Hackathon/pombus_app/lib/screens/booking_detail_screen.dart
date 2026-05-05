import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/index.dart';

class BookingDetailScreen extends StatelessWidget {
  final Booking booking;

  const BookingDetailScreen({Key? key, required this.booking})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final currencyFormat = NumberFormat.currency(symbol: '€');

    Color statusColor;
    String statusLabel;

    switch (booking.status) {
      case BookingStatus.confirmed:
        statusColor = Colors.green;
        statusLabel = 'Confirmada';
        break;
      case BookingStatus.completed:
        statusColor = Colors.blue;
        statusLabel = 'Completa';
        break;
      case BookingStatus.cancelled:
        statusColor = Colors.red;
        statusLabel = 'Cancelada';
        break;
      case BookingStatus.pending:
        statusColor = Colors.orange;
        statusLabel = 'Pendente';
        break;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da Reserva'), elevation: 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Card
              Card(
                color: statusColor.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: statusColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status da Reserva',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            statusLabel,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Icon(_getStatusIcon(), color: statusColor, size: 40),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Booking Information
              _buildSection('Informações da Viagem', [
                _buildInfoRow('Origem', booking.origin),
                _buildInfoRow('Destino', booking.destination),
                _buildInfoRow(
                  'Data de Partida',
                  dateFormat.format(booking.departureTime),
                ),
                _buildInfoRow(
                  'Data de Chegada',
                  dateFormat.format(booking.arrivalTime),
                ),
              ]),
              const SizedBox(height: 16),
              _buildSection('Detalhes da Reserva', [
                _buildInfoRow('ID da Reserva', booking.id),
                _buildInfoRow('Passageiros', '${booking.passengers}'),
                _buildInfoRow(
                  'Preço Total',
                  currencyFormat.format(booking.totalPrice),
                ),
                _buildInfoRow(
                  'Data de Criação',
                  dateFormat.format(booking.createdAt),
                ),
              ]),
              if (booking.notes.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildSection('Notas', [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      booking.notes,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ]),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getStatusIcon() {
    switch (booking.status) {
      case BookingStatus.confirmed:
        return Icons.check_circle;
      case BookingStatus.completed:
        return Icons.done_all;
      case BookingStatus.cancelled:
        return Icons.cancel;
      case BookingStatus.pending:
        return Icons.schedule;
    }
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
