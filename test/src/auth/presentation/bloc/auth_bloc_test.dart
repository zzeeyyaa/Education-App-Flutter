import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/auth/data/models/user_model.dart';
import 'package:education_app/src/auth/domain/usecases/forgot_password.dart';
import 'package:education_app/src/auth/domain/usecases/sign_in.dart';
import 'package:education_app/src/auth/domain/usecases/sign_up.dart';
import 'package:education_app/src/auth/domain/usecases/update_user.dart';
import 'package:education_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockForgotPassword extends Mock implements ForgotPassword {}

class MockSignIn extends Mock implements SignIn {}

class MockSignUp extends Mock implements SignUp {}

class MockUpdateUser extends Mock implements UpdateUser {}

void main() {
  late ForgotPassword forgotPassword;
  late SignIn signIn;
  late SignUp signUp;
  late UpdateUser updateUser;
  late AuthBloc authBloc;

  const tSignUpParams = SignUpParams.empty();
  const tSignInParams = SignInParams.empty();
  const tUpdateUserParams = UpdateUserParams.empty();

  setUp(() {
    forgotPassword = MockForgotPassword();
    signIn = MockSignIn();
    signUp = MockSignUp();
    updateUser = MockUpdateUser();
    authBloc = AuthBloc(
      forgotPassword: forgotPassword,
      signIn: signIn,
      signUp: signUp,
      updateUser: updateUser,
    );
  });

  setUpAll(() {
    registerFallbackValue(tSignInParams);
    registerFallbackValue(tSignUpParams);
    registerFallbackValue(tUpdateUserParams);
  });

  tearDown(() => authBloc.close());

  test('initialState should be [AuthInitial]', () {
    expect(authBloc.state, const AuthInitial());
  });

  final tServerFailure = ServerFailure(
    message: 'user-not-found',
    statusCode: 'There is no user record corresponding to this identifier. '
        'The user may have been deleted',
  );

  group('ForgotPasswordEvent', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, ForgotPasswordSent] when [ForgotPasswordEvent]'
      ' is added and succeed',
      build: () {
        when(() => forgotPassword(any()))
            .thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(const ForgotPasswordEvent('email')),
      expect: () => [
        const AuthLoading(),
        const ForgotPasswordSent(),
      ],
      verify: (_) {
        verify(() => forgotPassword('email')).called(1);
        verifyNoMoreInteractions(forgotPassword);
      },
    );
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when [ForgotPasswordEvent] is fail.',
      build: () {
        when(() => forgotPassword(any()))
            .thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(const ForgotPasswordEvent('email')),
      expect: () => [
        const AuthLoading(),
        AuthError(tServerFailure.errorMeesage),
      ],
      verify: (_) {
        verify(() => forgotPassword('email')).called(1);
        verifyNoMoreInteractions(forgotPassword);
      },
    );
  });
  group('SignInEvent', () {
    const tUser = LocalUserModel.empty();
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, SignedIn] when [SignedInEvent] is added'
      ' and SignIn is success',
      build: () {
        when(
          () => signIn(any()),
        ).thenAnswer((_) async => const Right(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        SignInEvent(
          email: tSignInParams.email,
          password: tSignInParams.password,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        const SignedIn(tUser),
      ],
      verify: (_) {
        verify(() => signIn(tSignInParams)).called(1);
        verifyNoMoreInteractions(signIn);
      },
    );
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when SignInEvent is added'
      ' and SignIn is fail',
      build: () {
        when(
          () => signIn(any()),
        ).thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        SignInEvent(
          email: tSignInParams.email,
          password: tSignInParams.password,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        AuthError(tServerFailure.errorMeesage),
      ],
      verify: (_) {
        verify(() => signIn(tSignInParams)).called(1);
        verifyNoMoreInteractions(signIn);
      },
    );
  });
  group('SignUpEvent', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, SignedUp] when [SignUpEvent] is success'
      ' and SignUp is success',
      build: () {
        when(
          () => signUp(any()),
        ).thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        SignUpEvent(
          email: tSignUpParams.email,
          password: tSignUpParams.password,
          fullName: tSignUpParams.fullName,
        ),
      ),
      expect: () => const [
        AuthLoading(),
        SignedUp(),
      ],
      verify: (_) {
        verify(() => signUp(tSignUpParams)).called(1);
        verifyNoMoreInteractions(signUp);
      },
    );
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when [SignUpEvent] is added'
      ' and SignUp is fail',
      build: () {
        when(
          () => signUp(any()),
        ).thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        SignUpEvent(
          email: tSignUpParams.email,
          password: tSignUpParams.password,
          fullName: tSignUpParams.fullName,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        AuthError(tServerFailure.errorMeesage),
      ],
      verify: (bloc) {
        verify(() => signUp(tSignUpParams)).called(1);
        verifyNoMoreInteractions(signUp);
      },
    );
  });
  group('UpdateUserEvent', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, UserUpdated] when UpdateUserEvent is added '
      'and UpdateUser is success',
      build: () {
        when(() => updateUser(any()))
            .thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        UpdateUserEvent(
          action: tUpdateUserParams.action,
          userData: tUpdateUserParams.userData,
        ),
      ),
      expect: () => const [
        AuthLoading(),
        UserUpdated(),
      ],
      verify: (bloc) {
        verify(() => updateUser(tUpdateUserParams)).called(1);
        verifyNoMoreInteractions(updateUser);
      },
    );
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when UpdateUserEvent is added '
      ' and UpdateUser is fail.',
      build: () {
        when(() => updateUser(any()))
            .thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        UpdateUserEvent(
          action: tUpdateUserParams.action,
          userData: tUpdateUserParams.userData,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        AuthError(tServerFailure.errorMeesage),
      ],
      verify: (_) {
        verify(() => updateUser(tUpdateUserParams)).called(1);
        verifyNoMoreInteractions(updateUser);
      },
    );
  });
}
