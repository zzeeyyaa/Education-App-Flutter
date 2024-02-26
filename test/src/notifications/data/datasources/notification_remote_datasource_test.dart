import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/auth/data/models/user_model.dart';
import 'package:education_app/src/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:education_app/src/notifications/data/models/notification_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {
  late NotificationRemoteDatasource remoteDatasource;
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

    remoteDatasource = NotificationRemoteDatasourceImpl(
      firestore: firestore,
      auth: auth,
    );
  });

  Future<QuerySnapshot<DataMap>> getNotifications() async => firestore
      .collection('users')
      .doc(auth.currentUser!.uid)
      .collection('notifications')
      .get();
  Future<DocumentReference> addNotification(
    NotificationModel notification,
  ) async {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('notifications')
        .add(notification.toMap());
  }

  group('clear', () {
    test('shld delete th specified [Notification] from the database', () async {
      // create ntifications sub-collection fo current user
      final firstDocRef = await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('notifications')
          .add(NotificationModel.empty().toMap());
      //add a ntification to the sub-olection
      final notification = NotificationModel.empty().copyWith(id: '1');
      final docRef = await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('notifications')
          .add(notification.toMap());

      final collection = await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('notifications')
          .get();

      //assert that the notiifcation was added
      expect(collection.docs, hasLength(2));

      //act
      await remoteDatasource.clear(docRef.id);
      final secondNotificationDoc = await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('notifications')
          .doc(docRef.id)
          .get();
      final firstNotificationDoc = await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('notifications')
          .doc(firstDocRef.id)
          .get();

      //asseert that the ntification was deleted
      expect(secondNotificationDoc.exists, isFalse);
      expect(firstNotificationDoc.exists, isTrue);
    });
  });

  group('sendNotification', () {
    test('should upload a [Notification] to the specified user', () async {
      //arrage
      const secondUID = 'second_uid';

      for (var i = 0; i < 2; i++) {
        await firestore
            .collection('users')
            .doc(i == 0 ? auth.currentUser!.uid : secondUID)
            .set(
              const LocalUserModel.empty()
                  .copyWith(
                    uid: i == 0 ? auth.currentUser!.uid : secondUID,
                    email: i == 0 ? auth.currentUser!.email : 'second email',
                    fullName:
                        i == 0 ? auth.currentUser!.displayName : 'second name',
                  )
                  .toMap(),
            );
      }
      final notification = NotificationModel.empty().copyWith(
        id: '1',
        title: 'Test unique title, cannot be duplicated',
        body: 'Test',
      );

      //act
      await remoteDatasource.sendNotification(notification);

      //assert
      final userNotificationsRef = await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('notifications')
          .get();

      final user2NotificationsRef = await firestore
          .collection('users')
          .doc(secondUID)
          .collection('notifications')
          .get();

      expect(userNotificationsRef.docs, hasLength(1));
      expect(
        userNotificationsRef.docs.first.data()['title'],
        equals(notification.title),
      );

      expect(user2NotificationsRef.docs, hasLength(1));
      expect(
        user2NotificationsRef.docs.first.data()['title'],
        equals(notification.title),
      );
    });
  });

  group('clearAll', () {
    test(
        'should delete every notification in the '
        "current user's sub-collections", () async {
      //create notifications sub-collection for current user
      for (var i = 0; i < 5; i++) {
        await addNotification(
          NotificationModel.empty().copyWith(id: i.toString()),
        );
      }

      final collection = await getNotifications();

      //assert that the notifications were added
      expect(collection.docs, hasLength(5));

      //act
      await remoteDatasource.clearAll();

      final notificationDocs = await getNotifications();

      //ASSERT that the notificaitons were delete
      expect(notificationDocs.docs, isEmpty);
    });
  });

  group('getNotifications', () {
    test(
        'should return a [Stream<List<Notification>>] when the call is success',
        () async {
      //arrange
      final userId = auth.currentUser!.uid;

      await firestore
          .collection('users')
          .doc(userId)
          .set(const LocalUserModel.empty().copyWith(uid: userId).toMap());

      final expectedNotifications = [
        NotificationModel.empty(),
        NotificationModel.empty().copyWith(
          id: '1',
          sentAt: DateTime.now().add(
            const Duration(seconds: 50),
          ),
        ),
      ];

      for (final notification in expectedNotifications) {
        await addNotification(notification);
      }

      //act
      final result = remoteDatasource.getNotifications();

      //assert
      expect(result, emitsInOrder([equals(expectedNotifications.reversed)]));
    });
  });

  group('markAsRead', () {
    test('should mark the specified notification as read', () async {
      var tId = '';

      //create notifications sub-collection for current user
      for (var i = 0; i < 5; i++) {
        final docRef = await addNotification(
          NotificationModel.empty().copyWith(
            id: i.toString(),
            seen: i.isEven,
          ),
        );
        if (i == 1) {
          tId = docRef.id;
        }
      }

      final collection = await getNotifications();
      //assert that the notifications were added
      expect(collection.docs, hasLength(5));

      //act
      await remoteDatasource.markAsRead(tId);
      final notificationDoc = await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('notifications')
          .doc(tId)
          .get();

      //assert that the notification was marked as read
      expect(notificationDoc.data()!['seen'], isTrue);
    });
  });

  group('sendNotification', () {
    test(
      'should upload a [Notification] to the specified user',
      () async {
        // Arrange
        const secondUID = 'second_uid';
        for (var i = 0; i < 2; i++) {
          await firestore
              .collection('users')
              .doc(i == 0 ? auth.currentUser!.uid : secondUID)
              .set(
                const LocalUserModel.empty()
                    .copyWith(
                      uid: i == 0 ? auth.currentUser!.uid : secondUID,
                      email: i == 0 ? auth.currentUser!.email : 'second email',
                      fullName: i == 0
                          ? auth.currentUser!.displayName
                          : 'second name',
                    )
                    .toMap(),
              );
        }

        final notification = NotificationModel.empty().copyWith(
          id: '1',
          title: 'Test unique title, cannot be duplicated',
          body: 'Test',
        );

        // Act
        await remoteDatasource.sendNotification(notification);

        // Assert
        final user1NotificationsRef = await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .collection('notifications')
            .get();

        final user2NotificationsRef = await firestore
            .collection('users')
            .doc(secondUID)
            .collection('notifications')
            .get();

        expect(user1NotificationsRef.docs, hasLength(1));
        expect(
          user1NotificationsRef.docs.first.data()['title'],
          equals(notification.title),
        );
        expect(user2NotificationsRef.docs, hasLength(1));
        expect(
          user1NotificationsRef.docs.first.data()['title'],
          equals(notification.title),
        );
      },
    );
  });
}
