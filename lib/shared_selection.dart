class SharedSelection {
  // List of selected attractions (e.g. names or objects)
  static List<String> selectedAttractions = [];

  // List of selected hotels with associated data (name, dates, budget)
  static List<Map<String, dynamic>> selectedHotels = [];

  /// Add a hotel only if it doesn't already exist (same name and dates)
  static void addHotel({
    required String name,
    required String checkIn,
    required String checkOut,
    required double budget,
  }) {
    final exists = selectedHotels.any((hotel) =>
        hotel['name'] == name &&
        hotel['checkIn'] == checkIn &&
        hotel['checkOut'] == checkOut);

    if (!exists) {
      selectedHotels.add({
        'name': name,
        'checkIn': checkIn,
        'checkOut': checkOut,
        'budget': budget,
      });
    }
  }

  /// Remove a hotel by name and dates
  static void removeHotel(String name, String checkIn, String checkOut) {
    selectedHotels.removeWhere((hotel) =>
        hotel['name'] == name &&
        hotel['checkIn'] == checkIn &&
        hotel['checkOut'] == checkOut);
  }

  /// Clear all selections (optional reset method)
  static void clearAll() {
    selectedAttractions.clear();
    selectedHotels.clear();
  }
}
