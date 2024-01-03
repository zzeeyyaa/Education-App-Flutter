import 'dart:convert';

import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/auth/data/models/user_model.dart';
import 'package:education_app/src/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tLocalUserModel = LocalUserModel.empty();

  test('should be a subclass of [LocalUser]', () {
    expect(tLocalUserModel, isA<LocalUser>());
  });

  final tJson = fixture('user.json');
  final tMap = jsonDecode(tJson) as DataMap;

  group('fromMap', () {
    test('should return valid [LocalUserModel] from the Map', () {
      //act
      final result = LocalUserModel.fromMap(tMap);

      //assert
      expect(result, isA<LocalUserModel>()); //makesure, localUserModel normal
      expect(result, equals(tLocalUserModel));
    });
  });

  group('toMap', () {
    test('should throw an error when map is invalid', () {
      final map = DataMap.from(tMap)..remove('uid');

      const call = LocalUserModel.fromMap;

      expect(() => call(map), throwsA(isA<Error>()));
    });
    test('should return valid dataMap from LocalUserModel', () {
      final result = tLocalUserModel.toMap();

      expect(result, equals(tMap));
    });
  });
  group('copyWith', () {
    test('should return valid [LocalUserModel] with updated value', () {
      final result = tLocalUserModel.copyWith(uid: '2');

      expect(result.uid, '2');
    });
  });
}
