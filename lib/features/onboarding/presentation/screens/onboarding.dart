import 'package:flutter/material.dart';
import 'package:wateen_app/core/function/navigation.dart';
import 'package:wateen_app/core/utls/app_assets.dart';
import 'package:wateen_app/core/utls/app_strings.dart';
import 'package:wateen_app/core/widgets/custom_button.dart';
import 'package:wateen_app/features/onboarding/data/models/model.dart';
import 'package:wateen_app/features/onboarding/presentation/screens/widgets/custom.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingModel> _pages = [
    OnboardingModel(
      image: AppAssets.assetsImagesOnBoarding1,
      title: AppStrings.aIHealthAssistant,
      description: AppStrings.getInstantMedical,
    ),
    OnboardingModel(
      image: AppAssets.assetsImagesOnBoarding2,
      title: AppStrings.expertDoctors,
      description: AppStrings.connectWithCertified,
    ),
    OnboardingModel(
      image: AppAssets.assetsImagesOnBoarding3,
      title: AppStrings.homeCareServices,
      description: AppStrings.requestProfessionalNursing,
    ),
  ];

  void _goToRole() => CustomReplacementNavigation(context, '/role');

  void _nextPage() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _goToRole();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bool isLastPage = _currentIndex == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── PageView ─────────────────────────
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemBuilder:
                    (context, index) =>
                        OnboardingPageWidget(model: _pages[index]),
              ),
            ),

            // ── Dots Indicator ───────────────────
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
                            ? colorScheme.secondary
                            : colorScheme.outline,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ── Buttons ──────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child:
                  isLastPage
                      ? CustomButton(
                        title: 'Get Started',
                        color: colorScheme.secondary,
                        colorText: colorScheme.primary,
                        onTap: _goToRole,
                      )
                      : Row(
                        children: [
                          // Skip
                          Expanded(
                            child: TextButton(
                              onPressed: _goToRole,
                              child: Text('Skip', style: textTheme.titleMedium),
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Next
                          Expanded(
                            child: CustomButton(
                              title: 'Next',
                              color: colorScheme.secondary,
                              colorText: colorScheme.primary,
                              onTap: _nextPage,
                            ),
                          ),
                        ],
                      ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
