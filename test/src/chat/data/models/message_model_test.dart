import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/chat/data/models/message_model.dart';
import 'package:education_app/src/chat/domain/entities/message.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final timestampData = {
    '_seconds': 1677483548,
    '_nanoseconds': 123456000,
  };

  final date = DateTime.fromMillisecondsSinceEpoch(timestampData['_seconds']!)
      .add(Duration(microseconds: timestampData['_nanoseconds']!));

  final timestamp = Timestamp.fromDate(date);
  final tMessageModel = MessageModel.empty();

  final tMap = jsonDecode(fixture('message.json')) as DataMap;
  tMap['timestamp'] = timestamp;

  test('should be a subclass of Message entity', () {
    expect(tMessageModel, isA<Message>());
  });

  group('fromMap', () {
    test('should return a valid model when the map is valid', () async {
      final result = MessageModel.fromMap(tMap);

      expect(result, isA<MessageModel>());

      expect(result, tMessageModel);
    });
  });

  group('copyWith', () {
    test(
      'should return a copy of the model with the given fields',
      () async {
        final result = tMessageModel.copyWith(message: 'New message');
        expect(result, isA<MessageModel>());
        expect(result.message, 'New message');
      },
    );
  });
}
