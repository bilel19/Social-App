
abstract class SocialRegisterStates{}

class SocialRegisterInitialState extends SocialRegisterStates{}

class SocialRegisterLoadingState extends SocialRegisterStates{}

class SocialRegisterSuccessState extends SocialRegisterStates{}

class SocialRegisterErrorState extends SocialRegisterStates{
  final eror;
  SocialRegisterErrorState(this.eror);
}

class SocialCreateUserSuccessState extends SocialRegisterStates{}

class SocialCreateUserErrorState extends SocialRegisterStates{
  final eror;
  SocialCreateUserErrorState(this.eror);
}

class RegisterChangePasswordVisibilityState extends SocialRegisterStates{}