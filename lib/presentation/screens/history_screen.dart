import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kind_app/application/controllers/history_controller.dart';
import 'package:kind_app/core/theme/app_colors.dart';
import 'package:kind_app/core/theme/app_radius.dart';
import 'package:kind_app/core/theme/app_shadows.dart';
import 'package:kind_app/core/theme/app_typography.dart';
import 'package:kind_app/domain/entities/message_entity.dart';
import 'package:kind_app/presentation/widgets/empty_state.dart';

/// Écran d'historique avec tabs Envoyés / Reçus.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Historique'),
          bottom: TabBar(
            labelColor: AppColors.gold,
            unselectedLabelColor: AppColors.grey500,
            indicatorColor: AppColors.gold,
            labelStyle: AppTypography.labelLarge,
            tabs: const [
              Tab(text: 'Envoyés'),
              Tab(text: 'Reçus'),
            ],
          ),
        ),
        body: const TabBarView(children: [_SentTab(), _ReceivedTab()]),
      ),
    );
  }
}

class _SentTab extends ConsumerWidget {
  const _SentTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(historyControllerProvider);

    return historyState.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(color: AppColors.gold)),
      error: (error, _) => Center(
        child: Text(error.toString(), style: AppTypography.bodyMedium),
      ),
      data: (state) {
        if (state.sentMessages.isEmpty) {
          return const EmptyState(
            message: 'Vous n\'avez pas encore envoyé de message.',
            icon: Icons.send_rounded,
          );
        }

        return RefreshIndicator(
          onRefresh: () =>
              ref.read(historyControllerProvider.notifier).refresh(),
          color: AppColors.gold,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification &&
                  notification.metrics.extentAfter < 200) {
                ref.read(historyControllerProvider.notifier).loadMoreSent();
              }
              return false;
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount:
                  state.sentMessages.length + (state.hasMoreSent ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.sentMessages.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.gold),
                    ),
                  );
                }
                return _MessageTile(
                  message: state.sentMessages[index],
                  isSent: true,
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _ReceivedTab extends ConsumerWidget {
  const _ReceivedTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(historyControllerProvider);

    return historyState.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(color: AppColors.gold)),
      error: (error, _) => Center(
        child: Text(error.toString(), style: AppTypography.bodyMedium),
      ),
      data: (state) {
        if (state.receivedMessages.isEmpty) {
          return const EmptyState(
            message: 'Vous n\'avez pas encore reçu de message.',
            icon: Icons.mail_rounded,
          );
        }

        return RefreshIndicator(
          onRefresh: () =>
              ref.read(historyControllerProvider.notifier).refresh(),
          color: AppColors.gold,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification &&
                  notification.metrics.extentAfter < 200) {
                ref.read(historyControllerProvider.notifier).loadMoreReceived();
              }
              return false;
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount:
                  state.receivedMessages.length +
                  (state.hasMoreReceived ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.receivedMessages.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.gold),
                    ),
                  );
                }
                return _MessageTile(
                  message: state.receivedMessages[index],
                  isSent: false,
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _MessageTile extends StatelessWidget {
  final MessageEntity message;
  final bool isSent;

  const _MessageTile({required this.message, required this.isSent});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm', 'fr_FR');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: AppRadius.largeRadius,
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isSent ? Icons.send_rounded : Icons.mail_rounded,
                size: 16,
                color: AppColors.gold,
              ),
              const SizedBox(width: 8),
              Text(
                isSent ? 'Envoyé' : 'Reçu',
                style: AppTypography.labelSmall.copyWith(color: AppColors.gold),
              ),
              const Spacer(),
              Text(
                dateFormat.format(message.createdAt),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.grey500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            message.content,
            style: AppTypography.bodyMedium.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}
