import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? _user;
  bool _isSigningOut = false;

  @override
  void initState() {
    super.initState();
    _user = AuthService.currentUser;
  }

  String get _initials {
    final email = _user?.email ?? '';
    if (email.isEmpty) return '?';
    return email[0].toUpperCase();
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null) return 'N/A';
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}  '
          '${dt.hour.toString().padLeft(2, '0')}:'
          '${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return isoDate;
    }
  }

  Future<void> _signOut() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size(80, 40),
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    setState(() => _isSigningOut = true);

    try {
      await AuthService.signOut();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      setState(() => _isSigningOut = false);
    }
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final email = _user?.email ?? 'Unknown';
    final userId = _user?.id ?? 'N/A';
    final createdAt = _formatDate(_user?.createdAt);
    final lastSignIn = _formatDate(
        _user?.lastSignInAt);
    final emailConfirmed =
        _user?.emailConfirmedAt != null;
    final provider =
        _user?.appMetadata['provider'] as String? ?? 'email';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F3FF),
      appBar: AppBar(
        title: const Text('Home'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: _isSigningOut
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.logout),
            onPressed: _isSigningOut ? null : _signOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Avatar
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFF3F3D9E)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      email,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _StatusBadge(
                          label: emailConfirmed ? 'Email Verified' : 'Unverified',
                          color: emailConfirmed ? Colors.green : Colors.orange,
                          icon: emailConfirmed
                              ? Icons.verified_outlined
                              : Icons.warning_amber_outlined,
                        ),
                        const SizedBox(width: 8),
                        _StatusBadge(
                          label: provider,
                          color: Colors.blue,
                          icon: Icons.login,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Welcome banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF6C63FF).withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.waving_hand,
                      color: Color(0xFF6C63FF), size: 22),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'You are successfully logged in via Supabase Authentication!',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF3F3D9E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // User Details Card
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                      child: Text(
                        'Account Information',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    _DetailTile(
                      icon: Icons.email_outlined,
                      label: 'Email Address',
                      value: email,
                      onCopy: () => _copyToClipboard(email, 'Email'),
                    ),
                    _Divider(),
                    _DetailTile(
                      icon: Icons.fingerprint,
                      label: 'User ID',
                      value: userId,
                      isMonospace: true,
                      onCopy: () => _copyToClipboard(userId, 'User ID'),
                    ),
                    _Divider(),
                    _DetailTile(
                      icon: Icons.calendar_today_outlined,
                      label: 'Account Created',
                      value: createdAt,
                    ),
                    _Divider(),
                    _DetailTile(
                      icon: Icons.access_time_outlined,
                      label: 'Last Sign In',
                      value: lastSignIn,
                    ),
                    _Divider(),
                    _DetailTile(
                      icon: Icons.verified_user_outlined,
                      label: 'Email Confirmed',
                      value: emailConfirmed ? 'Yes – verified' : 'No – pending',
                      valueColor: emailConfirmed ? Colors.green : Colors.orange,
                    ),
                    _Divider(),
                    _DetailTile(
                      icon: Icons.login_outlined,
                      label: 'Auth Provider',
                      value: provider.toUpperCase(),
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Sign out button
            OutlinedButton.icon(
              onPressed: _isSigningOut ? null : _signOut,
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onCopy;
  final bool isMonospace;
  final bool isLast;
  final Color? valueColor;

  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
    this.onCopy,
    this.isMonospace = false,
    this.isLast = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFF6C63FF).withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF6C63FF)),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: Colors.grey.shade500,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          fontSize: 13,
          color: valueColor ?? const Color(0xFF1A1A2E),
          fontWeight: FontWeight.w600,
          fontFamily: isMonospace ? 'monospace' : null,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: onCopy != null
          ? IconButton(
              icon: const Icon(Icons.copy_outlined, size: 16),
              onPressed: onCopy,
              color: Colors.grey.shade400,
              tooltip: 'Copy',
            )
          : null,
      dense: true,
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, indent: 68, endIndent: 16);
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _StatusBadge(
      {required this.label, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
