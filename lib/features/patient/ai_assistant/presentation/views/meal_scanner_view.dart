import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../cubit/meal_scanner_cubit.dart';
import '../cubit/meal_scanner_state.dart';
import '../../data/models/meal_calories_model.dart';

class MealScannerView extends StatelessWidget {
  const MealScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MealScannerCubit(),
      child: const MealScannerBody(),
    );
  }
}

class MealScannerBody extends StatefulWidget {
  const MealScannerBody({super.key});

  @override
  State<MealScannerBody> createState() => MealScannerBodyState();
}

class MealScannerBodyState extends State<MealScannerBody> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: BlocBuilder<MealScannerCubit, MealScannerState>(
          builder: (context, state) {
            return Column(
              children: [
                // ── Header ───────────────────────────────────
                Container(
                  color: colorScheme.primary,
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 16,
                                color: colorScheme.inverseSurface,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Meal Scanner',
                            style: GoogleFonts.dmSerifDisplay(
                              fontSize: 22,
                              color: colorScheme.inverseSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ── Search bar ───────────────────────────
                      Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            Icon(Icons.restaurant_rounded,
                                color: colorScheme.onSurfaceVariant, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                cursorColor: colorScheme.secondary,
                                style: textTheme.bodyMedium,
                                textInputAction: TextInputAction.search,
                                onSubmitted: (v) => context
                                    .read<MealScannerCubit>()
                                    .getCalories(food: v),
                                decoration: InputDecoration(
                                  hintText: 'Enter food name (e.g. koshary)...',
                                  hintStyle: textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurfaceVariant),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context
                                  .read<MealScannerCubit>()
                                  .getCalories(food: _controller.text),
                              child: Container(
                                margin: const EdgeInsets.all(6),
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.search_rounded,
                                    color: Colors.white, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Body ─────────────────────────────────────
                Expanded(
                  child: switch (state) {
                    MealScannerInitial() => _buildInitial(colorScheme, textTheme),
                    MealScannerLoading() => _buildLoading(colorScheme),
                    MealScannerLoaded(:final result) =>
                      _buildResult(context, colorScheme, textTheme, result),
                    MealScannerError(:final message) =>
                      _buildError(context, colorScheme, textTheme, message),
                    _ => const SizedBox(),
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ── Initial state ─────────────────────────────────────────────────────────
  Widget _buildInitial(ColorScheme colorScheme, TextTheme textTheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: colorScheme.secondary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.restaurant_menu_rounded,
                size: 48, color: colorScheme.secondary),
          ),
          const SizedBox(height: 24),
          Text(
            'Check Food Calories',
            style: textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'Type any food name to get instant\ncalorie information powered by AI',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium
                ?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 40),

          // ── Quick suggestions ─────────────────────────────
          Text('Try these:',
              style: textTheme.bodySmall
                  ?.copyWith(color: colorScheme.onSurfaceVariant)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              'Koshary', 'Pizza', 'Salad', 'Rice', 'Falafel', 'Burger',
            ]
                .map((food) => Builder(
                      builder: (ctx) => GestureDetector(
                        onTap: () {
                          _controller.text = food;
                          ctx.read<MealScannerCubit>().getCalories(food: food);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: colorScheme.outline.withOpacity(0.3)),
                          ),
                          child: Text(food,
                              style: textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ))
                .toList(),
          ),

          const SizedBox(height: 40),

          // ── Camera coming soon ────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: colorScheme.outline.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.camera_alt_rounded,
                      color: colorScheme.secondary, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Photo Scan',
                          style: textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      Text('Take a photo of your meal — coming soon!',
                          style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('Soon',
                      style: TextStyle(
                          color: colorScheme.secondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Loading state ─────────────────────────────────────────────────────────
  Widget _buildLoading(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: colorScheme.secondary),
          const SizedBox(height: 16),
          Text('Analyzing food...',
              style: TextStyle(color: colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }

  // ── Result state ──────────────────────────────────────────────────────────
  Widget _buildResult(BuildContext context, ColorScheme colorScheme,
      TextTheme textTheme, MealCaloriesModel result) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),

          // ── Calories card ─────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.secondary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.local_fire_department_rounded,
                      color: Colors.white, size: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  '${result.calories}',
                  style: GoogleFonts.dmSerifDisplay(
                    fontSize: 56,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Calories',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Food info card ────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Food Details',
                    style: textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),
                _InfoRow(
                  label: 'English Name',
                  value: result.foodEn.isNotEmpty ? result.foodEn : '—',
                  icon: Icons.translate_rounded,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  label: 'Arabic Name',
                  value: result.foodAr.isNotEmpty ? result.foodAr : '—',
                  icon: Icons.language_rounded,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  label: 'Source',
                  value: result.source,
                  icon: Icons.info_outline_rounded,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Calorie guide ─────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _calorieColor(result.calories).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: _calorieColor(result.calories).withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(_calorieIcon(result.calories),
                    color: _calorieColor(result.calories), size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _calorieMessage(result.calories),
                    style: TextStyle(
                      color: _calorieColor(result.calories),
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Search again button ───────────────────────────
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                _controller.clear();
                context.read<MealScannerCubit>().reset();
              },
              icon: Icon(Icons.search_rounded, color: colorScheme.secondary),
              label: Text('Search Another Food',
                  style: TextStyle(color: colorScheme.secondary)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colorScheme.secondary),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Error state ───────────────────────────────────────────────────────────
  Widget _buildError(BuildContext context, ColorScheme colorScheme,
      TextTheme textTheme, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded,
                size: 56, color: colorScheme.error),
            const SizedBox(height: 16),
            Text('Could not get calories',
                style:
                    textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium
                    ?.copyWith(color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context
                  .read<MealScannerCubit>()
                  .getCalories(food: _controller.text),
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              label:
                  const Text('Try Again', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.secondary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _calorieColor(int calories) {
    if (calories < 100) return const Color(0xFF16A34A);
    if (calories < 300) return const Color(0xFFF59E0B);
    return const Color(0xFFE53935);
  }

  IconData _calorieIcon(int calories) {
    if (calories < 100) return Icons.check_circle_outline_rounded;
    if (calories < 300) return Icons.warning_amber_rounded;
    return Icons.local_fire_department_rounded;
  }

  String _calorieMessage(int calories) {
    if (calories < 100) return 'Low calorie food — great for a healthy diet!';
    if (calories < 300) return 'Moderate calories — enjoy in balanced portions.';
    return 'High calorie food — be mindful of portion size.';
  }
}

// ── Info Row ──────────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colorScheme.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: colorScheme.secondary, size: 18),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: textTheme.bodySmall
                    ?.copyWith(color: colorScheme.onSurfaceVariant)),
            Text(value,
                style: textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}