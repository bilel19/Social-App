
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login_screen/cubit/state.dart';

class SocialLoginCubit extends Cubit<SocialLoginStates> {
  SocialLoginCubit() : super(SocialLoginInitialState());

  static SocialLoginCubit get(context) => BlocProvider.of(context);

  //SocialLoginModel? loginModel;

  void UserLogin({
    required String email,
    required String password,
  }) {
    emit(SocialLoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
    ).then((value){
      print(value.user!.email);
      print(value.user!.uid);
      emit(SocialLoginSuccessState(value.user!.uid));
    }).catchError((error){
      emit(SocialLoginErrorState(error.toString()));
    });
  }

  bool ispassword = true;
  IconData suffix = Icons.visibility_outlined;

  void ChangePasswordVisibility() {
    ispassword = !ispassword;
    suffix =
    ispassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(SocialLoginChangePasswordVisibilityState());
  }
}