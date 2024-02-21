import 'dart:convert';

import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/course/features/exams/data/models/user_choice_model.dart';
import 'package:education_app/src/course/features/exams/domain/entities/user_choice.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../fixtures/fixture_reader.dart';

void main() {
  const tUserChoiceModel = UserChoiceModel.empty();

  group('UserChoiceModel', () {
    test('should be a subclss of [UserChoice] entity', () async {
      expect(tUserChoiceModel, isA<UserChoice>());
    });
  });

  group('fromMap', () {
    test('should return a valid [UserChoiceModel] when the JSON is not null',
        () async {
      final map = jsonDecode(fixture('user_choice.json')) as DataMap;
      final result = UserChoiceModel.fromMap(map);

      expect(result, tUserChoiceModel);
    });
  });

  group('toMap', () {
    test('should return a Dart map containing the proper data', () async {
      final map = jsonDecode(fixture('user_choice.json')) as DataMap;
      final result = tUserChoiceModel.toMap();

      expect(result, map);
    });
  });

  group('copyWith', () {
    test('should return a anew [UserChoiceModel] with the same value',
        () async {
      final result = tUserChoiceModel.copyWith(questionId: 'new question id');

      expect(result.questionId, 'new question id');
    });
  });
}
