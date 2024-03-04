import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/src/auth/data/models/user_model.dart';
import 'package:education_app/src/chat/data/datasources/chat_remote_datasource.dart';
import 'package:education_app/src/chat/data/models/group_model.dart';
import 'package:education_app/src/chat/data/models/message_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {
  late ChatRemoteDatasourceImpl remoteDatasource;
  late FakeFirebaseFirestore firestore;
  late MockFirebaseAuth auth;

  setUp(() async {
    firestore = FakeFirebaseFirestore();
    final user = MockUser(
      uid: 'uid',
      email: 'email',
      displayName: 'displayName',
    );
    final googleSignIn = MockGoogleSignIn();
    final signInAccount = await googleSignIn.signIn();
    final googleAuth = await signInAccount!.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );
    auth = MockFirebaseAuth(mockUser: user);
    await auth.signInWithCredential(credential);

    remoteDatasource = ChatRemoteDatasourceImpl(
      firestore: firestore,
      auth: auth,
    );
  });

  Future<DocumentReference> addMessage(
    MessageModel message,
  ) async {
    return firestore
        .collection('groups')
        .doc(message.groupId)
        .collection('messages')
        .add(message.toMap());
  }

  group('sendMessage', () {
    test('should message successfully when the call is successful', () async {
      final message = MessageModel.empty().copyWith(
        id: '1',
        message: 'Message 1',
      );

      //greate group for [remotedatasource.sendMessage] to work
      await firestore
          .collection('groups')
          .doc(message.groupId)
          .set(GroupModel.empty().copyWith(id: message.groupId).toMap());

      await remoteDatasource.sendMessage(message);

      final messageDoc = await firestore
          .collection('groups')
          .doc(message.groupId)
          .collection('messages')
          .get();

      expect(messageDoc.docs.length, equals(1));

      expect(messageDoc.docs.first.data()['message'], equals(message.message));
    });
  });

  group('getGroups', () {
    test('should return a stream of groups when the call is success', () {
      final expectedGroups = [
        GroupModel.empty().copyWith(
          id: '1',
          courseId: '1',
          name: 'Group 1',
        ),
        GroupModel.empty().copyWith(
          id: '2',
          courseId: '2',
          name: 'Group 2',
        ),
      ];

      //create a fake collection, document, and query with
      //expected group
      firestore.collection('groups').add(expectedGroups[0].toMap());
      firestore.collection('groups').add(expectedGroups[1].toMap());

      final result = remoteDatasource.getGroups();

      expect(result, emitsInOrder([equals(expectedGroups)]));
    });
    test('should return a stream of empty list when there are no groups', () {
      final result = remoteDatasource.getGroups();

      expect(result, emits(equals(<GroupModel>[])));
    });
  });

  group('joinGroup', () {
    test('should complete successfully when the call is successfull', () async {
      final groupDocRef = await firestore.collection('groups').add({
        'members': <String>[],
      });

      final userDocRef = await firestore.collection('users').add({
        'groups': <String>[],
      });

      final groupId = groupDocRef.id;
      final userId = userDocRef.id;

      await remoteDatasource.joinGroup(groupId: groupId, userId: userId);

      final groupDoc = await firestore.collection('groups').doc(groupId).get();
      final userDoc = await firestore.collection('users').doc(userId).get();

      expect(groupDoc.data()!['members'], contains(userId));
      expect(userDoc.data()!['groups'], contains(groupId));
    });
  });

  group('leaveGroup', () {
    test('should complete successfully when the call is success', () async {
      final groupDocRef = firestore.collection('groups').doc();
      final userDocRef = firestore.collection('users').doc();

      final groupId = groupDocRef.id;
      final userId = userDocRef.id;

      await groupDocRef.set({
        'id': groupId,
        'members': <String>[userId],
      });

      await userDocRef.set({
        'id': userId,
        'groups': [groupId],
      });

      var groupDoc = await firestore.collection('groups').doc(groupId).get();
      var userDoc = await firestore.collection('users').doc(userId).get();
      expect(groupDoc.data()!['members'], contains(userId));
      expect(userDoc.data()!['groups'], contains(groupId));

      await remoteDatasource.leaveGroup(
        groupId: groupId,
        userId: userId,
      );

      groupDoc = await firestore.collection('groups').doc(groupId).get();
      userDoc = await firestore.collection('users').doc(userId).get();
      expect(groupDoc.data()!['members'], isNot(contains(userId)));
      expect(userDoc.data()!['groups'], isNot(contains(groupId)));
    });
  });

  group('getUserById', () {
    test('should return a user when the call is successfull', () async {
      const userId = 'uid';
      final expectedUser = const LocalUserModel.empty().copyWith(
        uid: userId,
      );
      await firestore.collection('users').doc(userId).set(expectedUser.toMap());

      final result = await remoteDatasource.getUserById(userId);

      expect(result, equals(expectedUser));
    });
    test('should throw ServerException when the call is unsuccess', () async {
      const userId = 'enythingwroghere';

      final call = remoteDatasource.getUserById;

      expect(() => call(userId), throwsA(isA<ServerException>()));
    });
  });
}
