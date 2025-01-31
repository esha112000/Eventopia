import 'package:flutter/foundation.dart';

class FilterProvider with ChangeNotifier {
  String? _selectedCategory;
  int? _selectedPrice; // Change from maxPrice to selectedPrice

  String? get selectedCategory => _selectedCategory;
  int? get selectedPrice => _selectedPrice; // Getter for selected price

  void updateCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void updatePrice(int? price) { // Add updatePrice method
    _selectedPrice = price;
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategory = null;
    _selectedPrice = null; // Clear selectedPrice as well
    notifyListeners();
  }
}
