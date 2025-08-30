import 'package:get/get.dart';
import '../models/booking.dart';

class BookingController extends GetxController {
  final RxList<Booking> _bookings = <Booking>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _selectedFieldId = ''.obs;
  final Rx<DateTime> _selectedDate = DateTime.now().obs;
  final RxString _selectedStartTime = ''.obs;
  final RxString _selectedEndTime = ''.obs;
  final RxDouble _totalPrice = 0.0.obs;
  final RxString _notes = ''.obs;

  List<Booking> get bookings => _bookings;
  bool get isLoading => _isLoading.value;
  String get selectedFieldId => _selectedFieldId.value;
  DateTime get selectedDate => _selectedDate.value;
  String get selectedStartTime => _selectedStartTime.value;
  String get selectedEndTime => _selectedEndTime.value;
  double get totalPrice => _totalPrice.value;
  String get notes => _notes.value;

  List<Booking> get upcomingBookings {
    final now = DateTime.now();
    return _bookings
        .where((booking) => 
            booking.bookingDate.isAfter(now) && 
            booking.status != BookingStatus.cancelled)
        .toList()
      ..sort((a, b) => a.bookingDate.compareTo(b.bookingDate));
  }

  List<Booking> get pastBookings {
    final now = DateTime.now();
    return _bookings
        .where((booking) => booking.bookingDate.isBefore(now))
        .toList()
      ..sort((a, b) => b.bookingDate.compareTo(a.bookingDate));
  }

  @override
  void onInit() {
    super.onInit();
    loadBookings();
  }

  Future<void> loadBookings() async {
    try {
      _isLoading.value = true;
      
      await Future.delayed(const Duration(milliseconds: 600));
      
      final sampleBookings = [
        Booking(
          id: '1',
          fieldId: '1',
          userId: 'user1',
          bookingDate: DateTime.now().add(const Duration(days: 2)),
          startTime: '19:00',
          endTime: '20:00',
          totalPrice: 150000,
          status: BookingStatus.confirmed,
          notes: 'Birthday celebration game',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Booking(
          id: '2',
          fieldId: '2',
          userId: 'user1',
          bookingDate: DateTime.now().add(const Duration(days: 5)),
          startTime: '18:00',
          endTime: '19:00',
          totalPrice: 80000,
          status: BookingStatus.pending,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        Booking(
          id: '3',
          fieldId: '3',
          userId: 'user1',
          bookingDate: DateTime.now().subtract(const Duration(days: 3)),
          startTime: '08:00',
          endTime: '09:00',
          totalPrice: 120000,
          status: BookingStatus.completed,
          notes: 'Morning practice session',
          createdAt: DateTime.now().subtract(const Duration(days: 4)),
        ),
      ];
      
      _bookings.assignAll(sampleBookings);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load bookings: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void setBookingDetails({
    required String fieldId,
    required DateTime date,
    required String startTime,
    required String endTime,
    required double pricePerHour,
  }) {
    _selectedFieldId.value = fieldId;
    _selectedDate.value = date;
    _selectedStartTime.value = startTime;
    _selectedEndTime.value = endTime;
    
    final start = _parseTime(startTime);
    final end = _parseTime(endTime);
    final hours = (end - start) / 60;
    _totalPrice.value = hours * pricePerHour;
  }

  void setNotes(String newNotes) {
    _notes.value = newNotes;
  }

  int _parseTime(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  Future<bool> createBooking() async {
    try {
      _isLoading.value = true;
      
      await Future.delayed(const Duration(milliseconds: 1000));
      
      final newBooking = Booking(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fieldId: _selectedFieldId.value,
        userId: 'user1',
        bookingDate: _selectedDate.value,
        startTime: _selectedStartTime.value,
        endTime: _selectedEndTime.value,
        totalPrice: _totalPrice.value,
        status: BookingStatus.pending,
        notes: _notes.value.isEmpty ? null : _notes.value,
        createdAt: DateTime.now(),
      );
      
      _bookings.add(newBooking);
      
      Get.snackbar(
        'Success',
        'Booking created successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
      
      clearBookingForm();
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create booking: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> cancelBooking(String bookingId) async {
    try {
      _isLoading.value = true;
      
      await Future.delayed(const Duration(milliseconds: 800));
      
      final bookingIndex = _bookings.indexWhere((b) => b.id == bookingId);
      if (bookingIndex != -1) {
        final updatedBooking = _bookings[bookingIndex].copyWith(
          status: BookingStatus.cancelled,
          updatedAt: DateTime.now(),
        );
        _bookings[bookingIndex] = updatedBooking;
        
        Get.snackbar(
          'Success',
          'Booking cancelled successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to cancel booking: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  void clearBookingForm() {
    _selectedFieldId.value = '';
    _selectedDate.value = DateTime.now();
    _selectedStartTime.value = '';
    _selectedEndTime.value = '';
    _totalPrice.value = 0.0;
    _notes.value = '';
  }

  Future<void> refreshBookings() async {
    await loadBookings();
  }

  List<String> getBookedHours(String fieldId, DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    return _bookings
        .where((booking) =>
            booking.fieldId == fieldId &&
            DateTime(booking.bookingDate.year, booking.bookingDate.month, booking.bookingDate.day)
                .isAtSameMomentAs(dateOnly) &&
            booking.status != BookingStatus.cancelled)
        .expand((booking) => _getHourRange(booking.startTime, booking.endTime))
        .toList();
  }

  List<String> _getHourRange(String startTime, String endTime) {
    final List<String> hours = [];
    final start = _parseTime(startTime);
    final end = _parseTime(endTime);
    
    for (int minute = start; minute < end; minute += 60) {
      final hour = minute ~/ 60;
      hours.add('${hour.toString().padLeft(2, '0')}:00');
    }
    
    return hours;
  }
}