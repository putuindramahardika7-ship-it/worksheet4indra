import '../models/course.dart';

abstract class CourseDataSource {
  Future<List<Course>> getCourses();
  Stream<List<Course>> getCoursesStream(); // TAHAP 16: Stream Realtime
  Future<Course> createCourse(Course course);
  Future<void> updateCourse(int id, Course course);
  Future<void> deleteCourse(int id);
}