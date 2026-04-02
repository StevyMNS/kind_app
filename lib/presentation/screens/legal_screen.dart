import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:kind_app/core/theme/app_colors.dart';
import 'package:kind_app/core/theme/app_typography.dart';
import 'package:kind_app/core/utils/logger.dart';

/// Écran pour afficher des documents légaux (Politique de confidentialité, CGU).
/// Charge un fichier Markdown depuis les assets selon la langue actuelle.
class LegalScreen extends StatefulWidget {
  /// Le titre de la page (ex: "Politique de confidentialité").
  final String title;

  /// Le chemin de base du fichier sans la langue ni l'extension.
  /// Exemple: "assets/docs/privacy_policy" -> chargera "assets/docs/privacy_policy_fr.md"
  final String baseAssetPath;

  const LegalScreen({
    super.key,
    required this.title,
    required this.baseAssetPath,
  });

  @override
  State<LegalScreen> createState() => _LegalScreenState();
}

class _LegalScreenState extends State<LegalScreen> {
  String _markdownData = '';
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading && _markdownData.isEmpty) {
      _loadDocument(context.locale.languageCode);
    }
  }

  Future<void> _loadDocument(String code) async {
    try {
      String path = '${widget.baseAssetPath}_$code.md';
      
      try {
        _markdownData = await rootBundle.loadString(path);
      } catch (e) {
        // En cas d'erreur (ex: langue non supportée), on se rabat sur l'anglais
        AppLogger.info('Fichier non trouvé pour $code, fallback vers [en]');
        path = '${widget.baseAssetPath}_en.md';
        _markdownData = await rootBundle.loadString(path);
      }
    } catch (e, st) {
      AppLogger.error('Impossible de charger le document légal', e, st);
      _markdownData = 'Erreur lors du chargement du document.';
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: AppTypography.headlineSmall.copyWith(fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.midnightBlue),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.gold),
              )
            : Markdown(
                data: _markdownData,
                styleSheet: MarkdownStyleSheet(
                  h1: AppTypography.headlineMedium.copyWith(color: AppColors.midnightBlue),
                  h2: AppTypography.titleLarge.copyWith(color: AppColors.midnightBlue),
                  p: AppTypography.bodyLarge.copyWith(color: AppColors.grey500),
                  listBullet: AppTypography.bodyLarge.copyWith(color: AppColors.gold),
                  strong: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.midnightBlue),
                ),
              ),
      ),
    );
  }
}
