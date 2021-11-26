abstract class SocialLoginStates{}

class SocialLoginInitialState extends SocialLoginStates{}

class SocialLoginLoadingState extends SocialLoginStates{}

class SocialLoginSuccessState extends SocialLoginStates{
  late String uId;
  SocialLoginSuccessState(this.uId);
}

class SocialLoginErrorState extends SocialLoginStates{
  final eror;
  SocialLoginErrorState(this.eror);
}
class SocialLoginChangePasswordVisibilityState extends SocialLoginStates{}