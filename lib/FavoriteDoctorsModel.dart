import 'package:flutter/material.dart';

class FavoriteDoctorsModel extends ChangeNotifier {
  List<Map<String, String>> _favoriteDoctors = [];

  List<Map<String, String>> get favoriteDoctors => _favoriteDoctors;

  void addFavorite(Map<String, String> doctor) {
    _favoriteDoctors.add(doctor);
    notifyListeners(); // Notifie les écouteurs pour rafraîchir les widgets.
  }

  void removeFavorite(Map<String, String> doctor) {
    _favoriteDoctors.remove(doctor);
    notifyListeners(); // Notifie les écouteurs pour rafraîchir les widgets.
  }
}
