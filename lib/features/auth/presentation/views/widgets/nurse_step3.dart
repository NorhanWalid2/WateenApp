import 'package:flutter/material.dart';
import 'package:wateen_app/core/utls/app_strings.dart';
import 'package:wateen_app/features/auth/presentation/views/widgets/step_card.dart';

class NurseStep3 extends StatelessWidget {
  final String? uploadedFileName;
  final ValueChanged<String> onFileUploaded;

  const NurseStep3({
    super.key,
    required this.uploadedFileName,
    required this.onFileUploaded,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return StepCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Upload License/Certification', style: textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            "Upload a clear photo or scan of your professional license or certification. We'll verify it using OCR technology.",
            style: textTheme.bodySmall,
          ),
          const SizedBox(height: 20),

          // ── Upload Box ─────────────────────
          GestureDetector(
            onTap: () => onFileUploaded('license_document.pdf'), // TODO: file picker
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: uploadedFileName != null
                      ? colorScheme.secondary
                      : colorScheme.outline,
                  width: 1.5,
                ),
              ),
              child: uploadedFileName != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline,
                            color: colorScheme.secondary, size: 36),
                        const SizedBox(height: 8),
                        Text(
                          uploadedFileName!,
                          style: textTheme.bodySmall
                              ?.copyWith(color: colorScheme.secondary),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file_outlined,
                            color: colorScheme.onSurfaceVariant, size: 36),
                        const SizedBox(height: 8),
                        Text(AppStrings.uploadLicenseDocument,
                            style: textTheme.bodyMedium),
                        Text(AppStrings.jPGPNGOrPDF,
                            style: textTheme.bodySmall),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: 12),

          // ── Take Photo ─────────────────────
          OutlinedButton.icon(
            onPressed: () => onFileUploaded('photo_license.jpg'), // TODO: camera
            icon: const Icon(Icons.camera_alt_outlined),
            label: Text(AppStrings.takePhoto),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),

          const SizedBox(height: 16),

          // ── Note ───────────────────────────
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBE6),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFFFE58F)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('📋 ', style: TextStyle(fontSize: 16)),
                Expanded(
                  child: Text(
                    AppStrings.yourAccountWillBe,
                    style: textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF7D6200),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}