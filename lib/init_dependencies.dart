import 'package:get_it/get_it.dart';
import 'package:neclicensepreperation/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:neclicensepreperation/core/secrets/supabase_secret.dart';
import 'package:neclicensepreperation/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:neclicensepreperation/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:neclicensepreperation/features/auth/domain/auth-repository.dart';
import 'package:neclicensepreperation/features/auth/domain/usecases/user_sign_up.dart';
import 'package:neclicensepreperation/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:neclicensepreperation/features/questions/data/datasources/question_remote_data_source.dart';
import 'package:neclicensepreperation/features/questions/data/repository/question_repo_impl.dart';
import 'package:neclicensepreperation/features/questions/domain/repositories/question_repo.dart';
import 'package:neclicensepreperation/features/questions/domain/usecases/get_all_ai_question.dart';
import 'package:neclicensepreperation/features/questions/domain/usecases/get_all_programming_question.dart';
import 'package:neclicensepreperation/features/questions/domain/usecases/get_toc_question.dart';
import 'package:neclicensepreperation/features/questions/domain/usecases/upload_question.dart';
import 'package:neclicensepreperation/features/questions/presentation/bloc/question_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/domain/usecases/current_user.dart';
import 'features/auth/domain/usecases/user_login.dart';
import 'features/questions/domain/usecases/get_all_questio.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initQuestion();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);
}

void _initAuth() {
  serviceLocator
    // ! core
    ..registerLazySingleton(
      () => AppUserCubit(),
    )
    // DataSource
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator<SupabaseClient>(),
      ),
    )
    //! Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => UserSignUp(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogin(
        serviceLocator(),
      ),
    )

    // Current User getting
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )

    //! Block
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
        // userLogin: serviceLocator(),
        // currentUser: serviceLocator(),
        // appUserCubit: serviceLocator(),
      ),
    );
}

void _initQuestion() {
  // datasource
  serviceLocator
    ..registerFactory<QuestionRemoteDataSource>(
      () => QuestionRemoteDataSourceImpl(
        supabaseClient: serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<QuestionRepository>(
      () => QuestionRepositoryImpl(
        serviceLocator(),
      ),
    )
    // Usecase
    ..registerFactory(
      () => UploadQuestion(
        questionRepository: serviceLocator(),
      ),
    )
    // get all questions
    ..registerFactory(
      () => GetAllQuestions(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllProgrammingQuestions(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllTocQuestion(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllAiQuestion(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => QuestionBloc(
          uploadQuestion: serviceLocator(),
          getAllQuestion: serviceLocator(),
          get_programming_questions: serviceLocator(),
          getAllTocQuestion: serviceLocator(),
          getAllAiQuestion: serviceLocator()

          // getdsa: serviceLocator(),
          ),
    );
  ;
}
