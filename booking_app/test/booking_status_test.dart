import 'package:flutter_test/flutter_test.dart';
import 'package:booking_app/models/booking.dart';

void main() {
  group('BookingStatus Tests', () {
    test('BookingStatusHelper.getStatusName should return correct string values', () {
      expect(BookingStatusHelper.getStatusName(BookingStatus.pending), 'pending');
      expect(BookingStatusHelper.getStatusName(BookingStatus.confirmed), 'confirmed');
      expect(BookingStatusHelper.getStatusName(BookingStatus.cancelled), 'cancelled');
      expect(BookingStatusHelper.getStatusName(BookingStatus.completed), 'completed');
    });

    test('Booking JSON serialization should work correctly', () {
      final booking = Booking(
        id: '1',
        fieldId: 'field1',
        userId: 'user1',
        bookingDate: DateTime(2024, 1, 1),
        startTime: '10:00',
        endTime: '11:00',
        totalPrice: 100000,
        status: BookingStatus.pending,
        createdAt: DateTime(2024, 1, 1),
      );

      final json = booking.toJson();
      expect(json['status'], 'pending');

      final deserializedBooking = Booking.fromJson(json);
      expect(deserializedBooking.status, BookingStatus.pending);
      expect(BookingStatusHelper.getStatusName(deserializedBooking.status), 'pending');
    });
  });
}