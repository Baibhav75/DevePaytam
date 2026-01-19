import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import 'login_screen.dart';

// Controller for onboarding state
class OnboardingController extends GetxController {
  var currentPage = 0.obs;
  final PageController pageController = PageController();

  void nextPage(int totalPages) {
    if (currentPage.value == totalPages - 1) {
      goToLogin();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  void goToLogin() {
    Get.off(() => LoginScreen());
  }
}

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final OnboardingController controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryTeal,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Top Fixed Image
            Obx(
                  () => Container(
                height: 300,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Image.asset(
                  _onboardingItems[controller.currentPage.value].imagePath,
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Swipeable Card Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
                child: PageView.builder(
                  controller: controller.pageController,
                  itemCount: _onboardingItems.length,
                  onPageChanged: (index) => controller.currentPage.value = index,
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
                          Obx(
                                () => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                _onboardingItems.length,
                                    (i) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.symmetric(horizontal: 5),
                                  width: i == controller.currentPage.value ? 32 : 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: i == controller.currentPage.value
                                        ? kPrimaryTeal
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
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
                              onPressed: () => controller.nextPage(_onboardingItems.length),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryTeal,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Obx(
                                    () => Text(
                                  controller.currentPage.value == _onboardingItems.length - 1
                                      ? 'Get Started'
                                      : 'Next',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          TextButton(
                            onPressed: controller.goToLogin,
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
    subtitle: 'Scan any QR code and make fast, secure payments instantly.',
  ),
  _OnboardingItem(
    imagePath: 'assets/onboarding_card.png',
    title: 'Send money easily',
    subtitle: 'Transfer money quickly and safely to anyone, anytime.',
  ),
  _OnboardingItem(
    imagePath: 'assets/onboarding_success.png',
    title: 'Recharge and pay bill',
    subtitle: 'Recharge your mobile and pay all your bills in just a few taps.',
  ),
];
