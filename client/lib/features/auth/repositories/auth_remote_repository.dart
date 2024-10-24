// ignore_for_file: functional_ref
import 'dart:convert';
import 'package:client/core/constants/server_constants.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(AuthRemoteRepositoryRef ref){
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  // Signup function
  Future<Either<AppFailure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response =
          await http.post(Uri.parse("${ServerConstants.serverUrl}/auth/signup"),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(
                {
                  "name": name,
                  "email": email,
                  "password": password,
                },
              ));
      final responseBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 201) {
        // handle error
        return Left(AppFailure(responseBodyMap['detail']));
      }
      return Right(UserModel.fromMap(responseBodyMap));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  // Login function
  Future<Either<AppFailure, UserModel>> login(
      {required String email, required String password}) async {
    try {
      final response = await http.post(
          Uri.parse("${ServerConstants.serverUrl}/auth/login"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"email": email, "password": password}));

      final responseBodyMap = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        return Left(AppFailure(responseBodyMap['detail']));
      }
      return Right(UserModel.fromMap(responseBodyMap['user']).copyWith(token: responseBodyMap['token']));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure , UserModel>> getCurrentUserData({
    required String token
  }) async {
    try {
      final response = await http.get(Uri.parse("${ServerConstants.serverUrl}/auth/"),headers: {
      "Content-Type": "application/json",
      "x-auth-token": token
    });
    final responseBodyMap = jsonDecode(response.body) as Map<String , dynamic>;

    if(response.statusCode!= 200){
      return Left(AppFailure(responseBodyMap['detail']));
    }
    return Right(UserModel.fromMap(responseBodyMap).copyWith(token: token));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
