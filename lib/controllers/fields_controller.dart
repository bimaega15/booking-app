import 'package:get/get.dart';
import '../models/field.dart';

class FieldsController extends GetxController {
  final RxList<Field> _fields = <Field>[].obs;
  final RxList<Field> _filteredFields = <Field>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _selectedFieldId = ''.obs;
  final RxString _searchQuery = ''.obs;
  final RxString _selectedSportId = ''.obs;
  
  // Filter variables
  final RxString _filterLocation = ''.obs;
  final RxDouble _filterMinPrice = 0.0.obs;
  final RxDouble _filterMaxPrice = double.infinity.obs;
  final RxList<String> _filterTimeSlots = <String>[].obs;

  List<Field> get fields => _fields;
  List<Field> get filteredFields => _filteredFields;
  bool get isLoading => _isLoading.value;
  String get selectedFieldId => _selectedFieldId.value;
  String get searchQuery => _searchQuery.value;

  Field? get selectedField {
    if (_selectedFieldId.value.isEmpty) return null;
    return _fields.firstWhereOrNull((field) => field.id == _selectedFieldId.value);
  }

  @override
  void onInit() {
    super.onInit();
    loadFields();
    
    ever(_searchQuery, (_) => _filterFields());
    ever(_selectedSportId, (_) => _filterFields());
    ever(_filterLocation, (_) => _filterFields());
    ever(_filterMinPrice, (_) => _filterFields());
    ever(_filterMaxPrice, (_) => _filterFields());
    ever(_filterTimeSlots, (_) => _filterFields());
  }

  Future<void> loadFields() async {
    try {
      _isLoading.value = true;
      
      await Future.delayed(const Duration(milliseconds: 800));
      
      final sampleFields = [
        Field(
          id: '1',
          name: 'Green Field Football Stadium',
          sportId: '1',
          location: 'Jakarta Selatan',
          address: 'Jl. Sudirman No. 123, Jakarta Selatan',
          latitude: -6.2088,
          longitude: 106.8456,
          pricePerHour: 150000,
          images: [
            'https://images.unsplash.com/photo-1431324155629-1a6deb1dec8d?w=800',
            'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=800',
          ],
          description: 'Premium football field with natural grass and modern facilities',
          facilities: ['Parking', 'Changing Room', 'Shower', 'Canteen', 'Sound System'],
          rating: 4.5,
          reviewCount: 127,
          availableHours: {
            'Monday': ['06:00', '07:00', '08:00', '19:00', '20:00', '21:00'],
            'Tuesday': ['06:00', '07:00', '08:00', '19:00', '20:00', '21:00'],
            'Wednesday': ['06:00', '07:00', '08:00', '19:00', '20:00', '21:00'],
            'Thursday': ['06:00', '07:00', '08:00', '19:00', '20:00', '21:00'],
            'Friday': ['06:00', '07:00', '08:00', '19:00', '20:00', '21:00'],
            'Saturday': ['06:00', '07:00', '08:00', '09:00', '10:00', '11:00', '19:00', '20:00', '21:00'],
            'Sunday': ['06:00', '07:00', '08:00', '09:00', '10:00', '11:00', '19:00', '20:00', '21:00'],
          },
        ),
        Field(
          id: '2',
          name: 'Court Basketball Arena',
          sportId: '2',
          location: 'Jakarta Pusat',
          address: 'Jl. Thamrin No. 45, Jakarta Pusat',
          latitude: -6.1944,
          longitude: 106.8229,
          pricePerHour: 80000,
          images: [
            'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=800',
            'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800',
          ],
          description: 'Indoor basketball court with professional-grade flooring',
          facilities: ['Air Conditioning', 'Parking', 'Changing Room', 'Equipment Rental'],
          rating: 4.2,
          reviewCount: 89,
          availableHours: {
            'Monday': ['07:00', '08:00', '09:00', '18:00', '19:00', '20:00'],
            'Tuesday': ['07:00', '08:00', '09:00', '18:00', '19:00', '20:00'],
            'Wednesday': ['07:00', '08:00', '09:00', '18:00', '19:00', '20:00'],
            'Thursday': ['07:00', '08:00', '09:00', '18:00', '19:00', '20:00'],
            'Friday': ['07:00', '08:00', '09:00', '18:00', '19:00', '20:00'],
            'Saturday': ['08:00', '09:00', '10:00', '11:00', '14:00', '15:00', '16:00', '17:00'],
            'Sunday': ['08:00', '09:00', '10:00', '11:00', '14:00', '15:00', '16:00', '17:00'],
          },
        ),
        Field(
          id: '3',
          name: 'Elite Tennis Club',
          sportId: '3',
          location: 'Jakarta Utara',
          address: 'Jl. Kelapa Gading No. 78, Jakarta Utara',
          latitude: -6.1598,
          longitude: 106.9058,
          pricePerHour: 120000,
          images: [
            'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=800',
            'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6?w=800',
          ],
          description: 'Professional tennis courts with clay and hard court surfaces',
          facilities: ['Pro Shop', 'Coaching', 'Parking', 'Clubhouse', 'Restaurant'],
          rating: 4.7,
          reviewCount: 203,
          availableHours: {
            'Monday': ['06:00', '07:00', '08:00', '17:00', '18:00', '19:00'],
            'Tuesday': ['06:00', '07:00', '08:00', '17:00', '18:00', '19:00'],
            'Wednesday': ['06:00', '07:00', '08:00', '17:00', '18:00', '19:00'],
            'Thursday': ['06:00', '07:00', '08:00', '17:00', '18:00', '19:00'],
            'Friday': ['06:00', '07:00', '08:00', '17:00', '18:00', '19:00'],
            'Saturday': ['06:00', '07:00', '08:00', '09:00', '10:00', '15:00', '16:00', '17:00'],
            'Sunday': ['06:00', '07:00', '08:00', '09:00', '10:00', '15:00', '16:00', '17:00'],
          },
        ),
        Field(
          id: '4',
          name: 'Badminton Central',
          sportId: '4',
          location: 'Jakarta Barat',
          address: 'Jl. Puri Indah No. 56, Jakarta Barat',
          latitude: -6.1888,
          longitude: 106.7398,
          pricePerHour: 60000,
          images: [
            'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=800',
          ],
          description: 'Modern badminton hall with 8 courts and wooden flooring',
          facilities: ['Air Conditioning', 'Equipment Rental', 'Parking', 'Canteen'],
          rating: 4.3,
          reviewCount: 156,
          availableHours: {
            'Monday': ['07:00', '08:00', '09:00', '18:00', '19:00', '20:00', '21:00'],
            'Tuesday': ['07:00', '08:00', '09:00', '18:00', '19:00', '20:00', '21:00'],
            'Wednesday': ['07:00', '08:00', '09:00', '18:00', '19:00', '20:00', '21:00'],
            'Thursday': ['07:00', '08:00', '09:00', '18:00', '19:00', '20:00', '21:00'],
            'Friday': ['07:00', '08:00', '09:00', '18:00', '19:00', '20:00', '21:00'],
            'Saturday': ['07:00', '08:00', '09:00', '10:00', '14:00', '15:00', '16:00', '17:00'],
            'Sunday': ['07:00', '08:00', '09:00', '10:00', '14:00', '15:00', '16:00', '17:00'],
          },
        ),
      ];
      
      _fields.assignAll(sampleFields);
      _filteredFields.assignAll(sampleFields);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load fields: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void filterBySport(String sportId) {
    _selectedSportId.value = sportId;
  }

  void searchFields(String query) {
    _searchQuery.value = query;
  }

  void _filterFields() {
    List<Field> filtered = _fields;

    // Filter by sport
    if (_selectedSportId.value.isNotEmpty) {
      filtered = filtered.where((field) => field.sportId == _selectedSportId.value).toList();
    }

    // Filter by search query
    if (_searchQuery.value.isNotEmpty) {
      final query = _searchQuery.value.toLowerCase();
      filtered = filtered.where((field) =>
          field.name.toLowerCase().contains(query) ||
          field.location.toLowerCase().contains(query) ||
          field.address.toLowerCase().contains(query)).toList();
    }

    // Filter by location
    if (_filterLocation.value.isNotEmpty) {
      filtered = filtered.where((field) => 
          field.location.toLowerCase().contains(_filterLocation.value.toLowerCase())).toList();
    }

    // Filter by price range
    if (_filterMinPrice.value > 0 || _filterMaxPrice.value < double.infinity) {
      filtered = filtered.where((field) =>
          field.pricePerHour >= _filterMinPrice.value &&
          field.pricePerHour <= _filterMaxPrice.value).toList();
    }

    // Filter by time slots
    if (_filterTimeSlots.isNotEmpty) {
      filtered = filtered.where((field) {
        for (String timeSlot in _filterTimeSlots) {
          final times = timeSlot.split(' - ');
          if (times.length == 2) {
            final startTime = times[0];
            final endTime = times[1];
            
            // Check if field has availability in this time range
            bool hasAvailability = false;
            for (List<String> dayHours in field.availableHours.values) {
              if (dayHours.contains(startTime) || dayHours.contains(endTime)) {
                hasAvailability = true;
                break;
              }
            }
            if (hasAvailability) return true;
          }
        }
        return false;
      }).toList();
    }

    _filteredFields.assignAll(filtered);
  }

  void selectField(String fieldId) {
    _selectedFieldId.value = fieldId;
  }

  void clearSelection() {
    _selectedFieldId.value = '';
  }

  void clearFilters() {
    _searchQuery.value = '';
    _selectedSportId.value = '';
    _filterLocation.value = '';
    _filterMinPrice.value = 0.0;
    _filterMaxPrice.value = double.infinity;
    _filterTimeSlots.clear();
  }

  void applyFilters({
    String? location,
    double? minPrice,
    double? maxPrice,
    List<String>? timeSlots,
  }) {
    _filterLocation.value = location ?? '';
    _filterMinPrice.value = minPrice ?? 0.0;
    _filterMaxPrice.value = maxPrice ?? double.infinity;
    _filterTimeSlots.assignAll(timeSlots ?? []);
  }

  Future<void> refreshFields() async {
    await loadFields();
  }
}