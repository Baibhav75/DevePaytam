import 'package:flutter/material.dart';

class ImageBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback onTap;
  final double height;
  final double width;

  const ImageBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onTap,
    this.height = 180,
    this.width = 320, // 👈 FIXED WIDTH
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.65),
                Colors.black.withOpacity(0.25),
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class ShoppingBannerSlider extends StatefulWidget {
  const ShoppingBannerSlider({super.key});

  @override
  State<ShoppingBannerSlider> createState() => _ShoppingBannerSliderState();
}

class _ShoppingBannerSliderState extends State<ShoppingBannerSlider> {
  final PageController _controller =
  PageController(viewportFraction: 0.82);

  int _currentIndex = 0;

  final List<Map<String, String>> banners = [
    {
      "title": "top rating ",
      "subtitle": "hot Deal ",
      "image":
      "https://images.unsplash.com/photo-1559526324-593bc073d938",
    },
    {
      "title": "shoping ",
      "subtitle": "Vehicle, Health & Life",
      "image":
      "https://images.unsplash.com/photo-1559526324-593bc073d938",
    },
    {
      "title": "Investments",
      "subtitle": "Mutual Funds, SIP",
      "image":
      "https://images.unsplash.com/photo-1559526324-593bc073d938",
    },
  ];

  @override
  void initState() {
    super.initState();

    // 🔁 AUTO SCROLL
    Future.delayed(const Duration(seconds: 3), autoScroll);
  }

  void autoScroll() {
    if (!mounted) return;

    _currentIndex = (_currentIndex + 1) % banners.length;
    _controller.animateToPage(
      _currentIndex,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );

    Future.delayed(const Duration(seconds: 3), autoScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ================= SLIDER =================
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _controller,
            itemCount: banners.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              final item = banners[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ImageBanner(
                  title: item["title"]!,
                  subtitle: item["subtitle"]!,
                  imageUrl: item["image"]!,
                  onTap: () {},
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        // ================= DOTS =================
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
                (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 18 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? const Color(0xFF6B46C1)
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
