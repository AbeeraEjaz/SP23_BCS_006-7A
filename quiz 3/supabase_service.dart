// lib/services/supabase_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/submission_model.dart';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;
  static const String _table = 'submissions';

  // ─────────────────────────── CREATE ────────────────────────────
  static Future<SubmissionModel?> createSubmission(
      SubmissionModel submission) async {
    try {
      final response = await _client
          .from(_table)
          .insert(submission.toJson())
          .select()
          .single();
      return SubmissionModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to create submission: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // ─────────────────────────── READ (all) ─────────────────────────
  static Future<List<SubmissionModel>> getAllSubmissions() async {
    try {
      final response = await _client
          .from(_table)
          .select()
          .order('created_at', ascending: false);
      return (response as List<dynamic>)
          .map((json) => SubmissionModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch submissions: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // ─────────────────────────── READ (single) ───────────────────────
  static Future<SubmissionModel?> getSubmissionById(String id) async {
    try {
      final response =
          await _client.from(_table).select().eq('id', id).single();
      return SubmissionModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to fetch submission: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // ─────────────────────────── UPDATE ─────────────────────────────
  static Future<SubmissionModel?> updateSubmission(
      String id, SubmissionModel submission) async {
    try {
      final response = await _client
          .from(_table)
          .update(submission.toJson())
          .eq('id', id)
          .select()
          .single();
      return SubmissionModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw Exception('Failed to update submission: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // ─────────────────────────── DELETE ─────────────────────────────
  static Future<void> deleteSubmission(String id) async {
    try {
      await _client.from(_table).delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw Exception('Failed to delete submission: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // ─────────────────────── SEARCH by name ─────────────────────────
  static Future<List<SubmissionModel>> searchSubmissions(String query) async {
    try {
      final response = await _client
          .from(_table)
          .select()
          .ilike('full_name', '%$query%')
          .order('created_at', ascending: false);
      return (response as List<dynamic>)
          .map((json) => SubmissionModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to search submissions: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
