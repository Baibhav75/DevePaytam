import 'package:flutter/material.dart';
import '../../screens/home_screen.dart';
import '../data/dummy_data.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/category_card.dart';

class ShopHomeScreen extends StatelessWidget {
  const ShopHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // ✅

      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,

        /// 👈 POP ICON AS PREVIOUS PAGE
        leading: IconButton(
          onPressed: ()
          {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const HomeScreen(),
              ),
            );
          },
          icon: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.arrow_back ),
              SizedBox(width: 4),

            ],
          ),
        ),

        title: Text(
          ' ',
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.monetization_on),
                onPressed: () {},
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '417',
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ],
      ),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SHOP THE POP WAY',
              style: Theme.of(context).textTheme.titleMedium, // ✅
            ),
            const SizedBox(height: 4),
            Text(
              'More POPcoins better deals',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey), // ✅
            ),
            const SizedBox(height: 16),

            /// 🔥 Banner Carousel
            BannerCarousel(banners: promoBanners),

            const SizedBox(height: 24),
            Text(
              'CITIZEN CART',
              style: Theme.of(context).textTheme.titleLarge, // ✅
            ),
            const SizedBox(height: 4),
            Text(
              'Every essential, right at your fingertips.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey),
            ),

            const SizedBox(height: 16),

            /// 🔥 Category Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return CategoryCard(category: categories[index]);
              },
            ),
            const SizedBox(height: 24),
            /// 🚀 Today's featured brand card
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 6,
                    child: Image.network(
                      'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=1200&q=80',
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(
                          child: SizedBox(
                            height: 32,
                            width: 32,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stack) => Container(
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.05),
                            Colors.black.withOpacity(0.55),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "TODAY'S FEATURED BRAND",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Handpicked deals to make your POPcoins go further.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            /// 🛍️ Brand amendments grid
            Text(
              'BRAND AMENDMENTS',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Exciting deals on your favourites',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              itemCount: brandDeals.length,
              itemBuilder: (context, index) {
                final deal = brandDeals[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.blue.shade700, width: 2),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.network(
                                deal.image,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  color: Colors.grey.shade300,
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                height: 18,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Center(
                                  child: Text(
                                    '🔥',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        color: Colors.blue.shade900,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              deal.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                deal.subtitle,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );

  }
}


class Category {
  final String name;
  final String image;

  Category({
    required this.name,
    required this.image,
  });
}

class BrandDeal {
  final String title;
  final String subtitle;
  final String image;

  BrandDeal({
    required this.title,
    required this.subtitle,
    required this.image,
  });
}
