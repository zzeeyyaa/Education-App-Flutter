part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initAuth();
  await _initOnBoarding();
  await _initCourse();
  await _initVideo();
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
