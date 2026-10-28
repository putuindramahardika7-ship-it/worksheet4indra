import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/course.dart';
import 'course_data_source.dart';

class CourseSupabaseService implements CourseDataSource {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<List<Course>> getCourses() async {
    final response = await _client
        .from('courses')
        .select()
        .order('id', ascending: true);

    return (response as List<dynamic>)
        .map((json) => Course.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Course> createCourse(Course course) async {
    final response = await _client
        .from('courses')
        .insert(course.toJson())
        .select()
        .single();

    return Course.fromJson(response);
  }

  @override
  Future<void> updateCourse(int id, Course course) async {
    await _client
        .from('courses')
        .update(course.toJson())
        .eq('id', id);
  }

  // TAHAP 15: Menghapus (DELETE) data course di tabel 'courses' Supabase berdasarkan ID
  @override
  Future<void> deleteCourse(int id) async {
    await _client
        .from('courses')
        .delete()
        .eq('id', id);
  }
}