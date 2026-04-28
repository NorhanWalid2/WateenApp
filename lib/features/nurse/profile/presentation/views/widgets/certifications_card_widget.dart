// import 'package:flutter/material.dart';
// import 'package:wateen_app/features/nurse/profile/data/models/nurse_profile_model.dart';

// class CertificationsCardWidget extends StatelessWidget {
//   final List<CertificationModel> certifications;

//   const CertificationsCardWidget({
//     super.key,
//     required this.certifications,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.primary,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 4,
//             offset: const Offset(0, 1),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Title
//           Row(
//             children: [
//               Icon(
//                 Icons.verified_rounded,
//                 size: 20,
//                 color: Theme.of(context).colorScheme.secondary,
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 'Certifications & Licenses',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700,
//                   color: Theme.of(context).colorScheme.inverseSurface,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),

//           // Certification cards
//           ...certifications.map(
//             (c) => Container(
//               margin: const EdgeInsets.only(bottom: 10),
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.surface,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     c.title,
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color:
//                           Theme.of(context).colorScheme.inverseSurface,
//                     ),
//                   ),
//                   const SizedBox(height: 3),
//                   Text(
//                     c.issuedBy,
//                     style: TextStyle(
//                       fontSize: 12,
//                       color:
//                           Theme.of(context).colorScheme.outlineVariant,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }