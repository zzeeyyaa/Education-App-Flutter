import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/course/features/videos/data/models/video_model.dart';
import 'package:education_app/src/course/features/videos/domain/entities/video.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../fixtures/fixture_reader.dart';

class MockVideoModel extends Mock implements VideoModel {}

void main() {
  final timeStampData = {
    '_seconds': 1277483548,
    '_nanoseconds': 123456000,
  };

  final date =
      DateTime.fromMillisecondsSinceEpoch(timeStampData['_seconds']!).add(
    Duration(microseconds: timeStampData['_nanoseconds']!),
  );

  final timeStamp = Timestamp.fromDate(date);

  final tVideoModel = VideoModel.empty();

  final tMap = jsonDecode(fixture('video.json')) as DataMap;
  tMap['uploadDate'] = timeStamp;

  test('should be a subclass of [Video] entity', () {
    expect(tVideoModel, isA<Video>());
  });

  group('fromMap', () {
    test('should return [VideoModel] with the correct data', () {
      final result = VideoModel.fromMap(tMap);
      expect(result, equals(tVideoModel));
    });
  });

  group('toMap', () {
    test('should return [Map] with the proper data', () {
      final result = tVideoModel.toMap()..remove('uploadDate');

      final map = DataMap.from(tMap)..remove('uploadDate');

      expect(result, equals(map));
    });
  });

  group('copyWith', () {
    test('should return [VideoModel] with the new data', () {
      final result = tVideoModel.copyWith(title: 'new title');
      expect(result.title, 'new title');
    });
  });
}
