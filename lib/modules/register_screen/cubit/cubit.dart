

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/users_model.dart';
import 'package:social_app/modules/register_screen/cubit/state.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates>{

  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context)=>BlocProvider.of(context);


  void UserRegister({
    required String email,
    required String password,
    required String name,
    required String phone
  }){
    emit(SocialRegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
    ).then((value){
      CreateUser(
        uId: value.user!.uid,
        email: email,
        name: name,
        phone: phone,
      );
    }).catchError((error){
      emit(SocialRegisterErrorState(error.toString()));
    });
  }

  void CreateUser({
    required String email,
    required String name,
    required String phone,
    required String uId,
})
  {
    UsersModel model= UsersModel(
        email: email,
        name: name,
        phone: phone,
        uId: uId,
        image: 'https://image.freepik.com/free-photo/portrait-handsome-young-man-makes-okay-gesture-demonstrates-agreement-likes-idea-smiles-happily-wears-optical-glasses-yellow-hat-t-shirt-models-indoor-its-fine-thank-you-hand-sign_273609-30676.jpg',
        cover:'https://image.freepik.com/free-photo/cheerful-male-gives-nice-offer-advertises-new-product-sale-stands-torn-paper-hole-has-positive-expression_273609-38452.jpg',
        bio: 'bio ...',
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.ToMap())
        .then((value){
      emit(SocialCreateUserSuccessState());
    }).catchError((error){
      emit(SocialCreateUserErrorState(error.toString()));
    });
  }

  bool ispassword=true;
  IconData suffix=Icons.visibility_outlined;

  void ChangePasswordVisibility(){
    ispassword= !ispassword;
    suffix= ispassword? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(RegisterChangePasswordVisibilityState());
  }
}