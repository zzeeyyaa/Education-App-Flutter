import 'package:education_app/core/enums/update_user.dart';
import 'package:education_app/src/auth/data/datasources/auth_remote_datasource.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {
  late FakeFirebaseFirestore cloudStoreClient;
  late MockFirebaseAuth authClient;
  late MockFirebaseStorage dbClient;
  late AuthRemoteDataSource dataSource;

  setUp(() async {
    cloudStoreClient = FakeFirebaseFirestore();

    // Mock sign in with Google.
    final googleSignIn = MockGoogleSignIn();
    final signInAccount = await googleSignIn.signIn();
    final googleAuth = await signInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Sign in.
    final mockUser = MockUser(
      // isAnonymous: false,
      uid: 'someuid',
      email: 'bob@somedomain.com',
      displayName: 'Bob',
    );
    // final auth = MockFirebaseAuth(mockUser: user);
    authClient = MockFirebaseAuth(mockUser: mockUser);
    final result = await authClient.signInWithCredential(credential);
    final user = result.user;
    dbClient = MockFirebaseStorage();
    dataSource = AuthRemoteDataSourceImpl(
      authClient: authClient,
      cloudStoreClient: cloudStoreClient,
      dbClient: dbClient,
    );
    print(mockUser.displayName);
  });

  const tPassword = 'Test password';
  const tFullName = 'Test fullName';
  const tEmail = 'testemail@mial.com';

  test('signUp', () async {
    //act
    await dataSource.signUp(
      email: tEmail,
      fullName: tFullName,
      password: tPassword,
    );
    //asserting
    //expect user was created in firestore and authclient
    //also has this user
    expect(authClient.currentUser, isNotNull);
    expect(authClient.currentUser!.displayName, tFullName);

    final user = await cloudStoreClient
        .collection('users')
        .doc(authClient.currentUser!.uid)
        .get();
    expect(user.exists, isTrue);
  });

  test('signIn', () async {
    await dataSource.signUp(
      email: 'newEmail@mail.com',
      fullName: tFullName,
      password: tPassword,
    );
    await authClient.signOut();
    await dataSource.signIn(
      email: 'newEmail@mail.com',
      password: tPassword,
    );

    expect(authClient.currentUser, isNotNull);
    expect(authClient.currentUser!.email, equals('newEmail#mail.com'));
  });

  group('updateUser', () {
    test('displayName', () async {
      await dataSource.signUp(
        email: tEmail,
        fullName: tFullName,
        password: tPassword,
      );
      await dataSource.updateUser(
        action: UpdateUserAction.displayName,
        userData: 'new name',
      );

      expect(authClient.currentUser!.displayName, 'new name');
    });
    test('email', () async {
      await dataSource.signUp(
        email: tEmail,
        fullName: tFullName,
        password: tPassword,
      );
      await dataSource.updateUser(
        action: UpdateUserAction.email,
        userData: 'newEmail@mail.com',
      );

      expect(authClient.currentUser!.email, 'newEmail@mail.com');
    });
    test('', () async {});
  });
}
