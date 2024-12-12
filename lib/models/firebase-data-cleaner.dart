import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FirebaseDataCleaner {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to delete all documents from a specific collection
  Future<void> deleteCollection(String collectionPath) async {
    try {
      // Get all documents in the collection
      QuerySnapshot querySnapshot = await _firestore.collection(collectionPath).get();
      
      // Delete each document
      for (DocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      
      print('Successfully deleted all documents from $collectionPath');
    } catch (e) {
      print('Error deleting collection $collectionPath: $e');
    }
  }

  // Method to delete all documents from multiple collections
  Future<void> deleteMultipleCollections(List<String> collectionPaths) async {
    for (String path in collectionPaths) {
      await deleteCollection(path);
    }
  }

  // Comprehensive method to clear all generated test data
  Future<void> clearAllTestData() async {
    List<String> collectionsToDelete = [
      'users',
      'patients',
      'doctors',
      'service_providers',
      'appointments',
      'doctor_works_at_service_provider',
    ];

    await deleteMultipleCollections(collectionsToDelete);
    print('All test data has been cleared from Firebase');
  }
}

void main() async {
  // Ensure Firebase is initialized
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Create an instance of the data cleaner
  FirebaseDataCleaner cleaner = FirebaseDataCleaner();

  // Choose one of these methods:

  // 1. Delete all documents from a single collection
  // await cleaner.deleteCollection('users');

  // 2. Delete multiple specific collections
  // await cleaner.deleteMultipleCollections(['users', 'patients']);

  // 3. Clear all test data comprehensively
  await cleaner.clearAllTestData();
}
