import 'dart:convert';

import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/course/features/exams/data/models/question_choice_model.dart';
import 'package:education_app/src/course/features/exams/domain/entities/question_choice.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../fixtures/fixture_reader.dart';
import '../../domain/usecases/exam_repo.mock.dart';

void main() {
  const tQuestionChoiceModel = QuestionChoiceModel.empty();

  group('QuestionChoiceModel', () {
    test('should be subclass of [QuestionChoice] entity', () {
      expect(tQuestionChoiceModel, isA<QuestionChoice>());
    });
  });

  var map = jsonDecode(fixture('exam.json')) as DataMap;
  map = (map['questions'] as List<dynamic>)[0] as DataMap;
  map = (map['choices'] as List<dynamic>)[0] as DataMap;

  group('fromMap', () {
    test(
        'should return a valid [QuestionChoiceModel] when the JSON is not null',
        () async {
      final result = QuestionChoiceModel.fromMap(map);
      expect(result, tQuestionChoiceModel);
    });
  });

  group('fromUploadMap', () {
    test(
        'should return a valid [QuestionChoiceModel] when the JSON is not null',
        () async {
      final map =
          jsonDecode(fixture('uploaded_exam_question_choice.json')) as DataMap;
      final result = QuestionChoiceModel.fromUploadMap(map);

      expect(result, tQuestionChoiceModel);
    });
  });

  group('toMap', () {
    test('should return a Dart map containeing the proper data', () async {
      final result = tQuestionChoiceModel.toMap();
      expect(result, map);
    });
  });

  group('copyWith', () {
    test('should return new [QuestionChoiceModel] with the same value',
        () async {
      final result =
          tQuestionChoiceModel.copyWith(questionId: 'New Question Id');
      expect(result.questionId, 'New Question Id');
    });
  });
}
