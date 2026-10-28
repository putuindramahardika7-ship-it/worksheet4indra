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

  // TAHAP 13: Memasukkan (INSERT) data course baru ke tabel 'courses' Supabase
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
    throw UnimplementedError('Akan diimplementasikan di Tahap 14');
  }

  @override
  Future<void> deleteCourse(int id) async {
    throw UnimplementedError('Akan diimplementasikan di Tahap 15');
  }
}