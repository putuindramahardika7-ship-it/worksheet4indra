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

  // TAHAP 16: Stream data realtime dari Supabase
  @override
  Stream<List<Course>> getCoursesStream() {
    return _client
        .from('courses')
        .stream(primaryKey: ['id'])
        .order('id', ascending: true)
        .map((data) => data.map((json) => Course.fromJson(json)).toList());
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

  @override
  Future<void> deleteCourse(int id) async {
    await _client
        .from('courses')
        .delete()
        .eq('id', id);
  }
}