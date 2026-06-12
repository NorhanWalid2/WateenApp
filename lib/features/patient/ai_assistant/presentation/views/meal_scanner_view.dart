// lib/features/patient/ai_assistant/presentation/views/meal_scanner_view.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
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
  State<MealScannerBody> createState() => _MealScannerBodyState();
}

class _MealScannerBodyState extends State<MealScannerBody> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _gramsController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  int _grams = 100;

  @override
  void dispose() {
    _controller.dispose();
    _gramsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
      );
      if (picked != null && mounted) {
        context.read<MealScannerCubit>().getCaloriesByImage(
          image: File(picked.path),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open camera/gallery')),
      );
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (_) => Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Scan Meal Photo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC2626).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                  title: const Text('Take a Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0EA5E9).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.photo_library_rounded,
                      color: Color(0xFF0EA5E9),
                    ),
                  ),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
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
                // ── Header ────────────────────────────────────
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
                          const Spacer(),
                          if (state is MealScannerLoaded)
                            GestureDetector(
                              onTap: () {
                                _controller.clear();
                                _gramsController.clear();

                                setState(() {
                                  _grams = 100;
                                });

                                context.read<MealScannerCubit>().reset();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'New Scan',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.secondary,
                                  ),
                                ),
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
                            Icon(
                              Icons.restaurant_rounded,
                              color: colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                cursorColor: colorScheme.secondary,
                                style: textTheme.bodyMedium,
                                textInputAction: TextInputAction.search,
                                onSubmitted:
                                    (v) => context
                                        .read<MealScannerCubit>()
                                        .getCalories(food: v),
                                decoration: InputDecoration(
                                  hintText: 'Enter food name (e.g. mahshi)...',
                                  hintStyle: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                            // ✅ Camera button for image scan
                            GestureDetector(
                              onTap: _showImageSourceSheet,
                              child: Container(
                                margin: const EdgeInsets.all(6),
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: colorScheme.outline.withOpacity(0.3),
                                  ),
                                ),
                                child: Icon(
                                  Icons.camera_alt_rounded,
                                  color: colorScheme.onSurfaceVariant,
                                  size: 18,
                                ),
                              ),
                            ),
                            // Search button
                            GestureDetector(
                              onTap:
                                  () => context
                                      .read<MealScannerCubit>()
                                      .getCalories(food: _controller.text),
                              child: Container(
                                margin: const EdgeInsets.only(
                                  right: 6,
                                  top: 6,
                                  bottom: 6,
                                ),
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.search_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.scale_rounded,
                              color: colorScheme.secondary,
                            ),

                            const SizedBox(width: 10),

                            const Text(
                              "Weight",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),

                            const Spacer(),

                            IconButton(
                              onPressed: () {
                                if (_grams > 50) {
                                  setState(() {
                                    _grams -= 50;
                                    _gramsController.text = _grams.toString();
                                  });
                                }
                              },
                              icon: const Icon(Icons.remove_circle_outline),
                            ),

                            Text(
                              "$_grams g",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _grams += 50;
                                  _gramsController.text = _grams.toString();
                                });
                              },
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Body ──────────────────────────────────────
                Expanded(
                  child:
                      state is MealScannerLoading
                          ? _buildLoading(colorScheme)
                          : state is MealScannerLoaded
                          ? _buildResult(
                            context,
                            state.result,
                            colorScheme,
                            textTheme,
                          )
                          : state is MealScannerError
                          ? _buildError(
                            context,
                            state.message,
                            colorScheme,
                            textTheme,
                          )
                          : _buildInitial(context, colorScheme, textTheme),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ── Loading ───────────────────────────────────────────────────────
  Widget _buildLoading(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: colorScheme.secondary,
            strokeWidth: 2,
          ),
          const SizedBox(height: 16),
          Text(
            'Analyzing your meal...',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  // ── Result ────────────────────────────────────────────────────────
  Widget _buildResult(
    BuildContext context,
    MealCaloriesModel result,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final enteredWeight = int.tryParse(_gramsController.text) ?? _grams;

    final cal = ((result.caloriesPer100g * enteredWeight) / 100).round();
    final calColor =
        cal < 200
            ? const Color(0xFF16A34A)
            : cal < 500
            ? const Color(0xFFF59E0B)
            : const Color(0xFFE53935);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Main calorie card ──────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [calColor, calColor.withOpacity(0.75)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Icon(
                  cal < 200
                      ? Icons.check_circle_outline_rounded
                      : cal < 500
                      ? Icons.warning_amber_rounded
                      : Icons.local_fire_department_rounded,
                  color: Colors.white,
                  size: 40,
                ),
                const SizedBox(height: 12),
                Text(
                  result.foodEn.isNotEmpty ? result.foodEn : 'Food',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                if (result.foodAr.isNotEmpty)
                  Text(
                    result.foodAr,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.85),
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                const SizedBox(height: 16),
                Text(
                  '$cal',
                  style: GoogleFonts.archivo(
                    fontSize: 56,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                const Text(
                  'Total Calories',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Details grid ──────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _DetailCard(
                  icon: Icons.scale_rounded,
                  label: 'Estimated Weight',
                  value: '${int.tryParse(_gramsController.text) ?? _grams}g',
                  colorScheme: colorScheme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DetailCard(
                  icon: Icons.local_fire_department_rounded,
                  label: 'Per 100g',
                  value: '${result.caloriesPer100g} kcal',
                  colorScheme: colorScheme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
         

          // ── AI Reply ──────────────────────────────────────
          if (result.reply.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        size: 16,
                        color: colorScheme.secondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'AI Insight',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    result.reply,
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.inverseSurface,
                      height: 1.5,
                    ),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ── Initial ───────────────────────────────────────────────────────
  Widget _buildInitial(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Icon(
            Icons.restaurant_menu_rounded,
            size: 64,
            color: colorScheme.outlineVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'Calorie Scanner',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'Type a food name or take a photo\nto get instant calorie information powered by AI',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),

          // Quick suggestions
          Text(
            'Try these:',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children:
                [
                      'Koshary',
                      'Pizza',
                      'Salad',
                      'Rice',
                      'Falafel',
                      'Burger',
                      'Mahshi',
                      'Shawarma',
                    ]
                    .map(
                      (food) => GestureDetector(
                        onTap: () {
                          _controller.text = food;

                          _grams = 100;
                          _gramsController.text = '100';

                          context.read<MealScannerCubit>().getCalories(
                            food: food,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: colorScheme.outline.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            food,
                            style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),

          const SizedBox(height: 32),

          // Camera scan option
          GestureDetector(
            onTap: _showImageSourceSheet,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
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
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: colorScheme.secondary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Photo Scan',
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Take or upload a photo of your meal',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: colorScheme.outlineVariant,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Error ─────────────────────────────────────────────────────────
  Widget _buildError(
    BuildContext context,
    String message,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 56,
              color: colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Could not analyze food',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed:
                  () => context.read<MealScannerCubit>().getCalories(
                    food: _controller.text,
                  ),
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              label: const Text(
                'Try Again',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Detail Card ───────────────────────────────────────────────────────────────
class _DetailCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme colorScheme;

  const _DetailCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: colorScheme.secondary),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
