import 'package:flutter/material.dart';
import 'package:wateen_app/features/onboarding/presentation/screens/widgets/custom.dart';
import '../../data/models/model.dart';
//import '../widgets/custom.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // Your 3 onboarding pages data
  final List<OnboardingModel> _pages = [
    OnboardingModel(
      image:
          'assets/images/onBoarding1.png', // replace with your actual asset path
      title: 'AI Health Assistant',
      description:
          'Get instant medical guidance powered by\nartificial intelligence 24/7',
    ),
    OnboardingModel(
      image:
          'assets/images/onBoarding2.png', // replace with your actual asset path
      title: 'Expert Doctors',
      description:
          'Connect with certified healthcare\nprofessionals through video consultations',
    ),
    OnboardingModel(
      image:
          'assets/images/onBoarding3.png', // replace with your actual asset path
      title: 'Home Care Services',
      description:
          'Request professional nursing and\nphysiotherapy services at your doorstep',
    ),
  ];

  void _nextPage() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _goToHome(); // last page → navigate away
    }
  }

  void _skip() {
    _goToHome();
  }

  void _goToHome() {
    // Replace with your actual next route
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = _currentIndex == _pages.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // PageView takes most of the screen
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                return OnboardingCustomWidget(model: _pages[index]);
              },
            ),
          ),

          // Dots indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentIndex == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color:
                      _currentIndex == index
                          ? const Color(0xFFE00000)
                          : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Buttons row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child:
                isLastPage
                    // Last page: full width Get Started button
                    ? SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _goToHome,
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE00000),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                      ),
                    )
                    // First & second pages: Skip + Next
                    : Row(
                      children: [
                        // Skip button
                        Expanded(
                          child: TextButton(
                            onPressed: _skip,
                            child: const Text(
                              'Skip',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Next button
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: _nextPage,
                              icon: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Next',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE00000),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
