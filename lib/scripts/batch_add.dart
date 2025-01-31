import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addFreeEvents() async {
  final db = FirebaseFirestore.instance;
  final batch = db.batch();

  // Define 10 new free events
  List<Map<String, dynamic>> freeEvents = [
    {"title": "Community Yoga Class", "category": "Health & Wellness", "date": "2025-02-05", "description": "Join us for a relaxing yoga session.", "imageUrl": "https://example.com/free_event1.jpg", "location": "Central Park, NY", "price": 0},
    {"title": "Open Mic Night", "category": "Entertainment", "date": "2025-02-12", "description": "Showcase your talent at our open mic night.", "imageUrl": "https://example.com/free_event2.jpg", "location": "The Green Room, LA", "price": 0},
    {"title": "Art Workshop for Beginners", "category": "Art", "date": "2025-03-01", "description": "Learn the basics of painting and drawing.", "imageUrl": "https://example.com/free_event3.jpg", "location": "Art Center, SF", "price": 0},
    {"title": "Tech Meet & Greet", "category": "Technology", "date": "2025-03-10", "description": "Network with tech enthusiasts and professionals.", "imageUrl": "https://example.com/free_event4.jpg", "location": "Silicon Valley, CA", "price": 0},
    {"title": "Book Club Meetup", "category": "Education", "date": "2025-03-15", "description": "Discuss the latest bestsellers with fellow readers.", "imageUrl": "https://example.com/free_event5.jpg", "location": "City Library, Seattle", "price": 0},
    {"title": "Local Farmers Market", "category": "Food & Drinks", "date": "2025-04-01", "description": "Support local farmers and enjoy fresh produce.", "imageUrl": "https://example.com/free_event6.jpg", "location": "Town Square, Austin", "price": 0},
    {"title": "Community Clean-Up Drive", "category": "Community", "date": "2025-04-15", "description": "Help us clean up the neighborhood.", "imageUrl": "https://example.com/free_event7.jpg", "location": "Beachfront, Miami", "price": 0},
    {"title": "Outdoor Movie Night", "category": "Entertainment", "date": "2025-05-05", "description": "Enjoy a movie under the stars.", "imageUrl": "https://example.com/free_event8.jpg", "location": "Riverside Park, Denver", "price": 0},
    {"title": "Free Coding Bootcamp", "category": "Education", "date": "2025-05-20", "description": "Learn the basics of coding in this free workshop.", "imageUrl": "https://example.com/free_event9.jpg", "location": "Tech Hub, Boston", "price": 0},
    {"title": "Fitness Bootcamp", "category": "Health & Wellness", "date": "2025-06-01", "description": "Get fit with our free outdoor bootcamp.", "imageUrl": "https://example.com/free_event10.jpg", "location": "Fitness Center, Dallas", "price": 0},
  ];

  // Add each event to Firestore
  for (int i = 0; i < freeEvents.length; i++) {
    var eventRef = db.collection("events").doc("free_event_${DateTime.now().millisecondsSinceEpoch}_$i");
    batch.set(eventRef, freeEvents[i]);
  }

  try {
    await batch.commit();
    print("Successfully added ${freeEvents.length} new free events to Firestore.");
  } catch (e) {
    print("Error adding free events: $e");
  }
}
