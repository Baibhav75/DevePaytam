import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'payment_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _recentSearches = [
    {'name': 'John', 'icon': Icons.person},
    {'name': 'Mavis', 'icon': Icons.person},
    {'name': 'Claude', 'icon': Icons.person},
    {'name': 'Rem', 'icon': Icons.person},
    {'name': 'Chris', 'icon': Icons.person},
  ];

  final List<Map<String, dynamic>> _allPeople = [
    {'name': 'Albert Flores', 'phone': '+91 1234567890', 'icon': Icons.person},
    {'name': 'Wade Warren', 'phone': '+91 1234567890', 'icon': Icons.person},
    {'name': 'Jenny Wilson', 'phone': '+91 1234567890', 'icon': Icons.person},
    {'name': 'Guy Hawkins', 'phone': '+91 1234567890', 'icon': Icons.person},
    {'name': 'Jacob Jones', 'phone': '+91 1234567890', 'icon': Icons.person},
    {'name': 'Bessie Cooper', 'phone': '+91 1234567890', 'icon': Icons.person},
    {'name': 'Ralph Edwards', 'phone': '+91 1234567890', 'icon': Icons.person},
    {'name': 'Darlene Robertson', 'phone': '+91 1234567890', 'icon': Icons.person},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearRecentSearches() {
    setState(() {
      _recentSearches.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPrimaryTeal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Search',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: kCardLight.withOpacity(0.3),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: kPrimaryTeal),
                hintText: 'Search by name or number',
                hintStyle: TextStyle(color: kPrimaryTeal.withOpacity(0.6)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recent Search Section
                  if (_recentSearches.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recent search',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: _clearRecentSearches,
                            child: const Text(
                              'Clear all',
                              style: TextStyle(
                                color: kPrimaryTeal,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: _recentSearches.map((contact) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Column(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: kCardLight.withOpacity(0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    contact['icon'],
                                    color: kPrimaryTeal,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  contact['name'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  // All People Section
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Text(
                      'All people',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _allPeople.length,
                    itemBuilder: (context, index) {
                      final person = _allPeople[index];
                      return ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: kCardLight.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            person['icon'],
                            color: kPrimaryTeal,
                            size: 28,
                          ),
                        ),
                        title: Text(
                          person['name'],
                          style: const TextStyle(
                            color: kPrimaryTeal,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          person['phone'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PaymentScreen(
                                contactName: person['name'] as String,
                                phoneNumber: person['phone'] as String,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

