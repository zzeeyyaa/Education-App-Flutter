part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initAuth();
  await _initOnBoarding();
  await _initCourse();
  await _initVideo();
  await _initMaterial();
  await _initExam();
  await _initNotifications();
  await _initChat();
}

Future<void> _initAuth() async {
  sl
    ..registerFactory(
      () => AuthBloc(
        forgotPassword: sl(),
        signIn: sl(),
        signUp: sl(),
        updateUser: sl(),
      ),
    )
    ..registerLazySingleton(() => ForgotPassword(sl()))
    ..registerLazySingleton(() => SignIn(sl()))
    ..registerLazySingleton(() => SignUp(sl()))
    ..registerLazySingleton(() => UpdateUser(sl()))
    ..registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()))
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        authClient: sl(),
        cloudStoreClient: sl(),
        dbClient: sl(),
      ),
    )
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseStorage.instance);
}

Future<void> _initOnBoarding() async {
  final prefs = await SharedPreferences.getInstance();
  //Future --> onboarding
  //Bussiness logic
  sl
    ..registerFactory(
      () => OnBoardingCubit(
        cacheFirstTimer: sl(),
        checkIfUserIsFirstTimer: sl(),
      ),
    )
    ..registerLazySingleton(() => CacheFirstTimer(sl()))
    ..registerLazySingleton(() => CheckIfUserIsFirstTimer(sl()))
    //go to their dependency, but not interface, so have to pass to
    //implementation
    ..registerLazySingleton<OnBooardingRepo>(() => OnBoardingRepoImpl(sl()))
    ..registerLazySingleton<OnBoardingLocalDataSource>(
      () => OnBoardingLocalDataSrcImpl(sl()),
    )
    ..registerLazySingleton(() => prefs);
}

Future<void> _initCourse() async {
  sl
    ..registerFactory(() => CourseCubit(addCourse: sl(), getCourse: sl()))
    ..registerLazySingleton(() => AddCourse(sl()))
    ..registerLazySingleton(() => GetCourse(sl()))
    ..registerLazySingleton<CourseRepo>(() => CourseRepoImpl(sl()))
    ..registerLazySingleton<CourseRemoteDatasource>(
      () => CourseRemoteDatasourceImpl(
        firestore: sl(),
        storage: sl(),
        auth: sl(),
      ),
    );
}

Future<void> _initVideo() async {
  sl
    ..registerFactory(() => VideoCubit(addVideo: sl(), getVideos: sl()))
    ..registerLazySingleton(() => AddVideo(sl()))
    ..registerLazySingleton(() => GetVideos(sl()))
    ..registerLazySingleton<VideoRepo>(() => VideoRepoImpl(sl()))
    ..registerLazySingleton<VideoRemoteDatasource>(
      () => VideoRemoteDatasourceImpl(
        firestore: sl(),
        storage: sl(),
        auth: sl(),
      ),
    );
}

Future<void> _initMaterial() async {
  sl
    ..registerFactory(
      () => MaterialCubit(addMaterial: sl(), getMaterials: sl()),
    )
    ..registerLazySingleton(() => AddMaterial(sl()))
    ..registerLazySingleton(() => GetMaterials(sl()))
    ..registerLazySingleton<MaterialRepo>(() => MaterialRepoImpl(sl()))
    ..registerLazySingleton<MaterialRemoteDatasource>(
      () => MaterialRemoteDatasourceImpl(
        auth: sl(),
        storage: sl(),
        firestore: sl(),
      ),
    )
    ..registerFactory(() => ResourceController(storage: sl(), prefs: sl()));
}

Future<void> _initExam() async {
  sl
    ..registerFactory(
      () => ExamCubit(
        getExams: sl(),
        getExamQuestions: sl(),
        uploadExam: sl(),
        updateExam: sl(),
        submitExam: sl(),
        getUserExams: sl(),
        getUserCourseExams: sl(),
      ),
    )
    ..registerLazySingleton(() => GetExams(sl()))
    ..registerLazySingleton(() => GetExamQuestions(sl()))
    ..registerLazySingleton(() => UploadExam(sl()))
    ..registerLazySingleton(() => UpdateExam(sl()))
    ..registerLazySingleton(() => SubmitExam(sl()))
    ..registerLazySingleton(() => GetUserExams(sl()))
    ..registerLazySingleton(() => GetUserCourseExams(sl()))
    ..registerLazySingleton<ExamRepo>(() => ExamRepoImpl(sl()))
    ..registerLazySingleton<ExamRemoteDatasource>(
      () => ExamRemoteDatasourceImpl(auth: sl(), firestore: sl()),
    );
}

Future<void> _initNotifications() async {
  sl
    ..registerFactory(
      () => NotificationCubit(
        clear: sl(),
        clearAll: sl(),
        getNotifications: sl(),
        markAsRead: sl(),
        sendNotification: sl(),
      ),
    )
    ..registerLazySingleton(() => Clear(sl()))
    ..registerLazySingleton(() => ClearAll(sl()))
    ..registerLazySingleton(() => GetNotifications(sl()))
    ..registerLazySingleton(() => MarkAsRead(sl()))
    ..registerLazySingleton(() => SendNotification(sl()))
    ..registerLazySingleton<NotificationRepo>(() => NotificationRepoImpl(sl()))
    ..registerLazySingleton<NotificationRemoteDatasource>(
      () => NotificationRemoteDatasourceImpl(firestore: sl(), auth: sl()),
    );
}

Future<void> _initChat() async {
  sl
    ..registerFactory(
      () => ChatCubit(
        getGroups: sl(),
        getMessages: sl(),
        getUserById: sl(),
        joinGroup: sl(),
        leaveGroup: sl(),
        sendMessage: sl(),
      ),
    )
    ..registerLazySingleton(() => GetGroups(sl()))
    ..registerLazySingleton(() => GetMessages(sl()))
    ..registerLazySingleton(() => GetUserById(sl()))
    ..registerLazySingleton(() => JoinGroup(sl()))
    ..registerLazySingleton(() => LeaveGroup(sl()))
    ..registerLazySingleton(() => SendMessage(sl()))
    ..registerLazySingleton<ChatRepo>(() => ChatRepoImpl(sl()))
    ..registerLazySingleton<ChatRemoteDatasource>(
      () => ChatRemoteDatasourceImpl(
        firestore: sl(),
        auth: sl(),
      ),
    );
}
