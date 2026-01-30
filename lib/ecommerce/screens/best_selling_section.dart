import 'package:flutter/material.dart';
class BestSellingSection extends StatelessWidget {
  const BestSellingSection({super.key});

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
              "Best Selling",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to full Best Selling page
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

        // HORIZONTAL PRODUCT LIST
        SizedBox(
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: bestSellingProducts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = bestSellingProducts[index];
              return _BestSellingCard(
                imageUrl: item["image"]!,
                title: item["title"]!,
                price: item["price"]!,
                mrp: item["mrp"]!,
                discount: item["discount"]!,
                onTap: () {
                  // Navigator.push(...)
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
class _BestSellingCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;
  final String mrp;
  final String discount;
  final VoidCallback onTap;

  const _BestSellingCard({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.mrp,
    required this.discount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                imageUrl,
                height: 110,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // PRICE ROW
                  Row(
                    children: [
                      Text(
                        "₹$price",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "₹$mrp",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // DISCOUNT
                  Text(
                    discount,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
final List<Map<String, String>> bestSellingProducts = [
  {
    "title": "English Reader Book",
    "price": "299",
    "mrp": "499",
    "discount": "40% OFF",
    "image":
    "https://images.unsplash.com/photo-1524995997946-a1c2e315a42f",
  },
  {
    "title": "Maths Practice Workbook",
    "price": "199",
    "mrp": "349",
    "discount": "43% OFF",
    "image":
    "https://images.unsplash.com/photo-1512820790803-83ca734da794",
  },
  {
    "title": "Science Activity Book",
    "price": "249",
    "mrp": "399",
    "discount": "38% OFF",
    "image":
    "https://images.unsplash.com/photo-1524578271613-eb4b93c1b7c4",
  },
];
