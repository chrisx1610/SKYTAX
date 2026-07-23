import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/i18n/app_strings.dart';
import '../../state/app_controller.dart';
import '../history_screen.dart';
import 'aircraft_section.dart';
import 'reports_section.dart';
import 'settings_section.dart';
import 'users_section.dart';

/// Panel administrativo con navegación lateral entre secciones.
class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _index = 0;

  Future<void> _logout() async {
    final NavigatorState navigator = Navigator.of(context);
    await context.read<AppController>().adminLogout();
    if (mounted) navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final AppController controller = context.watch<AppController>();
    final AppStrings s = controller.strings;

    final List<(IconData, String, Widget)> sections = [
      (Icons.flight_rounded, s.sectionAircraft, const AircraftSection()),
      (Icons.group_rounded, s.sectionUsers, const UsersSection()),
      (Icons.tune_rounded, s.sectionSettings, const SettingsSection()),
      (
        Icons.receipt_long_rounded,
        s.sectionHistory,
        const Padding(padding: EdgeInsets.all(16), child: HistoryView()),
      ),
      (Icons.insert_chart_rounded, s.sectionReports, const ReportsSection()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${s.adminTitle} · ${controller.config.airportDisplay}'),
        actions: [
          if (controller.currentAdmin != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: Text(
                  controller.currentAdmin!.fullName,
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          IconButton(
            tooltip: s.logout,
            iconSize: 26,
            icon: const Icon(Icons.logout_rounded),
            onPressed: _logout,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              selectedIndex: _index,
              onDestinationSelected: (value) =>
                  setState(() => _index = value),
              labelType: NavigationRailLabelType.all,
              minWidth: 96,
              destinations: [
                for (final (IconData icon, String label, _) in sections)
                  NavigationRailDestination(
                    icon: Icon(icon, size: 28),
                    label: Text(label, style: const TextStyle(fontSize: 13)),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: sections[_index].$3),
          ],
        ),
      ),
    );
  }
}
