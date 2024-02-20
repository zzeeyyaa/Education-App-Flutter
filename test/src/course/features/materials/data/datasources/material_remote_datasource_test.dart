import 'dart:io';

import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/src/course/data/models/course_model.dart';
import 'package:education_app/src/course/features/materials/data/datasources/material_remote_datasource.dart';
import 'package:education_app/src/course/features/materials/data/models/resource_model.dart';
import 'package:education_app/src/course/features/materials/domain/entities/resource.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {
  late MaterialRemoteDatasource remoteDatasource;
  late FakeFirebaseFirestore firestore;
  late MockFirebaseAuth auth;
  late MockFirebaseStorage storage;

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
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    auth = MockFirebaseAuth(mockUser: user);
    await auth.signInWithCredential(credential);
    storage = MockFirebaseStorage();

    remoteDatasource = MaterialRemoteDatasourceImpl(
      auth: auth,
      storage: storage,
      firestore: firestore,
    );
  });

  final tResourceModel = ResourceModel.empty();

  group('addMaaterial', () {
    setUp(() async {
      await firestore
          .collection('courses')
          .doc(tResourceModel.courseId)
          .set(CourseModel.empty().toMap());
    });
    test('should add the povided [Material] to the firestore', () async {
      await remoteDatasource.adddMaterial(tResourceModel);

      final collectionRef = await firestore
          .collection('courses')
          .doc(tResourceModel.courseId)
          .collection('materials')
          .get();

      expect(collectionRef.docs.length, equals(1));
    });
    test('should add the provided [Material] to the storage', () async {
      final materialFile = File('assets/images/auth_gradient_backkground.png');
      final material = tResourceModel.copyWith(
        fileURL: materialFile.path,
      );

      await remoteDatasource.adddMaterial(material);

      final collectionRef = await firestore
          .collection('courses')
          .doc(tResourceModel.courseId)
          .collection('materials')
          .get();

      expect(collectionRef.docs.length, equals(1));

      final savedMaterial = collectionRef.docs.first;

      final storageMaterialURL = await storage
          .ref()
          .child(
            'courses/${tResourceModel.courseId}/materials/${savedMaterial['id']}/material',
          )
          .getDownloadURL();

      expect(savedMaterial['fileURL'], equals(storageMaterialURL));
    });
    test('should throw [SserverException] when error happened', () async {
      final call = remoteDatasource.adddMaterial;
      expect(() => call(Resource.empty()), throwsA(isA<ServerException>()));
    });
  });

  group('getMaterials', () {
    test('should return a list of [Maaterial] from the firestore', () async {
      await firestore
          .collection('courses')
          .doc(tResourceModel.courseId)
          .set(CourseModel.empty().toMap());
      await remoteDatasource.adddMaterial(tResourceModel);

      final result =
          await remoteDatasource.getMaterials(tResourceModel.courseId);

      expect(result, isA<List<Resource>>());
      expect(result.length, equals(1));
      expect(result.first.description, equals(tResourceModel.description));
    });
    test('should return an empty list when there is an error', () async {
      final result =
          await remoteDatasource.getMaterials(tResourceModel.courseId);

      expect(result, isA<List<Resource>>());
      expect(result.isEmpty, isTrue);
    });
  });
}
