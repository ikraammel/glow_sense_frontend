import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';

class EmailPreferencesScreen extends StatefulWidget {
  const EmailPreferencesScreen({super.key});
  @override
  State<EmailPreferencesScreen> createState() => _EmailPreferencesScreenState();
}

class _EmailPreferencesScreenState extends State<EmailPreferencesScreen> {
  bool _isSaving = false;

  bool _weeklyDigest     = true;
  bool _analysisResults  = true;
  bool _productReviews   = false;
  bool _skincareTips     = true;
  bool _promotions       = false;
  bool _accountUpdates   = true;
  bool _securityAlerts   = true;

  String _digestDay = 'Monday';
  String _digestTime = 'Morning';

  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  final List<String> _times = ['Morning', 'Afternoon', 'Evening'];

  Future<void> _save() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Row(children: [
          Icon(Icons.check_circle_rounded, color: Colors.white),
          SizedBox(width: 8),
          Text('Email preferences saved!'),
        ]),
        backgroundColor: Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      ));
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final email = authState is AuthAuthenticated ? authState.user.email : '';

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9FB),
      appBar: AppBar(
        title: const Text('Email Preferences',
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
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? const SizedBox(width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFE08499)))
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
          // Current email display
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFFE5B3BC), Color(0xFFC7CCF1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.email_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Sending emails to',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text(email,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF333333))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          _buildGroup('Skincare Updates', [
            _buildPref(
              'Weekly Digest',
              'A summary of your skin health and tips every week',
              Icons.summarize_outlined,
              _weeklyDigest,
              (v) => setState(() => _weeklyDigest = v),
              badge: 'Recommended',
            ),
            _buildPref(
              'Analysis Results',
              'Full report delivered to your inbox after each scan',
              Icons.analytics_outlined,
              _analysisResults,
              (v) => setState(() => _analysisResults = v),
            ),
            _buildPref(
              'Skincare Tips',
              'Curated tips tailored to your skin type',
              Icons.lightbulb_outline_rounded,
              _skincareTips,
              (v) => setState(() => _skincareTips = v),
            ),
            _buildPref(
              'Product Reviews',
              'Expert reviews on recommended products for your skin',
              Icons.star_outline_rounded,
              _productReviews,
              (v) => setState(() => _productReviews = v),
            ),
          ]),

          const SizedBox(height: 16),
          _buildGroup('Account & Security', [
            _buildPref(
              'Account Updates',
              'Important changes to your account or subscription',
              Icons.manage_accounts_outlined,
              _accountUpdates,
              (v) => setState(() => _accountUpdates = v),
            ),
            _buildPref(
              'Security Alerts',
              'Login attempts and security notifications',
              Icons.security_outlined,
              _securityAlerts,
              (v) => setState(() => _securityAlerts = v),
              locked: true,
            ),
          ]),

          const SizedBox(height: 16),
          _buildGroup('Marketing', [
            _buildPref(
              'Promotions & Offers',
              'Special deals on skincare products',
              Icons.local_offer_outlined,
              _promotions,
              (v) => setState(() => _promotions = v),
            ),
          ]),

          // Digest schedule
          if (_weeklyDigest) ...[
            const SizedBox(height: 20),
            _buildDigestSchedule(),
          ],

          const SizedBox(height: 20),
          // Unsubscribe note
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.grey),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Security alerts cannot be disabled as they protect your account. You can unsubscribe from all marketing emails in one tap.',
                    style: TextStyle(color: Colors.grey, fontSize: 11, height: 1.5),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {
              setState(() {
                _weeklyDigest    = false;
                _analysisResults = false;
                _productReviews  = false;
                _skincareTips    = false;
                _promotions      = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Unsubscribed from all marketing emails'),
                backgroundColor: Color(0xFF888888),
                behavior: SnackBarBehavior.floating,
              ));
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              foregroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Unsubscribe from All Emails', fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildGroup(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(title.toUpperCase(),
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.bold,
                  color: Color(0xFF888888), letterSpacing: 0.6)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildPref(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged, {
    String? badge,
    bool locked = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
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
                Row(
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF333333))),
                    if (badge != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(badge,
                            style: const TextStyle(
                                fontSize: 9,
                                color: Color(0xFF4CAF50),
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(color: Color(0xFF888888), fontSize: 11)),
              ],
            ),
          ),
          locked
              ? const Icon(Icons.lock_rounded, color: Colors.grey, size: 20)
              : Switch.adaptive(
                  value: value,
                  onChanged: onChanged,
                  activeColor: const Color(0xFFF1ABB9),
                  activeTrackColor: const Color(0xFFF1ABB9).withOpacity(0.3),
                ),
        ],
      ),
    );
  }

  Widget _buildDigestSchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 10),
          child: Text('DIGEST SCHEDULE',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
                  color: Color(0xFF888888), letterSpacing: 0.6)),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Send on', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF555555))),
              const SizedBox(height: 10),
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _days.map((d) {
                    final sel = _digestDay == d;
                    return GestureDetector(
                      onTap: () => setState(() => _digestDay = d),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: sel ? const Color(0xFFF1ABB9) : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(d.substring(0, 3),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: sel ? Colors.white : Colors.grey.shade600)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 14),
              const Text('At', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF555555))),
              const SizedBox(height: 10),
              Row(
                children: _times.map((t) {
                  final sel = _digestTime == t;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _digestTime = t),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: sel ? const Color(0xFFF1ABB9).withOpacity(0.15) : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: sel ? const Color(0xFFF1ABB9) : Colors.grey.shade200,
                            width: sel ? 2 : 1,
                          ),
                        ),
                        child: Text(t,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: sel ? const Color(0xFFE08499) : Colors.grey)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
