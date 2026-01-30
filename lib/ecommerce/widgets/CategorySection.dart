import 'package:flutter/material.dart';

import 'categories_list_page.dart';
class CategorySection extends StatelessWidget {

  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TITLE ROW
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Categories",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextButton(
              onPressed: () {

                // Navigate to Category full page
              },
              child: const Text(
                "View All",
                style: TextStyle(
                  color: Color(0xFF6200EA),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // CATEGORY GRID
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final item = categories[index];
            return _CategoryCard(
              title: item["title"]!,
              icon: item["icon"]!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoriesListPage(
                      category: item["title"],
                    ),
                  ),
                );
              },
            );
          },

        ),
      ],
    );
  }
}
class _CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ICON CONTAINER
            Container(
              height: 58,
              width: 58,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF6B46C1).withOpacity(0.15),
                    const Color(0xFF6B46C1).withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6B46C1).withOpacity(0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 28,
                color: const Color(0xFF6B46C1),
              ),
            ),

            const SizedBox(height: 10),

            // TITLE
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


final List<Map<String, dynamic>> categories = [
  {
    "title": "Men",
    "icon": Icons.man,
  },
  {
    "title": "Women",
    "icon": Icons.woman,
  },
  {
    "title": "Kids",
    "icon": Icons.child_care,
  },
  {
    "title": "Footwear",
    "icon": Icons.shopping_bag,
  },
  {
    "title": "Accessories",
    "icon": Icons.watch,
  },
  {
    "title": "Beauty",
    "icon": Icons.brush,
  },
  {
    "title": "Winter Wear",
    "icon": Icons.ac_unit,
  },
  {
    "title": "More",
    "icon": Icons.more_horiz,
  },
];
