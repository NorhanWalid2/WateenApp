import 'package:flutter/material.dart';
import 'package:wateen_app/core/function/navigation.dart';
import 'package:wateen_app/core/utls/app_assets.dart';
import 'package:wateen_app/core/widgets/custom_button.dart';
import 'package:wateen_app/features/onboarding/data/models/model.dart';
import 'package:wateen_app/features/onboarding/presentation/screens/widgets/custom.dart';
import 'package:wateen_app/l10n/app_localizations.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  List<OnboardingModel> _buildPages(AppLocalizations l10n) => [
    OnboardingModel(
      image: AppAssets.assetsImagesOnBoarding1,
      title: l10n.aIHealthAssistant,
      description: l10n.getInstantMedical,
    ),
    OnboardingModel(
      image: AppAssets.assetsImagesOnBoarding2,
      title: l10n.expertDoctors,
      description: l10n.connectWithCertified,
    ),
    OnboardingModel(
      image: AppAssets.assetsImagesOnBoarding3,
      title: l10n.homeCareServices,
      description: l10n.requestProfessionalNursing,
    ),
  ];

  void _goToRole() => CustomReplacementNavigation(context, '/role');

  void _nextPage(int total) {
    if (_currentIndex < total - 1) {
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
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final pages = _buildPages(l10n);
    final bool isLastPage = _currentIndex == pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemBuilder:
                    (context, index) =>
                        OnboardingPageWidget(model: pages[index]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child:
                  isLastPage
                      ? CustomButton(
                        title: l10n.getStarted,
                        color: colorScheme.secondary,
                        colorText: colorScheme.primary,
                        onTap: _goToRole,
                      )
                      : Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: _goToRole,
                              child: Text(
                                l10n.skip,
                                style: textTheme.titleMedium,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomButton(
                              title: l10n.next,
                              color: colorScheme.secondary,
                              colorText: colorScheme.primary,
                              onTap: () => _nextPage(pages.length),
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
