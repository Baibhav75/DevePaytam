import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  void _navigateToLogin() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _onNext() {
    if (_currentPage == _onboardingItems.length - 1) {
      _navigateToLogin();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryTeal,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),

            // Top Fixed Image
            Container(
              height: 300,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Image.asset(
                _onboardingItems[_currentPage].imagePath,
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            ),

            const SizedBox(height: 24),

            // Swipeable Card Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical:70),
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _onboardingItems.length,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    final item = _onboardingItems[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: kCardLight,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Title
                          Text(
                            item.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Subtitle
                          Text(
                            item.subtitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Page Indicators
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _onboardingItems.length,
                                  (i) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                width: i == _currentPage ? 32 : 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: i == _currentPage
                                      ? kPrimaryTeal
                                      : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Next / Get Started Button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _onNext,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryTeal,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                _currentPage == _onboardingItems.length - 1
                                    ? 'Get Started'
                                    : 'Next',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 5), // Skip Button
                          TextButton(
                            onPressed: _navigateToLogin,
                            child: const Text(
                              'Skip',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Onboarding Data Model
class _OnboardingItem {
  const _OnboardingItem({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  final String imagePath;
  final String title;
  final String subtitle;
}

const List<_OnboardingItem> _onboardingItems = [
  _OnboardingItem(
    imagePath: 'assets/onboarding_pay_contact.png',
    title: 'Scan And pay easily',
    subtitle:
    'Scan any QR code and make fast, secure payments instantly.',
  ),
  _OnboardingItem(
    imagePath: 'assets/onboarding_card.png',
    title: 'Send money easily',
    subtitle:
    'Transfer money quickly and safely to anyone, anytime.',
  ),
  _OnboardingItem(
    imagePath: 'assets/onboarding_success.png',
    title: 'Recharge and pay bill',
    subtitle:
    'Recharge your mobile and pay all your bills in just a few taps.',
  ),

];