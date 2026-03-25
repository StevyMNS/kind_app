import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kind_app/application/controllers/send_message_controller.dart';
import 'package:kind_app/core/utils/country_utils.dart';
import 'package:kind_app/core/theme/app_colors.dart';
import 'package:kind_app/core/theme/app_typography.dart';
import 'package:kind_app/presentation/widgets/kind_button.dart';
import 'package:kind_app/presentation/widgets/kind_text_field.dart';

/// Écran d'écriture d'un message bienveillant.
class WriteScreen extends ConsumerStatefulWidget {
  const WriteScreen({super.key});

  @override
  ConsumerState<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends ConsumerState<WriteScreen> {
  final _controller = TextEditingController();
  bool _showSuccess = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final notifier = ref.read(sendMessageControllerProvider.notifier);
    
    // Récupérer le pays du sender via la locale
    final countryCode = View.of(context).platformDispatcher.locale.countryCode;
    final countryEmoji = countryCode != null ? CountryUtils.countryCodeToEmoji(countryCode) : null;

    final success = await notifier.send(
      _controller.text,
      countryCode: countryCode,
      countryEmoji: countryEmoji,
    );

    if (success && mounted) {
      setState(() => _showSuccess = true);
      _controller.clear();

      // Afficher le succès pendant 2 secondes puis revenir
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        notifier.reset();
        context.go('/receive');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sendState = ref.watch(sendMessageControllerProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('write.title'.tr()),
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _showSuccess ? _buildSuccess() : _buildForm(sendState),
        ),
      ),
    );
  }

  Widget _buildForm(AsyncValue<dynamic> sendState) {
    final errorText = sendState.hasError ? sendState.error.toString() : null;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'write.headline'.tr(),
                    style: AppTypography.headlineMedium.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'write.subtitle'.tr(),
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                  const SizedBox(height: 32),
                  KindTextField(
                    controller: _controller,
                    errorText: errorText,
                    hintText: 'write.hint'.tr(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          KindButton(
            label: 'write.btn_send'.tr(),
            icon: Icons.send_rounded,
            isLoading: sendState.isLoading,
            onPressed: _sendMessage,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSuccess() {
    return Center(
      key: const ValueKey('success'),
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.success.withValues(alpha: 0.1),
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 40,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'write.success_title'.tr(),
              style: AppTypography.headlineMedium.copyWith(
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'write.success_subtitle'.tr(),
              style: AppTypography.bodyLarge.copyWith(
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
