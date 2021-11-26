
abstract class SocialStates{}

class SocialInitialState extends SocialStates{}

//Get User
class SocialGetUserLoadingState extends SocialStates{}
class SocialGetUserSuccessState extends SocialStates{}
class SocialGetUserErrorState extends SocialStates{
  String error;
  SocialGetUserErrorState(this.error);
}

//Get Post


class SocialGetAllUsersLoadingState extends SocialStates{}
class SocialGetAllUsersSuccessState extends SocialStates{}
class SocialGetAllUsersErrorState extends SocialStates{
  String error;
  SocialGetAllUsersErrorState(this.error);
}

//---------------like Post-----------------
class SocialLikePostSuccessState extends SocialStates{}
class SocialLikePostErrorState extends SocialStates{
  String error;
  SocialLikePostErrorState(this.error);
}

class SocialGetAllPostsSuccessState extends SocialStates{}

//-----------------comments--------------
class SocialGetCommentPostLoadingState extends SocialStates{}
class SocialGetCommentPostSuccessState extends SocialStates{}
class SocialGetCommentPostErrorState extends SocialStates{
  String error;
  SocialGetCommentPostErrorState(this.error);
}

class SocialGetNumCommentPostSuccessState extends SocialStates{}
class SocialGetNumCommentPostErrorState extends SocialStates{
  String error;
  SocialGetNumCommentPostErrorState(this.error);
}

class SocialCommentPostLoadingState extends SocialStates{}
class SocialCommentPostSuccessState extends SocialStates{}
class SocialCommentPostErrorState extends SocialStates{
  String error;
  SocialCommentPostErrorState(this.error);
}

//------------------bottom navigation---------------------
class SocialChangeBottomNavState extends SocialStates{}

//-------------new Post--------------
class SocialAddNewPostState extends SocialStates{}

//---------------change profil image----------
class SocialchangeImageSuccessState extends SocialStates{}
class SocialchangeImageErrorState extends SocialStates{}

//--------------change cover image-------------
class SocialchangeCoverImageSuccessState extends SocialStates{}
class SocialchangeCoverImageErrorState extends SocialStates{}

//---------------------upload profil image--------------
class SocialUploadProfilImageSuccessState extends SocialStates{}
class SocialUploadProfilImageErrorState extends SocialStates{}

class SocialUploadCoverImageSuccessState extends SocialStates{}
class SocialUploadCoverImageErrorState extends SocialStates{}

class SocialUpdateUserLoadingState extends SocialStates{}
class SocialUpdateUserErrorState extends SocialStates{}

//--------------------post-----------------

class SocialGetPostLoadingState extends SocialStates{}
class SocialGetPostSuccessState extends SocialStates{}
class SocialGetPostErrorState extends SocialStates{
  String error;
  SocialGetPostErrorState(this.error);
}

class SocialAddPostLoadingState extends SocialStates{}
class SocialAddPostSuccessState extends SocialStates{}
class SocialAddPostErrorState extends SocialStates{}

class SocialUploadPostImageSuccessState extends SocialStates{}
class SocialUploadPostImageErrorState extends SocialStates{}

class SocialRemovePostImageState extends SocialStates{}

//----------chats--------------------
class SocialSendMessagesLoadingState extends SocialStates{}
class SocialSendMessagesSuccessState extends SocialStates{}
class SocialSendMessagesErrorState extends SocialStates{}

class SocialGetMessagesSuccessState extends SocialStates{}

class SocialUploadChatImageSuccessState extends SocialStates{}
class SocialUploadChatImageErrorState extends SocialStates{}

