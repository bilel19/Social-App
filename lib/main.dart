import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/modules/login_screen/login_screen.dart';
import 'package:social_app/shared/bloc_observer.dart';
import 'package:social_app/shared/compoments/compoments.dart';
import 'package:social_app/shared/compoments/constant.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/state.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/theme.dart';


Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('on background');
  print(message.data.toString());

  ShowToast(text: 'on message background',state: ToastStates.SUCCESS);
}

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp();

  var token= await FirebaseMessaging.instance.getToken();

  print(token);
  //when opened app forground
  FirebaseMessaging.onMessage.listen((event) {
    print('on message');
    print(event.data.toString());
    ShowToast(text: 'on message',state: ToastStates.SUCCESS);
  });
  //when click notification
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print('on message opened app');
    print(event.data.toString());

    ShowToast(text: 'on message opened app',state: ToastStates.SUCCESS);
  });
  //background
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);


  await CacheHelper.init();

  Widget widget;

  uId= CacheHelper.getData(key: 'uId');

  if(uId != null){
    widget=HomeScreen();
  }else{
    widget=LoginScreen();
  }

  runApp(MyApp(
    StartWeight: widget,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final StartWeight;
  MyApp({required this.StartWeight});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>SocialCubit()..GetUserData()..GetPosts(),
      child: BlocConsumer<SocialCubit,SocialStates>(
        listener: (context,state){},
        builder: (context,state){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lighttheme,
            home: StartWeight,
          );
        },
      ),
    );
  }
}

