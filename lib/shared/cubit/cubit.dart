import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/comments_model.dart';
import 'package:social_app/models/massages_model.dart';
import 'package:social_app/models/posts_model.dart';
import 'package:social_app/models/users_model.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/feed/feed_screen.dart';
import 'package:social_app/modules/login_screen/login_screen.dart';
import 'package:social_app/modules/new_post/newpost_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import 'package:social_app/shared/compoments/compoments.dart';
import 'package:social_app/shared/compoments/constant.dart';
import 'package:social_app/shared/cubit/state.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:social_app/shared/styles/icon_broken.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  UsersModel? userModel;

  void GetUserData() {
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = UsersModel.Fromjson(value.data()!);
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetUserErrorState(error.toString()));
    });
  }


  int currentIndex = 0;

  List<Widget> Screens = [
    FeedScreen(),
    ChatsScreen(),
    PostScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];

  List<String> titles = [
    'Home',
    'Chats',
    'Post',
    'Users',
    'Settings',
  ];

  void changeBottomNav(int index) {
    if(index ==1){
      GetAllUsers();
    }
    if (index == 2) {
      emit(SocialAddNewPostState());
    } else {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }

  //--------------------------------Profil--------------------
  File? ProfilImage;

  var picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      ProfilImage = File(pickedFile.path);
      emit(SocialchangeImageSuccessState());
    } else {
      print('No image selected.');
      emit(SocialchangeImageErrorState());
    }
  }

  File? coverImage;

  Future getcoverImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialchangeCoverImageSuccessState());
    } else {
      print('No image selected.');
      emit(SocialchangeCoverImageErrorState());
    }
  }

  void UploadProfilImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialUpdateUserLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(ProfilImage!.path).pathSegments.last}')
        .putFile(ProfilImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        UpdateUserData(
          name: name,
          phone: phone,
          bio: bio,
          profilimage: value,
        );
        //emit(SocialUploadProfilImageSuccessState());
      }).catchError((error) {
        emit(SocialUploadProfilImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadProfilImageErrorState());
    });
  }

  void UploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialUpdateUserLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        UpdateUserData(
          name: name,
          phone: phone,
          bio: bio,
          coverimage: value,
        );
        //emit(SocialUploadCoverImageSuccessState());
      }).catchError((error) {
        emit(SocialUploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadCoverImageErrorState());
    });
  }

  void UpdateUserData({
    required String name,
    required String phone,
    required String bio,
    String? profilimage,
    String? coverimage,
  }) {
    UsersModel model = UsersModel(
      email: userModel!.email,
      name: name,
      phone: phone,
      uId: userModel!.uId,
      image: profilimage ?? userModel!.image,
      cover: coverimage ?? userModel!.cover,
      bio: bio,
      isEmailVerified: false,
    );

    emit(SocialUpdateUserLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.ToMap())
        .then((value) {
      GetUserData();
    }).catchError((error) {
      emit(SocialUpdateUserErrorState());
    });
  }
//------------------post---------------------------------------------
  File? PostImage;

  Future getPostImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      PostImage = File(pickedFile.path);
      emit(SocialUploadPostImageSuccessState());
    } else {
      print('No image selected.');
      emit(SocialUploadPostImageErrorState());
    }
  }

  void RemovePostImage() {
    PostImage = null;
    emit(SocialRemovePostImageState());
  }

  //post with image and text
  void UploadPostImage({
    required String postText,
    required String dateTime,
  }) {
    emit(SocialAddPostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(PostImage!.path).pathSegments.last}')
        .putFile(PostImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        CreatePost(
          postText: postText,
          dateTime: dateTime,
          postImage: value,
        );
      }).catchError((error) {
        emit(SocialAddPostErrorState());
      });
    }).catchError((error) {
      emit(SocialAddPostErrorState());
    });
  }

  void CreatePost({
    required String postText,
    String? postImage,
    required String dateTime,
  }) {
    PostsModel model = PostsModel(
      name: userModel!.name,
      uId: userModel!.uId,
      image: userModel!.image,
      postText: postText,
      postImage: postImage ?? '',
      dateTime: dateTime,
    );

    emit(SocialAddPostLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.ToMap())
        .then((value) {
      emit(SocialAddPostSuccessState());
    }).catchError((error) {
      emit(SocialAddPostErrorState());
    });
  }

  List<PostsModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];


  void GetPosts() {
    emit(SocialGetPostLoadingState());
    FirebaseFirestore.instance.collection('posts')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
          event.docs.forEach((element) {
            element.reference.collection('comments').snapshots().listen((event) {
              commentNumber.add(event.docs.length);
            });
            element.reference.collection('likes').snapshots().listen((event) {
              likes.add(event.docs.length);
              postsId.add(element.id);
              posts.add(PostsModel.Fromjson(element.data()));
              emit(SocialGetAllPostsSuccessState());
            });
          });
        });
      emit(SocialGetPostSuccessState());
        /*.get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
          //print(likes);
          postsId.add(element.id);
          //print(postsId);
          posts.add(PostsModel.Fromjson(element.data()));
          //print(element.data());
          emit(SocialGetAllPostsSuccessState());
        }).catchError((error) {});
      });
      emit(SocialGetPostSuccessState());
    }).catchError((error) {
      emit(SocialGetPostErrorState(error.toString()));
    });*/
  }

  //------------------------------------Like----------------------
  void LikePosts(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({
      'like': true,
    }).then((value) {
      emit(SocialLikePostSuccessState());
    }).catchError((error) {
      emit(SocialLikePostErrorState(error.toString()));
    });
  }



  //------------------------------------Comment---------------------


  void CommentPost(
      {required String postId,
      required String commentText,
      required String dateTime}) {
    CommentsModel model = CommentsModel(
      name: userModel!.name,
      uId: userModel!.uId,
      image: userModel!.image,
      dateTime: dateTime,
      commentText: commentText,
      postID: postId,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(model.ToMap())
        .then((value) {
      emit(SocialCommentPostSuccessState());
    }).catchError((error) {
      emit(SocialCommentPostErrorState(error.toString()));
    });
  }


  CommentsModel? commentsModel;
  List<CommentsModel> comments = [];
  List<int> commentNumber = [];
  void getComments({required PostsModel model}) {
    emit(SocialGetCommentPostLoadingState());
     FirebaseFirestore.instance
         .collection('posts')
         .doc(model.postID!.trim())
         .collection('comments')
         .orderBy('dateTime')
         .snapshots()
         .listen((event) {
          comments = [];
          event.docs.forEach((element) {
            comments.add(CommentsModel.Fromjson(element.data()));
          });
          emit(SocialGetCommentPostSuccessState());
     });
  }



  //------------------------------Chat-------------------------

  List<UsersModel> allUsers=[];
  void GetAllUsers() {
    if (allUsers.length == 0) {
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if(element.data()['uId'] != userModel!.uId)
          allUsers.add(UsersModel.Fromjson(element.data()));
        });
        emit(SocialGetAllUsersSuccessState());
      }).catchError((error) {
        emit(SocialGetAllUsersErrorState(error.toString()));
      });
    }
  }


  void sendMessage({
    required String recieverID,
    required String textMessage,
    required String dateTime,
    String? chatImage,
}){
    MessagesModel messagesModel=MessagesModel(
      senderUid: userModel!.uId,
      recieverUid: recieverID,
      textmessage: textMessage,
      dateTime: dateTime,
      chatImage: chatImage ?? null,
    );
    //set my chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(recieverID)
        .collection('messages')
        .add(messagesModel.ToMap()).then((value) {
      emit(SocialSendMessagesSuccessState());
    }).catchError((error){
      emit(SocialSendMessagesErrorState());
    });

    //set reciever chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(recieverID)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(messagesModel.ToMap()).then((value) {
      emit(SocialSendMessagesSuccessState());
    }).catchError((error){
      emit(SocialSendMessagesErrorState());
    });

  }

  List<MessagesModel> messages=[];
  void getMessages({
    required String recieverID,
}){
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(recieverID)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event)
    {
      messages=[];
      print(event.docs.length);
      event.docs.forEach((element) {
        messages.add(MessagesModel.Fromjson(element.data()));
      });
      emit(SocialGetMessagesSuccessState());
    });
  }

  File? ChatImage;

  Future getChatImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      ChatImage = File(pickedFile.path);
      emit(SocialUploadChatImageSuccessState());
    } else {
      print('No image selected.');
      emit(SocialUploadChatImageErrorState());
    }
  }

  //post with image and text
  void UploadChatImage({
    required String recieverID,
    required String textMessage,
    required String dateTime,
  }) {
    emit(SocialSendMessagesLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('chats/${Uri.file(ChatImage!.path).pathSegments.last}')
        .putFile(ChatImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        sendMessage(
         recieverID: recieverID,
          textMessage: textMessage,
          dateTime: dateTime,
          chatImage: value,
        );
      }).catchError((error) {
        emit(SocialSendMessagesErrorState());
      });
    }).catchError((error) {
      emit(SocialSendMessagesErrorState());
    });
  }

}
