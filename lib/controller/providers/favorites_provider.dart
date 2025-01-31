import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Set<String> _favorites = {}; // Locally cached favorite event IDs

  // Check if an event is a favorite
  bool isFavorite(String eventId) => _favorites.contains(eventId);

  // Toggle favorite status for a specific event
  Future<bool> toggleFavorite(String userId, String eventId, Map<String, dynamic> event) async {
    final favoritesCollection = _firestore.collection('users').doc(userId).collection('favorites');

    try {
      if (isFavorite(eventId)) {
        await removeFavorite(userId, eventId); // If it's a favorite, remove it
        return false; // Return false indicating it was removed
      } else {
        await addFavorite(userId, eventId, event); // Otherwise, add it
        return true; // Return true indicating it was added
      }
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
      rethrow;
    }
  }

  // Add an event to favorites
  Future<void> addFavorite(String userId, String eventId, Map<String, dynamic> event) async {
    final favoritesCollection = _firestore.collection('users').doc(userId).collection('favorites');

    try {
      await favoritesCollection.doc(eventId).set(event);
      _favorites.add(eventId); // Update local cache
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding favorite: $e');
      rethrow;
    }
  }

  // Remove an event from favorites
  Future<void> removeFavorite(String userId, String eventId) async {
    final favoritesCollection = _firestore.collection('users').doc(userId).collection('favorites');

    try {
      await favoritesCollection.doc(eventId).delete();
      _favorites.remove(eventId); // Update local cache
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing favorite: $e');
      rethrow;
    }
  }

  // Load favorites from Firestore into local cache
  Future<void> loadFavorites(String userId) async {
    final favoritesCollection = _firestore.collection('users').doc(userId).collection('favorites');

    try {
      final snapshot = await favoritesCollection.get();
      _favorites.clear(); // Clear the local cache
      for (final doc in snapshot.docs) {
        _favorites.add(doc.id); // Cache the favorite event IDs
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  // Stream of favorite events for a user
  Stream<QuerySnapshot> getFavoritesStream(String userId) {
    return _firestore.collection('users').doc(userId).collection('favorites').snapshots();
  }
}
