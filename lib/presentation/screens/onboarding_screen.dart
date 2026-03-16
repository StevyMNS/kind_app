import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kind_app/core/services/onboarding_service.dart';
import 'package:kind_app/core/theme/app_colors.dart';
import 'package:kind_app/core/theme/app_radius.dart';
import 'package:kind_app/core/theme/app_typography.dart';

/// Données pour chaque étape de l'onboarding.
class _OnboardingStep {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget illustration;

  const _OnboardingStep({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.illustration,
  });
}

/// Écran d'onboarding en 3 étapes.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  final List<_OnboardingStep> _steps = [
    _OnboardingStep(
      title: 'Un message peut\nchanger une journée.',
      subtitle:
          'Recevez une prière anonyme ou un verset\npour illuminer votre quotidien.',
      icon: Icons.wb_sunny_rounded,
      illustration: _ArchIllustration(
        child: Icon(
          Icons.wb_cloudy_rounded,
          size: 72,
          color: AppColors.gold.withValues(alpha: 0.7),
        ),
      ),
    ),
    _OnboardingStep(
      title: 'Envoyez de la\nlumière.',
      subtitle:
          'Partagez un mot bienveillant avec un inconnu.\nAnonymement. Sans jugement.',
      icon: Icons.send_rounded,
      illustration: _ArchIllustration(
        child: Icon(
          Icons.mail_outline_rounded,
          size: 72,
          color: AppColors.gold.withValues(alpha: 0.7),
        ),
      ),
    ),
    const _OnboardingStep(
      title: 'Anonyme.\nSimple.\nPaisible.',
      subtitle: 'Un message par jour. Une prière\nsilencieuse. Rien de plus.',
      icon: Icons.self_improvement_rounded,
      illustration: _ArchIllustration(
        isLast: true,
        child: Icon(
          Icons.spa_rounded,
          size: 72,
          color: AppColors.gold,
        ),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _complete() async {
    await OnboardingService.setOnboardingCompleted();
    if (!mounted) return;
    context.go('/home');
  }

  bool get _isLastPage => _currentPage == _steps.length - 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            children: [
              // Bouton Passer
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, right: 24),
                  child: _isLastPage
                      ? const SizedBox.shrink()
                      : TextButton(
                          onPressed: _complete,
                          child: Text(
                            'Passer',
                            style: AppTypography.labelLarge.copyWith(
                              color: AppColors.grey500,
                            ),
                          ),
                        ),
                ),
              ),

              // Pages
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                    _animController
                      ..reset()
                      ..forward();
                  },
                  itemCount: _steps.length,
                  itemBuilder: (context, index) {
                    final step = _steps[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Illustration
                          step.illustration,
                          const SizedBox(height: 40),

                          // Titre
                          Text(
                            step.title,
                            textAlign: TextAlign.center,
                            style: AppTypography.headlineMedium.copyWith(
                              color: AppColors.midnightBlue,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Sous-titre
                          Text(
                            step.subtitle,
                            textAlign: TextAlign.center,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.grey500,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Dots + Bouton
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
                child: Column(
                  children: [
                    // Dots pagination
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _steps.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: i == _currentPage ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: i == _currentPage
                                ? AppColors.gold
                                : AppColors.grey300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Bouton principal
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gold,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.largeRadius,
                          ),
                          elevation: 0,
                        ),
                        onPressed: _isLastPage ? _complete : _nextPage,
                        child: Text(
                          _isLastPage ? 'Commencer' : 'Suivant →',
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    // Lien sous le bouton (dernière page)
                    if (_isLastPage) ...[
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: _complete,
                        child: Text(
                          'Déjà un compte ? Se connecter',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.grey500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Illustration en forme d'arche (fidèle aux maquettes Stitch).
class _ArchIllustration extends StatelessWidget {
  final Widget child;
  final bool isLast;

  const _ArchIllustration({required this.child, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 240,
      decoration: BoxDecoration(
        color: isLast
            ? AppColors.gold.withValues(alpha: 0.08)
            : AppColors.mist.withValues(alpha: 0.6),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(110),
          topRight: Radius.circular(110),
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        border: Border.all(
          color: isLast
              ? AppColors.gold.withValues(alpha: 0.2)
              : AppColors.grey300,
          width: 1,
        ),
      ),
      child: Center(child: child),
    );
  }
}
