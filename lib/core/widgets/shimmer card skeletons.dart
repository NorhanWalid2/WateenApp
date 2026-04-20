// lib/core/widgets/shimmer_card_widget.dart

import 'package:flutter/material.dart';
import 'shimmer_widget.dart';

// ── Generic list item shimmer ─────────────────────────────────────────────────
class ShimmerListItemWidget extends StatelessWidget {
  const ShimmerListItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const ShimmerWidget(width: 48, height: 48, borderRadius: 24),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ShimmerWidget(width: 140, height: 14),
                  SizedBox(height: 6),
                  ShimmerWidget(width: 100, height: 11),
                ],
              ),
              const Spacer(),
              const ShimmerWidget(width: 60, height: 24, borderRadius: 20),
            ],
          ),
          const SizedBox(height: 14),
          const ShimmerWidget(width: double.infinity, height: 1),
          const SizedBox(height: 14),
          const ShimmerWidget(width: 180, height: 12),
          const SizedBox(height: 8),
          const ShimmerWidget(width: 150, height: 12),
          const SizedBox(height: 8),
          const ShimmerWidget(width: 120, height: 12),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(child: ShimmerWidget(width: double.infinity, height: 40, borderRadius: 10)),
              SizedBox(width: 12),
              Expanded(child: ShimmerWidget(width: double.infinity, height: 40, borderRadius: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Conversation tile shimmer ─────────────────────────────────────────────────
class ShimmerConversationTileWidget extends StatelessWidget {
  const ShimmerConversationTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const ShimmerWidget(width: 54, height: 54, borderRadius: 27),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerWidget(width: 120, height: 14),
                    ShimmerWidget(width: 40, height: 11),
                  ],
                ),
                SizedBox(height: 6),
                ShimmerWidget(width: 180, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Nurse/Doctor card shimmer ─────────────────────────────────────────────────
class ShimmerNurseCardWidget extends StatelessWidget {
  const ShimmerNurseCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const ShimmerWidget(width: 56, height: 56, borderRadius: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ShimmerWidget(width: 130, height: 14),
                    SizedBox(height: 6),
                    ShimmerWidget(width: 90, height: 11),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const ShimmerWidget(width: double.infinity, height: 80, borderRadius: 12),
          const SizedBox(height: 12),
          const ShimmerWidget(width: double.infinity, height: 44, borderRadius: 12),
        ],
      ),
    );
  }
}

// ── Profile header shimmer ────────────────────────────────────────────────────
class ShimmerProfileHeaderWidget extends StatelessWidget {
  const ShimmerProfileHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const ShimmerWidget(width: 64, height: 64, borderRadius: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ShimmerWidget(width: 140, height: 16),
                SizedBox(height: 6),
                ShimmerWidget(width: 180, height: 12),
                SizedBox(height: 4),
                ShimmerWidget(width: 100, height: 11),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Dashboard count card shimmer ──────────────────────────────────────────────
class ShimmerCountCardWidget extends StatelessWidget {
  const ShimmerCountCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerWidget(width: 40, height: 40, borderRadius: 12),
          SizedBox(height: 12),
          ShimmerWidget(width: 50, height: 28),
          SizedBox(height: 4),
          ShimmerWidget(width: 90, height: 12),
        ],
      ),
    );
  }
}