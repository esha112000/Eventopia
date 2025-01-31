import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventopia_app/controller/providers/favorites_provider.dart';
import 'package:eventopia_app/controller/providers/filter_provider.dart';
import 'package:eventopia_app/view/events/event_details.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class EventsListPage extends StatefulWidget {
  @override
  _EventsListPageState createState() => _EventsListPageState();
}

class _EventsListPageState extends State<EventsListPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<FilterProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text(
          'Please log in to view events.',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Events',
          style: TextStyle(color: Colors.orange),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.orange),
            onPressed: () {
              _showSearchBar(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.orange),
            onPressed: () {
              _showFilterBottomSheet(context, filterProvider);
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('events').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading events.'));
          }

          final events = snapshot.data?.docs ?? [];
          final filteredEvents = events.where((event) {
            final category = event['category'] as String?;
            final price = event['price'] as int?;
            final title = event['title'] as String?;
            final description = event['description'] as String?;

            return (filterProvider.selectedCategory == null ||
                    category == filterProvider.selectedCategory) &&
                (filterProvider.selectedPrice == null ||
                    price != null && price <= filterProvider.selectedPrice!) &&
                (searchQuery.isEmpty ||
                    (title != null && title.toLowerCase().contains(searchQuery.toLowerCase())) ||
                    (description != null &&
                        description.toLowerCase().contains(searchQuery.toLowerCase())));
          }).toList();

          if (filteredEvents.isEmpty) {
            return const Center(
              child: Text(
                'No events match your search or filters.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: filteredEvents.length,
            itemBuilder: (context, index) {
              final event = filteredEvents[index];
              final eventId = event.id;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventDetailsPage(
                        eventId: eventId,
                        eventData: event.data() as Map<String, dynamic>,
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  color: Colors.grey[900],
                  child: ListTile(
                    leading: Image.network(
                      event['imageUrl'] ?? 'https://via.placeholder.com/150',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      event['title'] ?? 'Untitled Event',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      event['description'] ?? 'No description available.',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        favoritesProvider.isFavorite(eventId)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        try {
                          final isAdded = await favoritesProvider.toggleFavorite(
                            user.uid,
                            eventId,
                            event.data() as Map<String, dynamic>,
                          );

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isAdded ? 'Added to favorites' : 'Removed from favorites',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.black87,
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Error updating favorites: $e',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

void _showSearchBar(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.black,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search events...',
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: const Icon(Icons.search, color: Colors.orange),
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {
              searchQuery = value.trim(); // Update the parent state
            });
          },
        ),
      );
    },
  );
}
  // Show Filter BottomSheet (unchanged)
  void _showFilterBottomSheet(BuildContext context, FilterProvider filterProvider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.black,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Filter Events',
                    style: TextStyle(color: Colors.orange, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Category',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: ['Music', 'Technology', 'Art', 'Sports', 'Food & Drinks']
                        .map((category) => FilterChip(
                              label: Text(category),
                              labelStyle: TextStyle(
                                color: filterProvider.selectedCategory == category
                                    ? Colors.white
                                    : Colors.orange,
                              ),
                              backgroundColor: Colors.grey[800],
                              selectedColor: Colors.orange,
                              selected: filterProvider.selectedCategory == category,
                              onSelected: (isSelected) {
                                setState(() {
                                  filterProvider.updateCategory(isSelected ? category : null);
                                });
                              },
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Price',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: [20, 50, 100, 200]
                        .map((price) => FilterChip(
                              label: Text('\$${price.toString()}'),
                              labelStyle: TextStyle(
                                color: filterProvider.selectedPrice == price
                                    ? Colors.white
                                    : Colors.orange,
                              ),
                              backgroundColor: Colors.grey[800],
                              selectedColor: Colors.orange,
                              selected: filterProvider.selectedPrice == price,
                              onSelected: (isSelected) {
                                setState(() {
                                  filterProvider.updatePrice(isSelected ? price : null);
                                });
                              },
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        filterProvider.clearFilters();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text('Clear Filters'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
