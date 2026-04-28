import 'package:flutter/material.dart';
import 'package:wateen_app/features/nurse/active_visit/presentation/views/active_visit_view.dart';
import 'package:wateen_app/features/nurse/home/presentation/views/nurse_home_view.dart';
import 'package:wateen_app/features/nurse/layout/widgets/nurse_drawer_widget.dart';
import 'package:wateen_app/features/nurse/profile/presentation/views/profile_view.dart';
import 'package:wateen_app/features/nurse/reports/presentation/views/reports_view.dart';

class NurseMainLayout extends StatefulWidget {
  const NurseMainLayout({super.key});

  @override
  State<NurseMainLayout> createState() => NurseMainLayoutState();
}

class NurseMainLayoutState extends State<NurseMainLayout> {
  int currentIndex = 0;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void onNavSelected(int index) {
    setState(() => currentIndex = index);
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;

        if (currentIndex != 0) {
          setState(() => currentIndex = 0);
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        drawer: NurseDrawerWidget(
          currentIndex: currentIndex,
          onItemSelected: onNavSelected,
        ),
        body: IndexedStack(
          index: currentIndex,
          children: [
            NurseHomeView(onMenuTap: openDrawer),
            
              ReportsView(onMenuTap: openDrawer),
              NurseProfileView(onMenuTap: openDrawer),
          ],
        ),
      ),
    );
  }
}