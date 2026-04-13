import 'package:flutter/material.dart';
 import 'package:wateen_app/features/auth/presentation/views/widgets/step_card.dart';
import 'package:wateen_app/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return StepCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.uploadNurseLicense, style: textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(l10n.uploadAClearPhoto, style: textTheme.bodySmall),
          const SizedBox(height: 20),

          // ── Upload Box ─────────────────────
          GestureDetector(
            onTap: () => onFileUploaded('license_document.pdf'),
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
                        Text(uploadedFileName!,
                            style: textTheme.bodySmall
                                ?.copyWith(color: colorScheme.secondary)),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file_outlined,
                            color: colorScheme.onSurfaceVariant, size: 36),
                        const SizedBox(height: 8),
                        Text(l10n.uploadLicenseDocument,
                            style: textTheme.bodyMedium),
                        Text(l10n.jPGPNGOrPDF, style: textTheme.bodySmall),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: 12),

          OutlinedButton.icon(
            onPressed: () => onFileUploaded('photo_license.jpg'),
            icon: const Icon(Icons.camera_alt_outlined),
            label: Text(l10n.takePhoto),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),

          const SizedBox(height: 16),

          ,
        ],
      ),
    );
  }
}