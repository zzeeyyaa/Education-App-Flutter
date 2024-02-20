import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/utils/datasource_utils.dart';
import 'package:education_app/src/course/features/materials/data/models/resource_model.dart';
import 'package:education_app/src/course/features/materials/domain/entities/resource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class MaterialRemoteDatasource {
  const MaterialRemoteDatasource();

  Future<List<Resource>> getMaterials(String courseId);

  Future<void> adddMaterial(Resource resource);
}

class MaterialRemoteDatasourceImpl implements MaterialRemoteDatasource {
  const MaterialRemoteDatasourceImpl({
    required FirebaseAuth auth,
    required FirebaseStorage storage,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _storage = storage,
        _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseStorage _storage;
  final FirebaseFirestore _firestore;

  @override
  Future<void> adddMaterial(Resource material) async {
    try {
      await DataSourceUtils.authorizeUser(_auth);
      final materialRef = _firestore
          .collection('courses')
          .doc(material.courseId)
          .collection('materials')
          .doc();
      var materialModel =
          (material as ResourceModel).copyWith(id: materialRef.id);
      if (materialModel.isFile) {
        final materialFileRef = _storage.ref().child(
            'courses/${materialModel.courseId}/materials/${materialModel.id}/material');
        await materialFileRef
            .putFile(File(materialModel.fileURL))
            .then((value) async {
          final url = await value.ref.getDownloadURL();
          materialModel = materialModel.copyWith(fileURL: url);
        });
      }
      await materialRef.set(materialModel.toMap());
      await _firestore.collection('courses').doc(material.courseId).update({
        'numberOfMaterials': FieldValue.increment(1),
      });
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown Error',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<List<Resource>> getMaterials(String courseId) async {
    try {
      await DataSourceUtils.authorizeUser(_auth);
      final materialRef = _firestore
          .collection('courses')
          .doc(courseId)
          .collection('materials');
      final materials = await materialRef.get();
      return materials.docs
          .map((e) => ResourceModel.fromMap(e.data()))
          .toList();
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown Error',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }
}
