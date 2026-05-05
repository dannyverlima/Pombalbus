enum BookingStatus { pending, confirmed, completed, cancelled }

class Booking {
  final String id;
  final String userId;
  final String serviceId;
  final String origin;
  final String destination;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final int passengers;
  final double totalPrice;
  final BookingStatus status;
  final String notes;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.origin,
    required this.destination,
    required this.departureTime,
    required this.arrivalTime,
    required this.passengers,
    required this.totalPrice,
    required this.status,
    required this.notes,
    required this.createdAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      userId: json['userId'] as String,
      serviceId: json['serviceId'] as String,
      origin: json['origin'] as String,
      destination: json['destination'] as String,
      departureTime: DateTime.parse(json['departureTime'] as String),
      arrivalTime: DateTime.parse(json['arrivalTime'] as String),
      passengers: json['passengers'] as int,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: BookingStatus.values.firstWhere(
        (e) => e.toString() == 'BookingStatus.${json['status']}',
        orElse: () => BookingStatus.pending,
      ),
      notes: json['notes'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'serviceId': serviceId,
      'origin': origin,
      'destination': destination,
      'departureTime': departureTime.toIso8601String(),
      'arrivalTime': arrivalTime.toIso8601String(),
      'passengers': passengers,
      'totalPrice': totalPrice,
      'status': status.toString().replaceFirst('BookingStatus.', ''),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
