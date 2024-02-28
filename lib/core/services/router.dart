import 'package:education_app/core/common/views/page_under_construction.dart';
import 'package:education_app/core/extensions/context_extension.dart';
import 'package:education_app/core/services/injection_container.dart';
import 'package:education_app/src/auth/data/models/user_model.dart';
import 'package:education_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:education_app/src/auth/presentation/views/sign_in_screen.dart';
import 'package:education_app/src/auth/presentation/views/sign_up_screen.dart';
import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:education_app/src/course/features/materials/persentation/cubit/material_cubit.dart';
import 'package:education_app/src/course/features/materials/persentation/views/add_material_view.dart';
import 'package:education_app/src/course/features/videos/presentation/cubit/video_cubit.dart';
import 'package:education_app/src/course/features/videos/presentation/views/add_video_view.dart';
import 'package:education_app/src/course/persentation/cubit/course_cubit.dart';
import 'package:education_app/src/course/persentation/views/course_details_screen.dart';
import 'package:education_app/src/dashboard/presentation/views/dashboard.dart';
import 'package:education_app/src/notifications/presentation/cubit/notification_cubit.dart';
import 'package:education_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:education_app/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:education_app/src/on_boarding/presentation/views/on_boarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as fui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'router.main.dart';
