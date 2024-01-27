import 'package:bloc/bloc.dart';
import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:education_app/src/course/domain/usecases/add_course.dart';
import 'package:education_app/src/course/domain/usecases/get_courses.dart';
import 'package:equatable/equatable.dart';

part 'course_state.dart';

class CourseCubit extends Cubit<CourseState> {
  CourseCubit(this._addCourse, this._getCourse) : super(const CourseInitial());

  final AddCourse _addCourse;
  final GetCourse _getCourse;

  Future<void> addCourse(Course course) async {
    emit(const AddingCourse());
    final result = await _addCourse(course);
    result.fold(
      (failure) => emit(CourseError(failure.errorMeesage)),
      (_) => emit(const CourseAdded()),
    );
  }

  Future<void> getCourse() async {
    emit(const LoadingCourses());
    final result = await _getCourse();
    result.fold(
      (failure) => emit(CourseError(failure.errorMeesage)),
      (courses) => emit(CoursesLoaded(courses)),
    );
  }
}
