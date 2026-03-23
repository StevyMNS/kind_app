import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kind_app/application/controllers/receive_message_controller.dart';
import 'package:kind_app/core/theme/app_colors.dart';
import 'package:kind_app/core/theme/app_radius.dart';
import 'package:kind_app/core/theme/app_shadows.dart';
import 'package:kind_app/core/theme/app_typography.dart';
import 'package:kind_app/presentation/widgets/empty_state.dart';
import 'package:kind_app/presentation/widgets/kind_button.dart';

/// Écran de réception d'un message anonyme.
class ReceiveScreen extends ConsumerStatefulWidget {
  const ReceiveScreen({super.key});

  @override
  ConsumerState<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends ConsumerState<ReceiveScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  bool _hasTriggered = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
          ),
        );
  }

  @override
  void dispose() {
    // Reset le message si on quitte l'écran
    ref.read(receiveMessageControllerProvider.notifier).reset();
    _animController.dispose();
    super.dispose();
  }

  void _receiveMessage() {
    if (!_hasTriggered) {
      _hasTriggered = true;
      ref.read(receiveMessageControllerProvider.notifier).receiveMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final receiveState = ref.watch(receiveMessageControllerProvider);

    // Lancer l'animation à la réception du message
    ref.listen(receiveMessageControllerProvider, (previous, next) {
      if (next.hasValue && next.value != null) {
        _animController.forward();
      }
    });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Message reçu'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: receiveState.when(
            loading: () => const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.gold),
                  SizedBox(height: 24),
                  Text('Recherche d\'un message pour vous...'),
                ],
              ),
            ),
            error: (error, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    error.toString(),
                    style: AppTypography.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  KindButton(
                    label: 'Réessayer',
                    onPressed: () {
                      _hasTriggered = false;
                      _receiveMessage();
                    },
                  ),
                ],
              ),
            ),
            data: (message) {
              // Pas encore demandé
              if (message == null && !_hasTriggered) {
                return _buildInitialState();
              }
              // Aucun message disponible
              if (message == null && _hasTriggered) {
                return const EmptyState(
                  message:
                      'Aucun message disponible pour l\'instant.\nRevenez un peu plus tard...',
                  icon: Icons.hourglass_empty_rounded,
                );
              }
              // Message reçu avec animation
              return _buildMessageCard(message!.content);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.mail_outline_rounded,
            size: 80,
            color: AppColors.gold.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'Prêt à recevoir\nun message bienveillant ?',
            style: AppTypography.headlineMedium.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Quelqu\'un, quelque part, a écrit ces mots pour vous.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.grey500,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          KindButton(
            label: 'Révéler le message',
            icon: Icons.auto_awesome,
            onPressed: _receiveMessage,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard(String content) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).cardTheme.color ?? AppColors.white,
                      AppColors.mist.withValues(alpha: 0.5),
                    ],
                  ),
                  borderRadius: AppRadius.largeRadius,
                  boxShadow: AppShadows.medium,
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.format_quote_rounded,
                      size: 32,
                      color: AppColors.gold,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      content,
                      style: AppTypography.bodyLarge.copyWith(
                        fontSize: 18,
                        height: 1.8,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '— Un inconnu bienveillant',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.gold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              KindButton(
                label: 'Confier le mien maintenant',
                icon: Icons.edit_rounded,
                onPressed: () {
                  ref.read(receiveMessageControllerProvider.notifier).reset();
                  context.go('/write');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
