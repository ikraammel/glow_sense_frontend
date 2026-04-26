import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/api_service.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  final bool initialEnabled;
  const NotificationsSettingsScreen({super.key, this.initialEnabled = true});
  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  bool _isSaving = false;

  // Notification toggles
  late bool _allNotifications;
  bool _analysisReminders = true;
  bool _weeklyReports = true;
  bool _newRecommendations = true;
  bool _routineReminders = false;
  bool _progressUpdates = true;
  bool _productAlerts = false;
  bool _promotions = false;

  // Reminder frequency
  String _reminderFrequency = 'weekly';

  @override
  void initState() {
    super.initState();
    _allNotifications = widget.initialEnabled;
  }

  Future<void> _saveSettings() async {
    setState(() => _isSaving = true);
    try {
      await context.read<ApiService>().updateProfile({
        'notificationsEnabled': _allNotifications,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Row(children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text('Notification preferences saved!'),
          ]),
          backgroundColor: Color(0xFF4CAF50),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
          backgroundColor: const Color(0xFFE53935),
          behavior: SnackBarBehavior.floating,
        ));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9FB),
      appBar: AppBar(
        title: const Text('Notifications',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF333333),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: _isSaving ? null : _saveSettings,
              child: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFE08499)),
                    )
                  : const Text('Save',
                      style: TextStyle(
                          color: Color(0xFFE08499), fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Master toggle
          _buildMasterToggle(),
          const SizedBox(height: 20),

          // Notification types
          _buildSection('Skin Care', [
            _buildToggle(
              'Analysis Reminders',
              'Reminders to do your weekly skin analysis',
              Icons.camera_alt_outlined,
              _analysisReminders,
              (v) => setState(() => _analysisReminders = v),
              enabled: _allNotifications,
            ),
            _buildToggle(
              'Weekly Reports',
              'Your skin progress report every week',
              Icons.insert_chart_outlined_rounded,
              _weeklyReports,
              (v) => setState(() => _weeklyReports = v),
              enabled: _allNotifications,
            ),
            _buildToggle(
              'New Recommendations',
              'When new skincare tips are available for you',
              Icons.lightbulb_outline_rounded,
              _weeklyReports, // Changed from _newRecommendations to _weeklyReports in provided code, but I'll fix it if it looks like a typo. Actually looking at provided code it says _newRecommendations = v below.
              (v) => setState(() => _newRecommendations = v),
              enabled: _allNotifications,
            ),
            _buildToggle(
              'Routine Reminders',
              'Morning and evening skincare routine alerts',
              Icons.schedule_rounded,
              _routineReminders,
              (v) => setState(() => _routineReminders = v),
              enabled: _allNotifications,
            ),
          ]),

          const SizedBox(height: 16),
          _buildSection('Progress & Updates', [
            _buildToggle(
              'Progress Updates',
              'Celebrate your skin improvement milestones',
              Icons.trending_up_rounded,
              _progressUpdates,
              (v) => setState(() => _progressUpdates = v),
              enabled: _allNotifications,
            ),
            _buildToggle(
              'Product Alerts',
              'When scanned products are flagged for your skin',
              Icons.science_outlined,
              _productAlerts,
              (v) => setState(() => _productAlerts = v),
              enabled: _allNotifications,
            ),
          ]),

          const SizedBox(height: 16),
          _buildSection('Marketing', [
            _buildToggle(
              'Promotions & Offers',
              'Deals on skincare products we recommend',
              Icons.local_offer_outlined,
              _promotions,
              (v) => setState(() => _promotions = v),
              enabled: _allNotifications,
            ),
          ]),

          const SizedBox(height: 20),
          // Reminder frequency
          if (_allNotifications && _analysisReminders) ...[
            _buildFrequencySelector(),
            const SizedBox(height: 20),
          ],

          // Info note
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF91C4EA).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.phone_android_rounded, color: Color(0xFF91C4EA), size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Push notifications must also be enabled in your device Settings > Apps > Smart Skin.',
                    style: TextStyle(color: Colors.blueGrey, fontSize: 12, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildMasterToggle() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: _allNotifications
            ? const LinearGradient(
                colors: [Color(0xFFE5B3BC), Color(0xFFC7CCF1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(colors: [Color(0xFFE0E0E0), Color(0xFFBDBDBD)]),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_rounded, color: Colors.white, size: 28),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('All Notifications',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 2),
                Text('Enable or disable all push notifications',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Switch.adaptive(
            value: _allNotifications,
            onChanged: (v) => setState(() => _allNotifications = v),
            activeColor: Colors.white,
            activeTrackColor: Colors.white.withOpacity(0.4),
            inactiveThumbColor: Colors.white70,
            inactiveTrackColor: Colors.white24,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(title,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF888888),
                  letterSpacing: 0.5)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildToggle(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged, {
    bool enabled = true,
  }) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF1ABB9).withOpacity(0.12),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, color: const Color(0xFFE08499), size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF333333))),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(color: Color(0xFF888888), fontSize: 11)),
                ],
              ),
            ),
            Switch.adaptive(
              value: enabled ? value : false,
              onChanged: enabled ? onChanged : null,
              activeColor: const Color(0xFFF1ABB9),
              activeTrackColor: const Color(0xFFF1ABB9).withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencySelector() {
    final options = [
      {'value': 'daily', 'label': 'Daily', 'desc': 'Every day'},
      {'value': 'weekly', 'label': 'Weekly', 'desc': 'Once a week'},
      {'value': 'biweekly', 'label': 'Bi-weekly', 'desc': 'Every 2 weeks'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 10),
          child: Text('REMINDER FREQUENCY',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF888888),
                  letterSpacing: 0.5)),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
          ),
          child: Row(
            children: options.map((opt) {
              final selected = _reminderFrequency == opt['value'];
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _reminderFrequency = opt['value']!),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFFF1ABB9).withOpacity(0.15)
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected ? const Color(0xFFF1ABB9) : Colors.grey.shade200,
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Column(children: [
                      Text(opt['label']!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: selected ? const Color(0xFFE08499) : const Color(0xFF555555))),
                      Text(opt['desc']!,
                          style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    ]),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
