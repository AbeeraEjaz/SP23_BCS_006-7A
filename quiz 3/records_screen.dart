// lib/screens/records_screen.dart

import 'package:flutter/material.dart';
import '../models/submission_model.dart';
import '../services/supabase_service.dart';
import 'form_screen.dart';
import 'detail_screen.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  List<SubmissionModel> _submissions = [];
  List<SubmissionModel> _filtered = [];
  bool _isLoading = false;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSubmissions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSubmissions() async {
    setState(() => _isLoading = true);
    try {
      final data = await SupabaseService.getAllSubmissions();
      if (mounted) {
        setState(() {
          _submissions = data;
          _filtered = data;
        });
      }
    } catch (e) {
      if (mounted) _showSnack('Error loading records: $e', Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _filterSubmissions(String query) {
    setState(() {
      _searchQuery = query;
      _filtered = query.isEmpty
          ? _submissions
          : _submissions
              .where((s) =>
                  s.fullName.toLowerCase().contains(query.toLowerCase()) ||
                  s.email.toLowerCase().contains(query.toLowerCase()) ||
                  s.phone.contains(query))
              .toList();
    });
  }

  Future<void> _deleteSubmission(SubmissionModel submission) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 26),
            SizedBox(width: 8),
            Text('Confirm Delete'),
          ],
        ),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            children: [
              const TextSpan(text: 'Are you sure you want to delete\n'),
              TextSpan(
                text: '"${submission.fullName}"',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: '?\n\nThis action '),
              const TextSpan(
                text: 'cannot be undone',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.red),
              ),
              const TextSpan(text: '.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await SupabaseService.deleteSubmission(submission.id!);
        if (mounted) {
          _showSnack('Record deleted successfully', Colors.red.shade700);
          _loadSubmissions();
        }
      } catch (e) {
        if (mounted) _showSnack('Error deleting record: $e', Colors.red);
      }
    }
  }

  void _navigateToEdit(SubmissionModel submission) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => FormScreen(existingSubmission: submission),
      ),
    );
    if (updated == true) _loadSubmissions();
  }

  void _navigateToDetail(SubmissionModel submission) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailScreen(submission: submission),
      ),
    );
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  Color _genderColor(String gender) {
    switch (gender) {
      case 'Male':
        return const Color(0xFF1565C0);
      case 'Female':
        return const Color(0xFFC2185B);
      default:
        return const Color(0xFF6A1B9A);
    }
  }

  IconData _genderIcon(String gender) {
    switch (gender) {
      case 'Male':
        return Icons.male_rounded;
      case 'Female':
        return Icons.female_rounded;
      default:
        return Icons.transgender_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        title: const Text('All Submissions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: _loadSubmissions,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormScreen()),
          );
          _loadSubmissions();
        },
        backgroundColor: const Color(0xFF3F51B5),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add New',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // ── Search & Stats Header ─────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            color: const Color(0xFF3F51B5),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: _filterSubmissions,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search by name, email or phone...',
                    hintStyle:
                        const TextStyle(color: Colors.white60, fontSize: 14),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.white70),
                            onPressed: () {
                              _searchController.clear();
                              _filterSubmissions('');
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Records: ${_submissions.length}',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 12),
                    ),
                    if (_searchQuery.isNotEmpty)
                      Text(
                        'Showing: ${_filtered.length} results',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // ── Records List ──────────────────────────────────────
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Color(0xFF3F51B5),
                  ))
                : _filtered.isEmpty
                    ? _EmptyState(
                        hasSearch: _searchQuery.isNotEmpty,
                        onAdd: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const FormScreen()),
                          );
                          _loadSubmissions();
                        },
                      )
                    : RefreshIndicator(
                        onRefresh: _loadSubmissions,
                        color: const Color(0xFF3F51B5),
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                          itemCount: _filtered.length,
                          itemBuilder: (ctx, i) {
                            final s = _filtered[i];
                            return _SubmissionCard(
                              submission: s,
                              index: i + 1,
                              genderColor: _genderColor(s.gender),
                              genderIcon: _genderIcon(s.gender),
                              onTap: () => _navigateToDetail(s),
                              onEdit: () => _navigateToEdit(s),
                              onDelete: () => _deleteSubmission(s),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

// ── Submission Card ───────────────────────────────────────────────────────────
class _SubmissionCard extends StatelessWidget {
  final SubmissionModel submission;
  final int index;
  final Color genderColor;
  final IconData genderIcon;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SubmissionCard({
    required this.submission,
    required this.index,
    required this.genderColor,
    required this.genderIcon,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 10),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: genderColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        submission.fullName.isNotEmpty
                            ? submission.fullName[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: genderColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          submission.fullName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          submission.email,
                          style: TextStyle(
                              fontSize: 12.5, color: Colors.grey.shade500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Gender chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: genderColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(genderIcon, color: genderColor, size: 14),
                        const SizedBox(width: 3),
                        Text(
                          submission.gender,
                          style: TextStyle(
                            color: genderColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Details row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Row(
                children: [
                  _InfoChip(
                      icon: Icons.phone_outlined,
                      label: submission.phone),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _InfoChip(
                        icon: Icons.location_on_outlined,
                        label: submission.address,
                        truncate: true),
                  ),
                ],
              ),
            ),

            // Divider + Actions
            Divider(height: 1, color: Colors.grey.shade100),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      size: 13, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Tap card to view full details',
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade400),
                    ),
                  ),
                  // Edit button
                  TextButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_rounded, size: 15),
                    label: const Text('Edit',
                        style: TextStyle(fontSize: 13)),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF3F51B5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                    ),
                  ),
                  // Delete button
                  TextButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline_rounded, size: 15),
                    label: const Text('Delete',
                        style: TextStyle(fontSize: 13)),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red.shade600,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool truncate;

  const _InfoChip(
      {required this.icon, required this.label, this.truncate = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        truncate
            ? Expanded(
                child: Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            : Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasSearch;
  final VoidCallback onAdd;

  const _EmptyState({required this.hasSearch, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasSearch ? Icons.search_off_rounded : Icons.inbox_rounded,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              hasSearch ? 'No results found' : 'No submissions yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasSearch
                  ? 'Try a different search term'
                  : 'Tap the button below to add your first submission',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
            ),
            if (!hasSearch) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add),
                label: const Text('Add First Record'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
