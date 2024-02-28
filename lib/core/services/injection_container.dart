import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/src/auth/data/datasources/auth_remote_datasource.dart';
import 'package:education_app/src/auth/data/repos/auth_repo_impl.dart';
import 'package:education_app/src/auth/domain/repos/auth_repo.dart';
import 'package:education_app/src/auth/domain/usecases/forgot_password.dart';
import 'package:education_app/src/auth/domain/usecases/sign_in.dart';
import 'package:education_app/src/auth/domain/usecases/sign_up.dart';
import 'package:education_app/src/auth/domain/usecases/update_user.dart';
import 'package:education_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:education_app/src/course/data/datasources/course_remote_datasource.dart';
import 'package:education_app/src/course/data/repos/course_repo_impl.dart';
import 'package:education_app/src/course/domain/repos/course_repo.dart';
import 'package:education_app/src/course/domain/usecases/add_course.dart';
import 'package:education_app/src/course/domain/usecases/get_courses.dart';
import 'package:education_app/src/course/features/exams/data/datasources/exam_remote_datasource.dart';
import 'package:education_app/src/course/features/exams/data/repos/exam_repo_impl.dart';
import 'package:education_app/src/course/features/exams/domain/repos/exam_repo.dart';
import 'package:education_app/src/course/features/exams/domain/usecases/get_exam_questions.dart';
import 'package:education_app/src/course/features/exams/domain/usecases/get_exams.dart';
import 'package:education_app/src/course/features/exams/domain/usecases/get_user_course_exams.dart';
import 'package:education_app/src/course/features/exams/domain/usecases/get_user_exams.dart';
import 'package:education_app/src/course/features/exams/domain/usecases/submit_exam.dart';
import 'package:education_app/src/course/features/exams/domain/usecases/update_exam.dart';
import 'package:education_app/src/course/features/exams/domain/usecases/upload_exam.dart';
import 'package:education_app/src/course/features/exams/presentation/cubit/exam_cubit.dart';
import 'package:education_app/src/course/features/materials/data/datasources/material_remote_datasource.dart';
import 'package:education_app/src/course/features/materials/data/repos/material_repo_impl.dart';
import 'package:education_app/src/course/features/materials/domain/repos/material_repo.dart';
import 'package:education_app/src/course/features/materials/domain/usecases/add_material.dart';
import 'package:education_app/src/course/features/materials/domain/usecases/get_materials.dart';
import 'package:education_app/src/course/features/materials/persentation/cubit/material_cubit.dart';
import 'package:education_app/src/course/features/materials/persentation/providers/resource_controller.dart';
import 'package:education_app/src/course/features/videos/data/datasources/video_remote_datasource.dart';
import 'package:education_app/src/course/features/videos/data/repos/video_repo_impl.dart';
import 'package:education_app/src/course/features/videos/domain/repos/video_repo.dart';
import 'package:education_app/src/course/features/videos/domain/usecases/add_video.dart';
import 'package:education_app/src/course/features/videos/domain/usecases/get_videos.dart';
import 'package:education_app/src/course/features/videos/presentation/cubit/video_cubit.dart';
import 'package:education_app/src/course/persentation/cubit/course_cubit.dart';
import 'package:education_app/src/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:education_app/src/notifications/data/repos/notification_repo_impl.dart';
import 'package:education_app/src/notifications/domain/repos/notification_repo.dart';
import 'package:education_app/src/notifications/domain/usecases/clear.dart';
import 'package:education_app/src/notifications/domain/usecases/clear_all.dart';
import 'package:education_app/src/notifications/domain/usecases/get_notifications.dart';
import 'package:education_app/src/notifications/domain/usecases/mark_as_read.dart';
import 'package:education_app/src/notifications/domain/usecases/send_notification.dart';
import 'package:education_app/src/notifications/presentation/cubit/notification_cubit.dart';
import 'package:education_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:education_app/src/on_boarding/data/repos/on_boarding_repo_impl.dart';
import 'package:education_app/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:education_app/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:education_app/src/on_boarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:education_app/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'injection_container.main.dart';
