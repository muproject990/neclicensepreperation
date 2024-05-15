import 'package:neclicensepreperation/core/error/exception.dart';
import 'package:neclicensepreperation/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<String> loginWithEmailPassword({
    // required String name,
    required String email,
    required String password,
  });
}

// create a generic class which will implement this above definitions

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl(this.supabaseClient);

// !loginWithEmailPassword
  @override
  Future<String> loginWithEmailPassword({
    required String email,
    required String password,
  }) {
    // TODO: implement loginWithEmailPassword
    throw UnimplementedError();
  }

// !signUpWithEmailPassword
  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      print("i am here at authremote_Datasourse");
      final response = await supabaseClient.auth.signUp(
          password: password,
          email: email,
          //! data proprty to store additional data of user
          data: {
            // key  value
            'name': name,
          });

      print("i am here at authremote_Datasourse");

      if (response.user == null) {
        throw ServerException(message: "User is nulll");
      }
      print(response.user!.toJson());
      return UserModel.fromJson(
        response.user!.toJson(),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
