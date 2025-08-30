import 'package:get/get.dart';
import '../models/sport.dart';

class SportsController extends GetxController {
  final RxList<Sport> _sports = <Sport>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _selectedSportId = ''.obs;

  List<Sport> get sports => _sports;
  bool get isLoading => _isLoading.value;
  String get selectedSportId => _selectedSportId.value;

  Sport? get selectedSport {
    if (_selectedSportId.value.isEmpty) return null;
    return _sports.firstWhereOrNull((sport) => sport.id == _selectedSportId.value);
  }

  @override
  void onInit() {
    super.onInit();
    loadSports();
  }

  Future<void> loadSports() async {
    try {
      _isLoading.value = true;
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      final sampleSports = [
        Sport(
          id: '1',
          name: 'Football',
          icon: '⚽',
          description: 'The beautiful game played on grass fields',
          tags: ['team sport', 'outdoor', 'popular'],
        ),
        Sport(
          id: '2',
          name: 'Basketball',
          icon: '🏀',
          description: 'Fast-paced indoor and outdoor sport',
          tags: ['team sport', 'indoor', 'outdoor'],
        ),
        Sport(
          id: '3',
          name: 'Tennis',
          icon: '🎾',
          description: 'Racquet sport for singles or doubles',
          tags: ['individual', 'outdoor', 'indoor'],
        ),
        Sport(
          id: '4',
          name: 'Badminton',
          icon: '🏸',
          description: 'Indoor racquet sport with shuttlecock',
          tags: ['individual', 'indoor', 'doubles'],
        ),
        Sport(
          id: '5',
          name: 'Volleyball',
          icon: '🏐',
          description: 'Team sport played over a net',
          tags: ['team sport', 'indoor', 'outdoor'],
        ),
        Sport(
          id: '6',
          name: 'Swimming',
          icon: '🏊',
          description: 'Water sport in pools or open water',
          tags: ['individual', 'water sport', 'fitness'],
        ),
        Sport(
          id: '7',
          name: 'Futsal',
          icon: '⚽',
          description: 'Indoor version of football',
          tags: ['team sport', 'indoor', 'fast-paced'],
        ),
        Sport(
          id: '8',
          name: 'Table Tennis',
          icon: '🏓',
          description: 'Indoor paddle sport on a table',
          tags: ['individual', 'indoor', 'quick'],
        ),
      ];
      
      _sports.assignAll(sampleSports);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load sports: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void selectSport(String sportId) {
    _selectedSportId.value = sportId;
  }

  void clearSelection() {
    _selectedSportId.value = '';
  }

  Future<void> refreshSports() async {
    await loadSports();
  }
}