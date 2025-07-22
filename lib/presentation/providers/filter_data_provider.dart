import 'package:flutter/foundation.dart';
import '../../data/datasources/streamnest_api_service.dart';
import '../../data/models/filterModel.dart';

class FilterDataProvider extends ChangeNotifier {
  final StreamNestApiService _apiService;

  // API Data
  FilterModelResponse? _filterData;
  bool _isLoading = false;
  String? _error;

  // User Selections
  String? _selectedRegion;
  List<String> _selectedChannels = [];
  List<String> _preferenceOrder = [];
  List<String> _otherFactorsOrder = [];

  FilterDataProvider({StreamNestApiService? apiService})
      : _apiService = apiService ?? StreamNestApiService();

  // API Data Getters
  FilterModelResponse? get filterData => _filterData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasData => _filterData != null;

  // User Selection Getters
  String? get selectedRegion => _selectedRegion;
  List<String> get selectedChannels => List.unmodifiable(_selectedChannels);
  List<String> get preferenceOrder => List.unmodifiable(_preferenceOrder);
  List<String> get otherFactorsOrder => List.unmodifiable(_otherFactorsOrder);

  // Load filter data from API
  Future<void> loadFilterData() async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('Loading filter data from API...');
      final response = await _apiService.getAppInitData();

      if (response.statusCode == 200) {
        final data = response.data;
        _filterData = FilterModelResponse.fromJson(data);
        print(
          'Filter data loaded successfully: ${_filterData?.data?.genres?.length ?? 0} genres',
        );
        
        final detectedCode = _filterData?.data?.detectedCountryCode;
        if (detectedCode != null && detectedCode.isNotEmpty) {
          _selectedRegion = detectedCode;
        }
      } else {
        _error = 'Failed to load filter data: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error loading filter data: $e';
      print('Exception loading filter data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get specific filter data
  List<Characteristic>? get genres => _filterData?.data?.filter?.genres;
  List<Characteristic>? get languages => _filterData?.data?.filter?.languages;
  List<Characteristic>? get ageSuitability =>
      _filterData?.data?.filter?.ageSuitability;
  List<Characteristic>? get duration => _filterData?.data?.filter?.duration;
  List<Characteristic>? get availability =>
      _filterData?.data?.filter?.availability;
  List<Characteristic>? get releaseYears =>
      _filterData?.data?.filter?.releaseYears;
  List<Characteristic>? get ratings => _filterData?.data?.filter?.ratings;
  List<DataCountry>? get countries => _filterData?.data?.countries;
  List<StreamingPlatform>? get streamingPlatforms =>
      _filterData?.data?.streamingPlatforms;

  // Region methods
  void setRegion(String region) {
    _selectedRegion = region;
    notifyListeners();
  }

  // Channel methods
  void setChannels(List<String> channels) {
    _selectedChannels = List.from(channels);
    notifyListeners();
  }

  void addChannel(String channel) {
    if (!_selectedChannels.contains(channel)) {
      _selectedChannels.add(channel);
      notifyListeners();
    }
  }

  void removeChannel(String channel) {
    _selectedChannels.remove(channel);
    notifyListeners();
  }

  // Preference methods
  void setPreferenceOrder(List<String> preferences) {
    _preferenceOrder = List.from(preferences);
    notifyListeners();
  }

  void addPreference(String preference) {
    if (!_preferenceOrder.contains(preference)) {
      _preferenceOrder.add(preference);
      notifyListeners();
    }
  }

  void reorderPreferences(List<String> newOrder) {
    _preferenceOrder = List.from(newOrder);
    notifyListeners();
  }

  void removePreference(String preference) {
    _preferenceOrder.remove(preference);
    notifyListeners();
  }

  void movePreferenceUp(int index) {
    if (index > 0) {
      final item = _preferenceOrder.removeAt(index);
      _preferenceOrder.insert(index - 1, item);
      notifyListeners();
    }
  }

  void movePreferenceDown(int index) {
    if (index < _preferenceOrder.length - 1) {
      final item = _preferenceOrder.removeAt(index);
      _preferenceOrder.insert(index + 1, item);
      notifyListeners();
    }
  }

  // Other Factors methods
  void addOtherFactor(String factor) {
    if (!_otherFactorsOrder.contains(factor)) {
      _otherFactorsOrder.add(factor);
      notifyListeners();
    }
  }

  void removeOtherFactor(String factor) {
    _otherFactorsOrder.remove(factor);
    notifyListeners();
  }

  void moveOtherFactorUp(int index) {
    if (index > 0) {
      final item = _otherFactorsOrder.removeAt(index);
      _otherFactorsOrder.insert(index - 1, item);
      notifyListeners();
    }
  }

  void moveOtherFactorDown(int index) {
    if (index < _otherFactorsOrder.length - 1) {
      final item = _otherFactorsOrder.removeAt(index);
      _otherFactorsOrder.insert(index + 1, item);
      notifyListeners();
    }
  }

  // Clear methods
  void clearAllPreferences() {
    _preferenceOrder.clear();
    notifyListeners();
  }

  void clearAllOtherFactors() {
    _otherFactorsOrder.clear();
    notifyListeners();
  }

  void clearAllSelections() {
    _selectedRegion = null;
    _selectedChannels.clear();
    _preferenceOrder.clear();
    _otherFactorsOrder.clear();
    notifyListeners();
  }

  // Clear API data
  void clearData() {
    _filterData = null;
    _error = null;
    notifyListeners();
  }

  // Refresh data
  Future<void> refreshData() async {
    clearData();
    await loadFilterData();
  }

  // Check if user has any preferences
  bool get hasPreferences =>
      _selectedRegion != null ||
          _selectedChannels.isNotEmpty ||
          _preferenceOrder.isNotEmpty ||
          _otherFactorsOrder.isNotEmpty;
}
