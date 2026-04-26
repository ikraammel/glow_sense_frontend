import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_service_screen.dart';
import 'help_support_screen.dart';
import 'notifications_settings_screen.dart';
import 'email_preferences_screen.dart';
import 'app_version_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthAuthenticated ? authState.user : null;
    final notificationsEnabled = user?.notificationsEnabled ?? true;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9FB),
      appBar: AppBar(
        title: const Text('Settings',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF333333),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Preferences group
          _groupLabel('Preferences'),
          _buildGroup([
            _settingsTile(
              context,
              icon: Icons.notifications_outlined,
              iconBg: const Color(0xFFF1ABB9),
              title: 'Notifications',
              subtitle: notificationsEnabled ? 'Enabled' : 'Disabled',
              trailing: Switch.adaptive(
                value: notificationsEnabled,
                onChanged: (_) => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NotificationsSettingsScreen(
                        initialEnabled: notificationsEnabled),
                  ),
                ),
                activeColor: const Color(0xFFF1ABB9),
                activeTrackColor: const Color(0xFFF1ABB9).withOpacity(0.3),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NotificationsSettingsScreen(
                      initialEnabled: notificationsEnabled),
                ),
              ),
            ),
            _settingsTile(
              context,
              icon: Icons.email_outlined,
              iconBg: const Color(0xFF91C4EA),
              title: 'Email Preferences',
              subtitle: 'Manage email subscriptions',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EmailPreferencesScreen()),
              ),
            ),
          ]),

          const SizedBox(height: 20),
          _groupLabel('Legal & Privacy'),
          _buildGroup([
            _settingsTile(
              context,
              icon: Icons.shield_outlined,
              iconBg: const Color(0xFFC7CCF1),
              title: 'Privacy Policy',
              subtitle: 'How we handle your data',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
              ),
            ),
            _settingsTile(
              context,
              icon: Icons.gavel_outlined,
              iconBg: const Color(0xFFFFECB3),
              title: 'Terms of Service',
              subtitle: 'Rules for using GlowSense',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TermsOfServiceScreen()),
              ),
            ),
          ]),

          const SizedBox(height: 20),
          _groupLabel('Support'),
          _buildGroup([
            _settingsTile(
              context,
              icon: Icons.help_outline_rounded,
              iconBg: const Color(0xFFB2DFDB),
              title: 'Help & Support',
              subtitle: 'FAQ & contact support',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
              ),
            ),
            _settingsTile(
              context,
              icon: Icons.info_outline_rounded,
              iconBg: Colors.grey.shade200,
              title: 'App Version',
              subtitle: 'v1.0.0 (Build 42)',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AppVersionScreen()),
              ),
            ),
          ]),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _groupLabel(String label) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 10),
        child: Text(label.toUpperCase(),
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF888888),
                letterSpacing: 0.6)),
      );

  Widget _buildGroup(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        children: List.generate(children.length, (i) {
          return Column(
            children: [
              children[i],
              if (i < children.length - 1)
                const Divider(height: 1, indent: 56, endIndent: 16),
            ],
          );
        }),
      ),
    );
  }

  Widget _settingsTile(
    BuildContext context, {
    required IconData icon,
    required Color iconBg,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: iconBg.withOpacity(0.25), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconBg.withOpacity(1), size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xFF333333))),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(color: Color(0xFF888888), fontSize: 12)),
                ],
              ),
            ),
            trailing ??
                Icon(Icons.chevron_right_rounded,
                    color: Colors.grey.shade400, size: 22),
          ],
        ),
      ),
    );
  }
}
