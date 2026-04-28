// import 'package:flutter/material.dart';
// import 'package:wateen_app/features/nurse/profile/data/models/nurse_profile_model.dart';


// class ScheduleCardWidget extends StatelessWidget {
//   final List<ScheduleModel> schedule;

//   const ScheduleCardWidget({super.key, required this.schedule});

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
//           // Title + Update
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Icon(
//                     Icons.calendar_month_rounded,
//                     size: 20,
//                     color: Theme.of(context).colorScheme.secondary,
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     'Available Schedule',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w700,
//                       color: Theme.of(context).colorScheme.inverseSurface,
//                     ),
//                   ),
//                 ],
//               ),
//               GestureDetector(
//                 onTap: () {
//                   // TODO: navigate to update schedule
//                 },
//                 child: Text(
//                   'Update',
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                     color: Theme.of(context).colorScheme.secondary,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),

//           // Schedule rows
//           ...schedule.map(
//             (s) => Padding(
//               padding: const EdgeInsets.only(bottom: 12),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     s.days,
//                     style: TextStyle(
//                       fontSize: 13,
//                       color: Theme.of(context).colorScheme.inverseSurface,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   Text(
//                     s.isClosed ? 'Closed' : s.hours,
//                     style: TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w600,
//                       color: s.isClosed
//                           ? Theme.of(context).colorScheme.secondary
//                           : Theme.of(context).colorScheme.inverseSurface,
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