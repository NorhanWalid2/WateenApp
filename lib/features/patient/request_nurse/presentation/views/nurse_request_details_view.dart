import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/nurse_model.dart';
import 'widgets/nurse_profile_card_widget.dart';
import 'widgets/nurse_summary_strip_widget.dart';

class NurseRequestDetailsView extends StatefulWidget {
  final NurseModel nurse;
  const NurseRequestDetailsView({super.key, required this.nurse});

  @override
  State<NurseRequestDetailsView> createState() =>
      _NurseRequestDetailsViewState();
}

class _NurseRequestDetailsViewState extends State<NurseRequestDetailsView> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Nurse Request Details',
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nurse profile card
                    NurseProfileCardWidget(nurse: widget.nurse),
                    const SizedBox(height: 20),

                    // Address field
                    _SectionLabel(label: 'Service Address'),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outlineVariant,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F3FF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.location_on_rounded,
                                color: Color(0xFF7C3AED),
                                size: 18,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 14,
                                right: 14,
                                bottom: 14,
                              ),
                              child: TextField(
                                controller: _addressController,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 14,
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.inverseSurface,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Enter your full address...',
                                  hintStyle: TextStyle(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.outlineVariant,
                                    fontSize: 14,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Notes field
                    _SectionLabel(label: 'Notes for Nurse', optional: true),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outlineVariant,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F3FF),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.description_rounded,
                                    color: Color(0xFF7C3AED),
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'SPECIAL INSTRUCTIONS',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.outlineVariant,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                            child: TextField(
                              controller: _notesController,
                              maxLines: 4,
                              style: TextStyle(
                                fontSize: 13,
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.inverseSurface,
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    'Describe any special care requirements, medical conditions or instructions for the nurse...',
                                hintStyle: TextStyle(
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.outlineVariant,
                                  fontSize: 13,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Summary strip
                    NurseSummaryStripWidget(
                      nurseName:
                          widget.nurse.name.split(' ').first +
                          ' ' +
                          widget.nurse.name.split(' ').last[0] +
                          '.',
                      serviceType: 'Home Visit',
                      rate: 'SAR ${widget.nurse.hourlyRate.toInt()}/hr',
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Confirm button
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              color: Theme.of(context).colorScheme.primary,
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: connect your API here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Confirm Request',
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Section Label
class _SectionLabel extends StatelessWidget {
  final String label;
  final bool optional;
  const _SectionLabel({required this.label, this.optional = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.inverseSurface,
          ),
        ),
        if (optional) ...[
          const SizedBox(width: 6),
          Text(
            '(Optional)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
        ],
      ],
    );
  }
}
