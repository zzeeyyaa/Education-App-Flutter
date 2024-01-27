import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/course/data/models/course_model.dart';
import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final timeStampData = {
    '_second': 1677483548,
    '_nanosecond': 123456008,
  };

  final date = DateTime.fromMillisecondsSinceEpoch(timeStampData['_second']!)
      .add(Duration(microseconds: timeStampData['_nanosecond']!));

  final timestamp = Timestamp.fromDate(date);

  final tCourseModel = CourseModel.empty();

  final tJson = fixture('course.json');
  final tMap = jsonDecode(tJson) as DataMap;
  tMap['createdAt'] = timestamp;
  tMap['updatedAt'] = timestamp;

  test('make sure that CourseModel is subclass of Course entity', () {
    expect(tCourseModel, isA<Course>());
  });

  group('empty', () {
    test('should return a [CourseModel] with empty data', () {
      final result = CourseModel.empty();
      expect(result.title, '');
    });
  });

  group('fromMap', () {
    test('should return a [CourseModel] with the correct data', () {
      final result = CourseModel.fromMap(tMap);

      expect(result, equals(tCourseModel));
    });
  });

  group('toMap', () {
    test('should throw a Map with proper data', () async {
      final result = tCourseModel.toMap()
        ..remove('createdAt')
        ..remove('updatedAt');

      final map = DataMap.from(tMap)
        ..remove('createdAt')
        ..remove('updatedAt');

      expect(result, equals(map));
    });
  });

  group('copyWith', () {
    test('should return a [CourseModel] with the new data', () async {
      final result = tCourseModel.copyWith(title: 'New Title');

      expect(result.title, 'New Title');
    });
  });
}
